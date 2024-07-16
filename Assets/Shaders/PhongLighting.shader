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
        Tags { "LightMode"="UniversalForward" } // 여러개의 빛을 받으려면 ForwardAdd
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc" // 라이팅 셰이더를 위한 유용한 변수 포함

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
                o.vertexWorld = mul(unity_ObjectToWorld, v.vertex); //월드좌표계에서의 위치
                o.uv = TRANSFORM_TEX(v.uv, _DiffuseTex); //텍스쳐 좌표의 크기와 위치를 조절
                
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
                float3 specular = pow(specularDot, _Shiness); // 강도
                float4 specularTerm = float4(specular, 1) * + _SpecColor * _LightColor0; // 색상정보 반영

                float4 finalColor = diffuseTerm + specularTerm; // diffuse 와 합침

                return finalColor;
            }
            ENDCG
        }
    }
}
