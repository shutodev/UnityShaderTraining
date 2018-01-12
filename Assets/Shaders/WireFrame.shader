﻿Shader "_MyShader/WireFrame"
{
    Properties
    {
        _LineColor ("Line Color", Color) = (1,1,1,1)
        _GridColor ("Grid Color", Color) = (1,1,1,0)
        _LineWidth ("Line Width", float) = 0.01
    }
    SubShader
    {
        Pass
        {
            Cull off
            Tags { "RenderType" = "Transparent" }
            Blend SrcAlpha OneMinusSrcAlpha
            AlphaTest Greater 0.5
        
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            uniform float4 _LineColor;
            uniform float4 _GridColor;
            uniform float _LineWidth;
        
            struct appdata
            {
                float4 vertex : POSITION;
                float4 uv : TEXCOORD0;
                float4 color : COLOR;
            };
        
            struct v2f
            {
                float4 pos : POSITION;
                float4 uv : TEXCOORD0;
                float4 color : COLOR;
            };
        
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.color = v.color;
                return o;
            }
        
            fixed4 frag(v2f i) : COLOR
            {
                fixed4 answer;
        
                float lx = step(_LineWidth, i.uv.x);
                float ly = step(_LineWidth, i.uv.y);
                float hx = step(i.uv.x, 1.0 - _LineWidth);
                float hy = step(i.uv.y, 1.0 - _LineWidth);
        
                answer = lerp(_LineColor, _GridColor, lx*ly*hx*hy);
        
                return answer;
            }
            ENDCG
        }
    }
}