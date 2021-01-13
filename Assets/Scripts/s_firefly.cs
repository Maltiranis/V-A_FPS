using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class s_firefly : MonoBehaviour
{
    //public GameObject _firefly;
    s_projectileDamage pDam;
    [SerializeField] private float _ffRange = 5.0f;
    bool given = false;

    // Start is called before the first frame update
    void Start()
    {
        if (GetComponent<s_projectileDamage>() != null)
        {
            pDam = GetComponent<s_projectileDamage>();
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (pDam._collided == true)
        {
            if (given == false)
                GiveFireFly();
        }
    }

    void GiveFireFly()
    {
        GameObject[] enemy = GameObject.FindGameObjectsWithTag("enemy");

        foreach (var e in enemy)
        {
            Vector3 ePos = e.transform.position;
            Vector3 aPos = transform.position;
            float dist = Vector3.Distance(ePos, aPos);

            if (dist <= _ffRange)
            {
                for (int i = 0; i < e.transform.childCount; i++)
                {
                    if (e.transform.GetChild(i).name == "FireFlyes")
                    {
                        e.transform.GetChild(i).gameObject.SetActive(true);
                    }
                }
            }
        }
    }
}
