Shader "_MyShader/VertexNoise"
{
    Properties
    { 
        _Tint ("Tint Color", Color) = (1,1,1,1) 
        _MainTex ("Main Texture", 2D) = "white" {}
    } 
    SubShader
    {
        Pass
        {
            Tags { "LightMode"="ForwardBase" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "ShaderUtility.cginc"

            float4 _Tint;
            sampler2D _MainTex;
            float4 _MainTex_ST;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
                float4 normal : NORMAL; 
            };
            struct v2f
            { 
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1; 
            };

            v2f vert(appdata v)
            {
                v2f o; 
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.pos = UnityObjectToClipPos(v.vertex) + float4(o.normal.xyz * (fBm(o.uv) - 0.5) * 5.0, 0.0);
                return o; 
            }

            fixed4 frag(v2f i) : SV_Target
            { 
                half3 normalDir = normalize(i.normal); 
                half3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                half NdotL = max(0, dot(normalDir, lightDir)); 
                half diffuse = NdotL * 0.5 + 0.5; 
                fixed4 col = tex2D(_MainTex, i.uv); 
                return col * _Tint * diffuse;
            } 

            ENDCG
        }
    }
}
