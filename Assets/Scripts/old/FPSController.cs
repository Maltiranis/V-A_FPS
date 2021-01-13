using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FPSController : MonoBehaviour
{
    public float _xRotSpeed = 10f;
    public float _yRotSpeed = 10f;

    public float _playerSpeed = 10f;
    public float _jumpForce = 100f;

    public float _crouchHeight = 1f;

    public GameObject Head;
    Rigidbody rig;

    float movX;
    float movY;
    float rotX;
    float rotY;
    Vector3 moveHorizontal;
    Vector3 movVertical;
    Vector3 bodyRot;
    Vector3 velocity;

    void Start()
    {
        rig = GetComponent<Rigidbody>();
    }

    void Update()
    {
        movX = Input.GetAxisRaw("Horizontal");
        movY = Input.GetAxisRaw("Vertical");

        moveHorizontal = transform.right * movX;
        movVertical = transform.forward * movY;

        velocity = (moveHorizontal + movVertical).normalized * _playerSpeed;

        rotY = Input.GetAxisRaw("Mouse X") * _yRotSpeed;
        bodyRot = new Vector3(0, rotY, 0);

        rotX += Input.GetAxisRaw("Mouse Y") * _xRotSpeed;

        rotX = Mathf.Clamp(rotX, -90, 90);

        if (velocity != Vector3.zero)
        {
            rig.MovePosition(rig.position + velocity * Time.deltaTime);
        }
        else
        {
            rig.Sleep();
        }

        if (bodyRot != Vector3.zero)
        {
            rig.MoveRotation(rig.rotation * Quaternion.Euler(bodyRot));
        }
        Head.transform.localEulerAngles = new Vector3(-rotX, Head.transform.localEulerAngles.y, Head.transform.localEulerAngles.z);
    }
}
