Shader "_MyShader/NoiseVanish"
{
    Properties
    { 
        _Tint ("Tint Color", Color) = (1,1,1,1)
        _VanishThreshold ("Vanish Threshold", Range(0, 1.5)) = 1
        _ThresholdBlur ("Threshold Blur", Range(0, 0.499999)) = 0
        [KeywordEnum(Fade, Add, White)] _Boundary ("Boundary Type", Float) = 0
        _AddPower ("Threshold Blur", Range(1, 10)) = 5
        _MainTex ("Main Texture", 2D) = "white" {}
        _MapTex ("Map Texture", 2D) = "white" {}
    } 
    SubShader
    {
        Tags { "Queue"="Transparent" "LightMode"="ForwardBase" "RenderType"="Transparent" }

        // このSubShaderのブレンド方法を指定する
        // Blend このシェーダが生成する色のブレンド係数 画面にすでにある色のブレンド係数
        // https://docs.unity3d.com/jp/540/Manual/SL-Blend.html
        Blend SrcAlpha OneMinusSrcAlpha
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile _BOUNDARY_FADE _BOUNDARY_ADD _BOUNDARY_WHITE
            #include "UnityCG.cginc"
            #include "ShaderUtility.cginc"

            float4 _Tint;
            sampler2D _MainTex;
            sampler2D _MapTex;
            float _VanishThreshold;
            float _ThresholdBlur;
            float _AddPower;
            float4 _MainTex_ST;
            float4 _MapTex_ST;

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
                o.pos = UnityObjectToClipPos(v.vertex); 
                o.uv = v.texcoord; 
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o; 
            } 

            fixed4 frag(v2f i) : SV_Target
            { 
                half3 normalDir = normalize(i.normal); 
                half3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                half NdotL = max(0, dot(normalDir, lightDir)); 
                half diffuse = NdotL * 0.5 + 0.5;
                fixed4 col = tex2D(_MainTex, TRANSFORM_TEX(i.uv, _MainTex));
                float mapValue = tex2D(_MapTex, TRANSFORM_TEX(i.uv, _MapTex)).x;
                if(mapValue < _VanishThreshold && mapValue >= _VanishThreshold - _ThresholdBlur) {
#ifdef _BOUNDARY_FADE
                    col.a *= map(mapValue, _VanishThreshold - _ThresholdBlur, _VanishThreshold, 0, 1);
#elif _BOUNDARY_ADD
                    col.rgb *= map(mapValue, _VanishThreshold - _ThresholdBlur, _VanishThreshold, _AddPower, 1);
#elif _BOUNDARY_WHITE
                    col.rgb = 1;
#endif
                } else if (mapValue < _VanishThreshold) {
                    col.a = 0;
                }
                return col * _Tint * diffuse;
            }

            ENDCG
        }
    }
}
