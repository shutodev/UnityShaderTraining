// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "_MyShader/SimpleDisplacement" {
    Properties { 
        _Tint ("Tint Color", Color) = (1,1,1,1)
        _DisplacementX ("DisplacementX", Range(-1, 1)) = 0
        _DisplacementY ("DisplacementY", Range(-1, 1)) = 0
        _MainTex ("Main Texture", 2D) = "white" {}
        _MapTex ("Map Texture", 2D) = "white" {}
    } 
    SubShader {
        Pass {
            Tags { "LightMode"="ForwardBase" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            float4 _Tint;
            float _DisplacementX;
            float _DisplacementY;
            sampler2D _MainTex;
            sampler2D _MapTex;

            struct appdata {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
                float4 normal : NORMAL; 
            };
            struct v2f { 
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1; 
            };

            v2f vert(appdata v) {
                v2f o; 
                o.pos = UnityObjectToClipPos(v.vertex); 
                o.uv = v.texcoord; 
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o; 
            } 

            fixed4 frag(v2f i) : SV_Target { 
                half3 normalDir = normalize(i.normal); 
                half3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                half NdotL = max(0, dot(normalDir, lightDir)); 
                half diffuse = NdotL * 0.5 + 0.5;
                float2 movedMapUV = float2(i.uv.x, (i.uv.y - _Time.x * 4.0) % 1.0);
                fixed4 col = tex2D(_MainTex, float2(clamp(i.uv.x + _DisplacementX * tex2D(_MapTex, movedMapUV).x, 0, 1), clamp(i.uv.y + _DisplacementY * tex2D(_MapTex, movedMapUV).x, 0, 1))); 
                return col * _Tint * diffuse;
            }

            /*fixed4 getDisplaceColor(float displacementValue) {
                return 
            }*/

            ENDCG
        }
    }
}
