Shader "Custom/PhongLighting"
{
    Properties
    {
        _Color("Base Color", Color) = (1,0,0,1)
        _DiffuseTex("Diffuse Texture", 2D) = "white"{}
        _Ambient("Ambient", Range(0, 1)) = 0.25
        _SpecColor("Specular Material Color", Color) = (1,1,1,1)
        _Shiness("Shiness", Float) = 10
    }
    SubShader
    {
        Tags { "LightMode"="UniversalForward" } // �������� ���� �������� ForwardAdd
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc" // ������ ���̴��� ���� ������ ���� ����

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertexClip : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float2 uv : TEXCOORD1;
                float4 vertexWorld : TEXCOORD2;
                
            };

            float4 _Color;
            sampler2D _DiffuseTex;
            float4 _DiffuseTex_ST;
            float _Ambient;
            
            float _Shiness;
            
            v2f vert (appdata v)
            {
                v2f o;
                
                o.vertexClip = UnityObjectToClipPos(v.vertex);
                o.vertexWorld = mul(unity_ObjectToWorld, v.vertex); //������ǥ�迡���� ��ġ
                o.uv = TRANSFORM_TEX(v.uv, _DiffuseTex); //�ؽ��� ��ǥ�� ũ��� ��ġ�� ����
                
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldNormal = worldNormal;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 normalDirection = normalize(i.worldNormal);
                float3 viewDirection = normalize(UnityWorldSpaceViewDir(i.vertexWorld));
                float3 lightDirection = normalize(UnityWorldSpaceLightDir(i.vertexWorld));

                float4 tex = tex2D(_DiffuseTex, i.uv);
                // Diffuse
                float nl = max(_Ambient, dot(normalDirection, _WorldSpaceLightPos0.xyz));
                float4 diffuseTerm = nl * _Color * _LightColor0 * tex;

                // Specular

                float3 reflectionDirection = reflect(-lightDirection, normalDirection); // reflect vector
                float3 specularDot = max(0.0, dot(viewDirection, reflectionDirection)); // dot product
                float3 specular = pow(specularDot, _Shiness); // ����
                float4 specularTerm = float4(specular, 1) * + _SpecColor * _LightColor0; // �������� �ݿ�

                float4 finalColor = diffuseTerm + specularTerm; // diffuse �� ��ħ

                return finalColor;
            }
            ENDCG
        }
    }
}
