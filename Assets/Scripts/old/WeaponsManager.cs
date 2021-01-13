using System.Collections;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

/*public class WeaponsManager : MonoBehaviour
{
	public Camera _cam = null; //la camera
	public GameObject[] _weapon; //L'objet contenant l'arme
	public GameObject[] _menuUI; //Le UI des armes
	public Transform _muzzle;
	//WeaponID ID;
	public int _weaponID = 0;
	public int _menuID = 0;
	public bool _isUsable; //Si l'arme est utilisable / possedée

	public bool inMenu = false;
	public bool canFire = true;
	
	public TextMeshProUGUI inClip = null;
	public TextMeshProUGUI inBag = null;
	public TextMeshProUGUI secondaryAmmo = null;
	public Color _selectedColor;

	private Ray ray;
	private RaycastHit hit;

	public string _enemyTag = "enemy";

	void Start()
	{
		ID = _weapon[_weaponID].GetComponent<IDManager>().myID;
		foreach (GameObject wp in _weapon)
		{
			wp.GetComponent<IDManager>().myID._munInClip = wp.GetComponent<IDManager>().myID._munMaxInClip;
			wp.GetComponent<IDManager>().myID._munInBag = wp.GetComponent<IDManager>().myID._munMaxInBag;
			
			wp.SetActive(false);
		}
		_weapon[0].SetActive(true);

		Cursor.lockState = CursorLockMode.Locked;
		Cursor.visible = false;
	}

	void Update()
	{
		if (Input.GetKeyDown(KeyCode.R))
		{
			Reload();
		}
		InMenu();
		LimitsManager();
		//RaycastedFire();
		PhysicalFire();
		Bag();
	}

	public void Bag()
	{
		//inClip.text = ID._munInClip.ToString();
		//inBag.text = ID._munInBag.ToString();
	}

	public void LimitsManager ()
	{
		/*if (ID._munInBag >= ID._munMaxInBag)
		{
			ID._munInBag = ID._munMaxInBag;
		}
	}

	/*public void InMenu ()
	{
		if (Input.GetButtonUp("Fire1") && inMenu == true)
		{
			_weaponID = _menuID;
			inMenu = false;
			canFire = true;
			foreach (GameObject w in _weapon)
			{
				w.SetActive(false);
			}
			_weapon[_weaponID].SetActive(true);
			ID = _weapon[_weaponID].GetComponent<IDManager>().myID;
		}

		if (Input.GetAxis("Mouse ScrollWheel") != 0f)
		{
			inMenu = true;
		}

		if (Input.GetAxis("Mouse ScrollWheel") > 0f) // forward
		{
			if (_menuID > 0)
			{ 
				ButtonColor(Color.white, _menuID);
				_menuID--;
				ButtonColor(_selectedColor, _menuID);
			}
			else
			{
				ButtonColor(Color.white, _menuID);
				_menuID = _weapon.Length - 1;
				ButtonColor(_selectedColor, _menuID);
			}
		}
		else if (Input.GetAxis("Mouse ScrollWheel") < 0f) // backwards
		{
			if (_menuID < _weapon.Length - 1)
			{
				ButtonColor(Color.white, _menuID);
				_menuID++;
				ButtonColor(_selectedColor, _menuID);
			}
			else
			{
				ButtonColor(Color.white, _menuID);
				_menuID = 0;
				ButtonColor(_selectedColor, _menuID);
			}
		}
	}

	public void ButtonColor (Color clr, int _mID)
	{
		Button b = _menuUI[_mID].GetComponent<Button>();
		ColorBlock cb = b.colors;
		cb.normalColor = clr;
		b.colors = cb;
	}


	public void RaycastedFire()
	{
		if (Input.GetButton("Fire1") &&  ID._munInClip > 0 && inMenu == false && canFire == true)
		{
			canFire = false;
			StartCoroutine("ShootingRate", ID._fireRate);

			Vector2 ScreenCenterPoint = new Vector2(Screen.width / 2, Screen.height / 2);
			ray = _cam.ScreenPointToRay(ScreenCenterPoint);

			Vector3 fireDirection = _cam.transform.forward;
			Quaternion fireRotation = Quaternion.LookRotation(fireDirection);
			Quaternion randomRotation = Random.rotation;
			fireRotation = Quaternion.RotateTowards(fireRotation, randomRotation, Random.Range(0.0f, ID._bulletSpreadAngle));

			if (Physics.Raycast(_cam.transform.position, fireRotation * Vector3.forward, out hit, ID._maxBulletRange))
			{
				if (hit.transform.gameObject.tag == _enemyTag)
				{
					hit.transform.gameObject.GetComponent<LifeEngine>().TakeDamage(ID._damage);
				}
			}
			ID._munInClip -= 1;
		}
	}

	/*public void PhysicalFire ()
	{
		if (Input.GetButton("Fire1") && ID._munInClip > 0 && inMenu == false && canFire == true)
		{
			canFire = false;
			StartCoroutine("ShootingRate", ID._fireRate);

			Vector3 fireDirection = _muzzle.transform.forward;
			Quaternion fireRotation = Quaternion.LookRotation(fireDirection);
			Quaternion randomRotation = Random.rotation;
			fireRotation = Quaternion.RotateTowards(fireRotation, randomRotation, Random.Range(0, ID._bulletSpreadAngle));

			GameObject blt = Instantiate(ID._bulletPhysical, _muzzle.position, fireRotation);
			blt.GetComponent<Rigidbody>().AddForce((blt.transform.forward * ID._bulletSpeed) * 100, ForceMode.Impulse);

			ID._munInClip -= 1;
		}
	}

	public IEnumerator ShootingRate (float rate)
	{
		yield return new WaitForSeconds(rate);
		canFire = true;
	}

	/*public void Reload()
	{
		if (ID._munInBag + ID._munInClip > ID._munMaxInClip)
		{
			ID._munInBag -= ID._munMaxInClip - ID._munInClip;
			ID._munInClip += ID._munMaxInClip - ID._munInClip;
		}
		else if (ID._munInBag + ID._munInClip <= ID._munMaxInBag)
		{
			ID._munInClip += ID._munInBag;
			ID._munInBag = 0;
		}
	}

	void OnTriggerEnter(Collider other)
	{
		if (other.gameObject.tag == "ammo" + _weaponID.ToString())
		{
			ID._munInBag += ID._munMaxInClip;
		}
	}
}
*/