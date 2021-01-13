using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine.UI;
using UnityEngine;

[RequireComponent(typeof(s_useWeapons))]
public class s_UIElements : MonoBehaviour
{
    [Header("UI Container")]
    [SerializeField] private TMP_Text _inClipUI;
    [SerializeField] private TMP_Text _maxClipUI;
    [SerializeField] private TMP_Text _inBagUI;
    [SerializeField] private TMP_Text _maxBagUI;
    [SerializeField] private Slider _strengthSlider;

    [Header("Variables Container")]
    public s_useWeapons uw;

    void Start()
    {
        uw = GetComponent<s_useWeapons>();
    }

    void LateUpdate()
    {
        if (_inClipUI != null)
            _inClipUI.text = uw._inBag._inClip.ToString();

        if (_maxClipUI != null)
            _maxClipUI.text = uw._inBag._munMaxInClip.ToString();

        if (_inBagUI != null)
            _inBagUI.text = uw._inBag._munInBag.ToString();

        if (_maxBagUI != null)
            _maxBagUI.text = uw._inBag._munMaxInBag.ToString();

        if (_strengthSlider != null)
        {
            _strengthSlider.minValue = uw._inBag._strengthMax * 2 / 3;
            _strengthSlider.maxValue = uw._inBag._strengthMax;
            _strengthSlider.value = uw.throwStrength;
        }
    }
}
