using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class s_projectileVelOrientation : MonoBehaviour
{
    Rigidbody rb;

    // Start is called before the first frame update
    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        if (Mathf.Abs(rb.velocity.x + rb.velocity.y + rb.velocity.z) > 1.0f)
            transform.rotation = Quaternion.LookRotation(rb.velocity);
    }
}
