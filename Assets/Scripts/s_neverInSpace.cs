using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class s_neverInSpace : MonoBehaviour
{
    public float _spaceRim = -10.0f;
    public Vector3 _safePlace;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (transform.position.y < _spaceRim)
        {
            transform.position = _safePlace;
        }
    }
}
