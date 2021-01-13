using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;

public class s_PlayerController : MonoBehaviour
{
    [Header("Variables")]
    [SerializeField] private float _axesSpeed = 100f;
    [SerializeField] private float _walkingSpeed = 10f;
    [SerializeField] private float _runningSpeed = 20f;
    [SerializeField] private float _crouchHeight = 2f;
    [SerializeField] private float _headHeight = 1.5f;
    [SerializeField] private float _jumpforce = 150f;
    float speed = 0f;
    float xRot = 0f;
    LayerMask layerMask = ~(1 << 6);
    bool canJump = true;
    bool canRayFeet = false;

    [Header("Inputs")]
    [SerializeField] private string _forward = "z";
    [SerializeField] private string _backward = "s";
    [SerializeField] private string _left = "q";
    [SerializeField] private string _right = "d";
    [SerializeField] private string _crouch = "left ctrl";
    [SerializeField] private string _jump = "space";
    [SerializeField] private string _walk = "left shift";

    [Header("Rigidbody")]
    Rigidbody rb;

    [Header("Colliders")]
    CapsuleCollider cc;

    [Header("Transforms")]
    Transform headT;
    [SerializeField] private GameObject _camHolder;
    Vector3 upVector;
    Transform collided;

    // Start is called before the first frame update
    void Start()
    {
        CreateHead();
        //CreateBody();

        cc = GetComponent<CapsuleCollider>();
        rb = GetComponent<Rigidbody>();

        speed = _runningSpeed;
        upVector = transform.up;

        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;

        if (GetComponent<s_useWeapons>() != null)
        {
            GetComponent<s_useWeapons>().OnStart();
        }
    }

    // Update is called once per frame
    void Update()
    {
        InputManager();
        RaycastingFeet();

        rb.AddForce(Vector3.down * 80.0f);
    }

    void InputManager()
    {
        float mouseX = Input.GetAxis("Mouse X") * _axesSpeed * Time.deltaTime;
        float mouseY = Input.GetAxis("Mouse Y") * _axesSpeed * Time.deltaTime;

        xRot -= mouseY;
        xRot = Mathf.Clamp(xRot, -90.0f, 90.0f);

        headT.localRotation = Quaternion.Euler(xRot, 0.0f, 0.0f);
        transform.Rotate(transform.up * mouseX, Space.Self);

        //Displacement
        if (Input.GetKey(_forward))
        {
            transform.Translate(Vector3.forward * speed * Time.deltaTime, Space.Self);
        }
        if (Input.GetKey(_backward))
        {
            transform.Translate(-Vector3.forward * speed * Time.deltaTime, Space.Self);
        }
        if (Input.GetKey(_left))
        {
            transform.Translate(-Vector3.right * speed * Time.deltaTime, Space.Self);
        }
        if (Input.GetKey(_right))
        {
            transform.Translate(Vector3.right * speed * Time.deltaTime, Space.Self);
        }
        //Crouching
        if (Input.GetKey(_crouch))
        {
            speed = _walkingSpeed;
            Crouching(true);
        }
        else
        {
            if (roofCheck())
            {
                speed = _runningSpeed;
                Crouching(false);
            }
        }
        //Walking
        if (Input.GetKey(_walk))
        {
            speed = _walkingSpeed;
        }
        else
        {
            speed = _runningSpeed;
        }
        //Jumpink
        if (Input.GetKeyDown(_jump) && canJump == true)
        {
            Jumping();
            canJump = false;
        }
        if (Input.GetKeyUp(_jump))
        {
            canJump = false;
            StartCoroutine(JumpReload());
        }

        /*if (collided != null)
        {
            Vector3 normal = transform.position - collided.position;
            upVector = normal.normalized;
            Quaternion slopeRotation = Quaternion.FromToRotation(transform.up, upVector);

            transform.rotation = Quaternion.Lerp(transform.rotation, slopeRotation * transform.rotation, 10f * Time.fixedDeltaTime);
        }
        else
        {
            Quaternion slopeRotation = Quaternion.FromToRotation(transform.up, Vector3.up);

            transform.rotation = Quaternion.Lerp(transform.rotation, slopeRotation * transform.rotation, 1);
        }*/
    }

    bool roofCheck()
    {
        RaycastHit hit;
        if (Physics.SphereCast(transform.position + transform.up * 0.5f, 0.5f, transform.up, out hit, 0.75f, layerMask))
        {
            return false;
        }
        else
        {
            return true;
        }
    }

    IEnumerator JumpReload()
    {
        yield return new WaitForSeconds(0.1f);
        canRayFeet = true;
    }

    void RaycastingFeet()
    {
        if (canRayFeet == true)
        {
            RaycastHit hit;
            if (Physics.SphereCast(transform.position + transform.up * 0.5f, 0.5f, -transform.up, out hit, 0.5f, layerMask))
            {
                canJump = true;
            }
        }
        Debug.DrawRay(transform.position + transform.up * 0.5f, -transform.up * 0.5f, Color.yellow);
    }

    void Crouching(bool b)
    {
        if (b == true)
        {
            cc.center = new Vector3(0.0f, 3.0f / _crouchHeight, 0.0f);
            cc.height = _crouchHeight / 2.0f;
        }
        else
        {
            cc.center = new Vector3(0.0f, _crouchHeight / 2f, 0.0f);
            cc.height = _crouchHeight;
        }
    }

    void Jumping()
    {
        rb.AddForce(transform.up * _jumpforce, ForceMode.Impulse);
    }

    void CreateBody()
    {
        GameObject mesh = new GameObject();
        mesh.name = "body";
        mesh.transform.parent = transform;

        cc = gameObject.AddComponent<CapsuleCollider>();
        cc.center = transform.position + transform.up * 1;

        rb = gameObject.AddComponent<Rigidbody>();
        rb.constraints = RigidbodyConstraints.FreezeRotationX | RigidbodyConstraints.FreezeRotationZ;
        rb.drag = 5.0f;
        rb.angularDrag = 10.0f;
    }

    void CreateHead() //Création de la tête
    {
        GameObject head = new GameObject();
        head.name = "head";
        head.transform.parent = transform;
        GameObject cam = new GameObject();
        cam.name = "cameraHolder";
        //cam.AddComponent<Camera>();
        //cam.transform.parent = head.transform;
        cam = Instantiate(_camHolder, head.transform.position, head.transform.rotation);
        cam.transform.parent = head.transform;

        headT = head.transform;
        headT.position = transform.position + transform.up * _headHeight;
    }

    /*private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.tag == "Gravitar")
        {
            collided = collision.transform;
            Debug.Log("Collided");
        }
    }

    private void OnCollisionExit(Collision collision)
    {
        upVector = transform.up;
    }*/
}
