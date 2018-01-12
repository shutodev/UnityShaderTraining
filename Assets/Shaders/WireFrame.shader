// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// https://gamedevhappens.wordpress.com/2014/03/23/unity-3d-wireframe-odyssey-1-shader-method/

Shader "_MyShader/WireFrame"
{
    Properties
    {
        _LineColor ("Line Color", Color) = (1,1,1,1)
        _GridColor ("Grid Color", Color) = (0,0,0,0)
        _LineWidth ("Line Width", Range(0, 0.5)) = 0.01
    }
    SubShader
    {
        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            ZWrite Off
            CGPROGRAM
 
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
 
            uniform float4 _LineColor;
            uniform float4 _GridColor;
            uniform float _LineWidth;
 
            // vertex input: position, uv1, uv2
            struct appdata {
                float4 vertex : POSITION;
                float4 uv : TEXCOORD0;
                float4 color : COLOR;
            };
 
            struct v2f {
                float4 pos : POSITION;
                float4 uv : TEXCOORD0;
                float4 color : COLOR;
            };
 
            v2f vert (appdata v) {
                v2f o;
                o.pos = UnityObjectToClipPos( v.vertex);
                o.uv = v.uv;
                o.color = v.color;
                return o;
            }
 
            float4 frag(v2f i) : COLOR
            {
                float d = i.uv.x - i.uv.y;
                if (i.uv.x < _LineWidth)                     // 0,0 to 1,0
                    return _LineColor;
                else if(i.uv.x > 1 - _LineWidth)             // 1,0 to 1,1
                    return _LineColor;
                else if(i.uv.y < _LineWidth)                 // 0,0 to 0,1
                    return _LineColor;
                else if(i.uv.y > 1 - _LineWidth)             // 0,1 to 1,1
                    return _LineColor;
                else if(d < _LineWidth && d > -_LineWidth) // 0,0 to 1,1
                    return _LineColor;
                else
                    return _GridColor;
            }
            ENDCG
        }
    }
    Fallback "Vertex Colored", 1
}