using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class vertexColorRevise : MonoBehaviour
{
    void Start()
    {
        MeshFilter meshFilter = GetComponent<MeshFilter>();
        Mesh mesh = meshFilter.mesh;

        // 버텍스와 색상 배열 가져오기
        Vector3[] vertices = mesh.vertices;
        Color[] colors = new Color[vertices.Length];

        // 무지개 색상 설정
        for (int i = 0; i < vertices.Length; i++)
        {
            float hue = (float)i / (vertices.Length - 1); // HSV 색상 공간에서 색상 값 계산
            colors[i] = Color.HSVToRGB(hue, 1.0f, 1.0f);  // HSV 값을 RGB 색상으로 변환
        }

        // 메시에 색상 배열 설정
        mesh.colors = colors;
    }
}
