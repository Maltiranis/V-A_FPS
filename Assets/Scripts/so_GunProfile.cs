using UnityEngine;

[CreateAssetMenu(fileName = "GunProfile", menuName = "ScriptableObjects/GunProfile", order = 1)]
public class so_GunProfile : ScriptableObject
{
    public string _weaponName = "Name";
    public GameObject _weaponPrefab = null;
    public GameObject _bulletPrefab = null;
    public int _myID = 0;

    public float _maxBulletRange = 100.0f;

    public int _inClip;
    public int _munMaxInClip;

    public int _munInBag;
    public int _munMaxInBag;

    public float _weaponReloadTime = 1f;

    public float _fireRate = 0.1f;
    public float _bulletSpeed = 1000f;
    public bool _needLoading = false; 

    public int _damage = 10;
}
