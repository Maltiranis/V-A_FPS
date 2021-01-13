using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class s_projectileDamage : MonoBehaviour
{
    public float _lifeTime = 15.0f;
    public float rayRange = 1.0f;
    LayerMask layerMask = ~(1 << 6);
    [HideInInspector] public int _damage = 0;
    [HideInInspector] public bool _collided = false;

    void Start()
    {

    }

    private void Update()
    {
        RaycastHit hit;
        Debug.DrawRay(transform.position, transform.forward * rayRange, Color.red);

        if (Physics.Raycast(transform.position, transform.forward, out hit, rayRange, layerMask))
        {
            if (hit.transform.gameObject != null)
            {
                if (hit.transform.GetComponent<s_lifeEngine>() != null)
                {
                    hit.transform.GetComponent<s_lifeEngine>().TakeDamage(_damage);
                    Destroy(gameObject, 0f);
                    _collided = true;
                }
                else
                {
                    if (hit.transform.tag != "Player")
                    {
                        transform.position = hit.point - rayRange * transform.forward;
                        GetComponent<Rigidbody>().isKinematic = true;
                        Destroy(gameObject, _lifeTime);
                        _collided = true;
                    }
                }
            }
        }
    }
}
