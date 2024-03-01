Shader "Unlit/Gradient"
{
	Properties
	{
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex("Main Texture", 2D) = "white"{}
		_SecTex("Secondary Texture", 2D) = "black"{}
	}
	SubShader
	{
		Tags{
			"Queue" = "Transparent"
			"RenderType" = "Transparent"
			"IgnoreProjector" = "True"
		}
		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			uniform half4 _Color;

			struct VertexInput
			{
				float4 vertex: POSITION;
				float4 texcoord: TEXCOORD0;
			};

			struct VertexOutput
			{
				float4 pos: SV_POSITION;
				float4 texcoord: TEXCOORD0;
			};

			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform sampler2D _SecTex;

			VertexOutput vert(VertexInput v)
			{
				VertexOutput o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
				return o;
			}

			half4 frag(VertexOutput i): COLOR 
			{
				float4 color = (tex2D(_MainTex, i.texcoord) * (1.0-i.texcoord.x)) + (tex2D(_SecTex, i.texcoord)*i.texcoord.x);
				color.a = 1.0;
				return color;
			}

		  
			ENDCG
		}
	}
}
