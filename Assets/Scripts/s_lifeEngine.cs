using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class s_lifeEngine : MonoBehaviour
{
    public int _life = 100;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void TakeDamage (int dmg)
    {
        if (_life > 0)
        {
            _life -= dmg;
        }
        else
        {
            Destroy(gameObject, 0f);
        }
    }
}
