Shader "Unlit/Wave"
{
	Properties
	{
		_Color ("Main Color", Color) = (1,1,1,1)
		_SecColor ("Secondary Color", Color) = (0,0,0,1)
		_MainTex("Main Texture", 2D) = "white"{}
		_Height("Wave Height", float) = 0.1
		_Speed("Wave Speed",float) = 0.1
		_Frequency("Wave Frequency", float) = 0.1
		_Amplitude("Wave Amplitude", float) = 0.1

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
				//float displacement: TESSFACTOR0;
				float4 displacementColor : COLOR;
			};

			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;

			float4 vertexAnimWave(float4 pos, float2 uv)
			{
			   pos.y = pos.y + sin((uv.x - _Time.y * _Speed) * _Frequency) * _Amplitude;
			   //pos.y = pos.y + sin((uv.y - _Time.y * _Speed) * _Frequency) * _Amplitude;
			   return pos;
			}


			VertexOutput vert(VertexInput v)
			{
				VertexOutput o;
				float4 offset = tex2Dlod(_MainTex, v.texcoord* _MainTex_ST);
				v.vertex = vertexAnimWave(v.vertex,v.texcoord.xy);
				float newPosY = (v.vertex.y+offset.x);
				o.displacementColor = ((newPosY * _Color) + ((1.0 - newPosY)*_SecColor));
				o.pos = UnityObjectToClipPos(v.vertex + (offset.x * v.normal * _Height));
				o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
				return o;
			}

			half4 frag(VertexOutput i): COLOR 
			{
				float4 color = i.displacementColor;
				color.a = 1.0;
				return color;
			}

		  
			ENDCG
		}
	}
}
