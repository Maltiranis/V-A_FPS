using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class s_timedDesactivate : MonoBehaviour
{
    [SerializeField] private float _unactiveTimer = 5.0f;

    private void OnEnable()
    {
        StartCoroutine(unEnable());
    }

    IEnumerator unEnable()
    {
        yield return new WaitForSeconds(_unactiveTimer);
        gameObject.SetActive(false);
    }
}
