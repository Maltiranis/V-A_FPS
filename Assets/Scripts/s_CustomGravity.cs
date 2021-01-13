using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class s_CustomGravity : MonoBehaviour
{
    [SerializeField] private float gravRangMultiply = 1.0f;
    [Range(-1, 1)]
    [SerializeField] private int gravityGlobalDir = 1;
    [SerializeField] public GameObject[] _gravitars;
    Transform[] gravitTs;
    Rigidbody[] gravitRs;
    float[] dists;
    float[] masss;
    Rigidbody prb;
    Vector3 sumsGrav;

    void Start()
    {
        prb = GetComponent<Rigidbody>();
        _gravitars = new GameObject[GameObject.FindGameObjectsWithTag("Gravitar").Length];

        gravitTs = new Transform[_gravitars.Length];
        gravitRs = new Rigidbody[_gravitars.Length];
        dists = new float[_gravitars.Length];
        masss = new float[_gravitars.Length];

        _gravitars = GameObject.FindGameObjectsWithTag("Gravitar");

        for (int i = 0; i < _gravitars.Length; i++)
        {
            gravitTs[i] = _gravitars[i].transform;
            gravitRs[i] = _gravitars[i].GetComponent<Rigidbody>();
        }
    }
    
    void Update()
    {
        for (int i = 0; i < gravitTs.Length; i++)
        {
            dists[i] = Vector3.Distance(transform.position, gravitTs[i].position);

            if (dists[i] < gravRangMultiply * gravitRs[i].mass)
            {
                GetGravity(gravitTs[i], gravitRs[i]);
            }
        }
    }

    void GetGravity(Transform t, Rigidbody r)
    {
        Vector3 dir = t.position - transform.position;
        Vector3 force = r.mass * dir.normalized;
        prb.AddForce(gravityGlobalDir * force, ForceMode.Force);
    }
}
