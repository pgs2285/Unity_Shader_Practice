using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class vertexColorRevise : MonoBehaviour
{
    void Start()
    {
        MeshFilter meshFilter = GetComponent<MeshFilter>();
        Mesh mesh = meshFilter.mesh;

        // ���ؽ��� ���� �迭 ��������
        Vector3[] vertices = mesh.vertices;
        Color[] colors = new Color[vertices.Length];

        // ������ ���� ����
        for (int i = 0; i < vertices.Length; i++)
        {
            float hue = (float)i / (vertices.Length - 1); // HSV ���� �������� ���� �� ���
            colors[i] = Color.HSVToRGB(hue, 1.0f, 1.0f);  // HSV ���� RGB �������� ��ȯ
        }

        // �޽ÿ� ���� �迭 ����
        mesh.colors = colors;
    }
}
