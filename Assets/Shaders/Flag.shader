Shader "Unlit/Flag"
{
	Properties
	{
		_Color ("Main Color", Color) = (1,1,1,1)
		_SecColor ("Secondary Color", Color) = (0,0,0,1)
		_MainTex("Main Texture", 2D) = "white"{}
		_Speed("Flag Wave Speed",float) = 0.1
		_Frequency("Flag Wave Frequency", float) = 0.1
		_Amplitude("Flag Wave Amplitude", float) = 0.1

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
			LOD 200
			CULL Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			uniform half4 _Color;
			uniform half4 _SecColor;
			uniform float _Speed;
			uniform float _Frequency;
			uniform float _Amplitude;

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

			float4 vertexAnimFlag(float4 pos, float2 uv)
			{
			   pos.z = pos.z + sin((uv.x - _Time.y * _Speed) * _Frequency) * _Amplitude*uv.x;
			   return pos;
			}


			VertexOutput vert(VertexInput v)
			{
				VertexOutput o;
				float displacement = tex2Dlod(_MainTex, v.texcoord* _MainTex_ST);
				v.vertex = vertexAnimFlag(v.vertex,v.texcoord.xy);
				o.pos = UnityObjectToClipPos(v.vertex);
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
