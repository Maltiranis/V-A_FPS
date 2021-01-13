using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class s_useWeapons : MonoBehaviour
{
    [Header("Inputs")]
    [SerializeField] private string _shoot = "mouse 0";
    [SerializeField] private string _reload = "r";
    [SerializeField] private string _zoom = "mouse 1";

    [Header("Variables Container")]
    public so_GunProfile gp;

    [Header("Globals")]
    LayerMask layerMask = ~(1 << 6);
    public Vector3 _fireOffset;
    public Vector3 _launcherOffset;
    public Quaternion _launcherRot;
    GameObject raySpawn = null;
    bool isReloading = false;
    bool canShoot = true;

    [HideInInspector] public float throwStrength = 0.00f;
    GameObject weapon = null;
    GameObject bolt = null;
    bool projectileLoaded = true;

    [System.Serializable]
    public class InBag
    {
        [Header("Bag Content")]
        public string _weaponName = "";
        public GameObject _weaponPrefab = null;
        public GameObject _bulletPrefab = null;
        public int _myID = 0;
        public float _maxBulletRange = 0.0f;
        public int _inClip = 0;
        public int _munMaxInClip = 0;
        public int _munInBag = 0;
        public int _munMaxInBag = 0;
        public float _weaponReloadTime = 0.0f;
        public float _fireRate = 0.0f;
        public float _bulletSpeed = 0.0f;
        public bool _needLoading = false;
        public int _damage = 0;

        public float _strengthStep = 0.01f;
        public float _strengthTime = 0.01f;
        public float _strengthMax = 50f;
    }
    public InBag _inBag;


    public void OnStart()
    {
        raySpawn = new GameObject();
        raySpawn.name = "raySpawn";
        raySpawn.transform.parent = transform.GetChild(1);
        raySpawn.transform.localPosition = _fireOffset;

        SetupBag();

        //and again
        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
    }

    void Update()
    {
        FireManager();
    }

    void SetupBag()
    {
        _inBag._weaponName = gp._weaponName;

        if (gp._weaponPrefab != null)
            _inBag._weaponPrefab = gp._weaponPrefab;
        if (gp._bulletPrefab != null)
            _inBag._bulletPrefab = gp._bulletPrefab;

        _inBag._myID = gp._myID;
        _inBag._maxBulletRange = gp._maxBulletRange;
        _inBag._inClip = gp._inClip;
        _inBag._munMaxInClip = gp._munMaxInClip;
        _inBag._munInBag = gp._munInBag;
        _inBag._munMaxInBag = gp._munMaxInBag;
        _inBag._weaponReloadTime = gp._weaponReloadTime;
        _inBag._fireRate = gp._fireRate;
        _inBag._bulletSpeed = gp._bulletSpeed;
        _inBag._needLoading = gp._needLoading;
        _inBag._damage = gp._damage;
    }

    void FireManager()
    {
        //Shooting
        if (_inBag._inClip > 0 && canShoot == true && isReloading == false)
        {
            if (_inBag._needLoading == false)
            {
                ClassicShoot();
            }
            else
            {
                LauncherShoot();
            }
        }
        //Reloading
        if (Input.GetKeyDown(_reload) && isReloading == false)
        {
            if (_inBag._inClip < _inBag._munMaxInClip)
            {
                isReloading = true;
                StartCoroutine(ReloadEnum());
            }
        }
        //Zooming
        if (Input.GetKey(_zoom))
        {

        }
        else
        {

        }
    }

    void ClassicShoot()
    {
        if (Input.GetKey(_shoot))
        {
            StartCoroutine(FireRateEnum());
            Shoot();
            canShoot = false;
        }
        else
        {
            StopCoroutine(FireRateEnum());
        }
    }

    void LauncherShoot()
    {
        if (_inBag._weaponPrefab != null && projectileLoaded == true)
        {
            projectileLoaded = false;
            weapon = Instantiate(_inBag._weaponPrefab, raySpawn.transform.position + _launcherOffset, raySpawn.transform.rotation);
            weapon.transform.parent = raySpawn.transform.parent;
        }
        if (weapon != null)
        {
            weapon.transform.localPosition = _launcherOffset;
        }

        if (Input.GetKeyDown(_shoot))
        {
            //canShoot = false;
            StartCoroutine(StrenghtLoad());
        }
        if (throwStrength < _inBag._strengthMax / 2)
        {
            throwStrength = _inBag._strengthMax * 2 / 3;
        }
        if (Input.GetKeyUp(_shoot))
        {
            bolt = Instantiate(_inBag._bulletPrefab, raySpawn.transform.position, raySpawn.transform.rotation);

            bolt.GetComponent<s_projectileDamage>()._damage = _inBag._damage;

            bolt.GetComponent<Rigidbody>().AddForce(throwStrength * raySpawn.transform.forward, ForceMode.Impulse);

            bolt.GetComponent<s_projectileVelOrientation>().enabled = true;
            bolt = null;

            StopCoroutine(StrenghtLoad());
            _inBag._inClip--;
            Destroy(weapon, 0f);
            weapon = null;

            throwStrength = 0;
        }
        //Debug.Log(throwStrength);
    }

    void Shoot()
    {
        RaycastHit hit;

        if (Physics.Raycast(raySpawn.transform.position, raySpawn.transform.forward, out hit, _inBag._maxBulletRange, layerMask))
        {
            Debug.DrawRay(raySpawn.transform.position, raySpawn.transform.forward * hit.distance, Color.red);
            if (hit.transform.gameObject != null)
            {
                if (hit.transform.GetComponent<s_lifeEngine>() != null)
                {
                    hit.transform.GetComponent<s_lifeEngine>().TakeDamage(_inBag._damage);
                }
                if (hit.transform.GetComponent<Rigidbody>() != null)
                {
                    hit.transform.GetComponent<Rigidbody>().AddForce(transform.forward * 10 * _inBag._damage, ForceMode.Impulse);
                }
            }
        }

        _inBag._inClip--;
    }

    void Reload()
    {
        int refill = 0;
        refill = _inBag._munMaxInClip - _inBag._inClip;

        if(_inBag._munInBag >= refill)
        {
            _inBag._inClip += refill;
            _inBag._munInBag -= refill;
        }
        else
        {
            if (_inBag._munInBag > 0)
            {
                _inBag._inClip += _inBag._munInBag;
                _inBag._munInBag -= _inBag._munInBag;
            }
        }
    }

    IEnumerator StrenghtLoad()
    {
        yield return new WaitForSeconds(_inBag._strengthTime);

        if (throwStrength < _inBag._strengthMax && Input.GetKey(_shoot))
        {
            throwStrength += _inBag._strengthStep;
            StartCoroutine(StrenghtLoad());
        }
    }

    IEnumerator FireRateEnum()
    {
        yield return new WaitForSeconds(_inBag._fireRate);
        canShoot = true;
    }

    IEnumerator ReloadEnum()
    {
        yield return new WaitForSeconds(_inBag._weaponReloadTime);
        Reload();
        isReloading = false;
        projectileLoaded = true;
    }
}
