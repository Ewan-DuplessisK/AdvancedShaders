Shader "Unlit/Voronoise"
{
	Properties
	{
		_Color ("Main Color", Color) = (1,1,1,1)
		_SecColor ("Secondary Color", Color) = (0,0,0,1)
		_MainTex("Main Texture", 2D) = "white"{}
		_Height("Wave Height", float) = 0.1
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
			uniform half4 _SecColor;
			uniform float _Height;

			struct VertexInput
			{
			   float4 vertex: POSITION;
			   float4 normal: NORMAL;
			   float4 texcoord: TEXCOORD0;
			};


			struct VertexOutput
			{
				float4 pos: SV_POSITION;
				float4 texcoord: TEXCOORD0;
			};

			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;

			VertexOutput vert(VertexInput v)
			{
				VertexOutput o;
				float displacement = tex2Dlod(_MainTex, v.texcoord* _MainTex_ST);
				o.pos = UnityObjectToClipPos(v.vertex + (v.normal * displacement*_Height));
				o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
				return o;
			}

			half4 frag(VertexOutput i): COLOR 
			{
				float4 color = (tex2D(_MainTex, i.texcoord) * _Color) + ((1.0 - tex2D(_MainTex, i.texcoord))*_SecColor	);
				color.a = 1.0;
				return color;
			}

		  
			ENDCG
		}
	}
}
