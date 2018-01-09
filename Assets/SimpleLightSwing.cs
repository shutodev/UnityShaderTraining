using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimpleLightSwing : MonoBehaviour {
    [SerializeField] private bool enable = true;

    void Update () {
        if(!enable) return;
        var rot = transform.localRotation.eulerAngles;
        transform.localRotation = (Quaternion.Euler(45f + 40f * Mathf.Sin(Time.time * 3.141592f), 40f * Mathf.Sin(Time.time * 3.141592f / 2f), rot.z));
    }
}
