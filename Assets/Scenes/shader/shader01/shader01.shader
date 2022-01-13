Shader "Custom/shader01"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _WaveLen ("波长",Range(30,70)) = 1
        _TimeFac ("时间因子",Range(0,30)) = 1
        _curWaveDis("Dis",Range(0,10)) = 5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        half _WaveLen;
        fixed4 _Color;
        half _TimeFac;
        float _curWaveDis;
        // float4 _MainTex_ST;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed2 uv = IN.uv_MainTex - fixed2(0.5,-0.5);
            float dis = sqrt(uv.x*uv.x+uv.y*uv.y);
            float offset = 0.3 * sin(dis * _WaveLen - _Time.y*_TimeFac);
            float discardFactor = clamp(_WaveLen - abs(_curWaveDis - dis), 0, 1) / _WaveLen;
            float2 uv1 = normalize(uv);
            float2 set = uv1 * discardFactor * offset;
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex + set) * _Color;
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
