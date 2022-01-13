Shader "Unlit/shader02"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _CircleNum ("采样次数", int) = 16
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _CircleNum;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                UNITY_TRANSFER_FOG(o,o.vertex);
                o.color = v.color;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                float2 center = float2(0.5,0.5);
                float2 uv = i.uv.xy;
                uv -= center;
                float4 color = float4(0.0,0.0,0.0,0.0);
                float scale = 1.0;
                for(int i = 0; i <_CircleNum; i++){
                    color += tex2D(_MainTex, uv*scale + center);
                    scale = 1 + float(0.0085*i);
                }
                
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                color /= (float)_CircleNum; 
                return color;
            }
            ENDCG
        }
    }
}
