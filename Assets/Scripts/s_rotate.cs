using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class s_rotate : MonoBehaviour
{
    public float _rotationSpeed = 1.0f;
    
    public Vector3 _totationVector;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        transform.Rotate(_totationVector, _rotationSpeed * Time.deltaTime);
    }
}
