using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class GamePlay : MonoBehaviour {
   
    public AudioSource audioSource ;

    public GameObject grassOriginal_1;
    public GameObject grassOriginal_2;
    public GameObject grassOriginal_3;

    public GameObject GrassContainer;

    public Material mat;

    private float prevShear = 0f;

    private float maxD = 0.15f;

    private float[] spec = new float[256];
    
    void Start() {
        audioSource.Stop(); 
        audioSource.clip = Microphone.Start(Microphone.devices[2], true, 10, 44100);
        audioSource.Play();

        CreateGrass(5);
    }

    void Update() {
        audioSource.GetSpectrumData(spec, 0, FFTWindow.Hamming);

        float shear = spec[0];
       
        float maxVal = spec.Max();
        int maxIndex = spec.ToList().IndexOf(maxVal);

        Color col = mat.GetColor("_Color");
        float newR = (maxIndex / 255.0f) * 10;

        if (newR > 1.0f) {
            newR = 1.0f;
        }
        col.r = newR; 

        float dShear = shear - prevShear;
        if (dShear < - maxD) {
            shear = prevShear - maxD;
        } else if (dShear > maxD) {
            shear = prevShear + maxD;
        }
        mat.SetFloat("_Shear", shear);
        mat.SetColor("_Color", col);
    }
    
    public void CreateGrass(int grassNum) {
        GameObject[] Grasses = {grassOriginal_1, grassOriginal_2, grassOriginal_3};
        for (int j = 0; j < grassNum; j++) {
            for (int i = 0; i < grassNum; i++) {
                GameObject GrassClone = Instantiate(Grasses[(j + i) % 3], new Vector3(i * 1.5f, 0f, j * 1.5f), Grasses[(j+ i) % 3].transform.rotation);
                GrassClone.name = "GrassClone-" + (j + 1) + (i + 1);
                GrassClone.transform.parent = GrassContainer.transform;
            }
        }
    }
}
