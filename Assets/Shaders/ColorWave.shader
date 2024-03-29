Shader "Unlit/ColorWave"
{
	Properties
	{
		_Height("Wave Height", float) = 0.1
		_Speed("Wave Speed",float) = 0.1
		_Frequency("Red/X Frequency", float) = 6
		_Frequency2("Green/Y Frequency", float) = 10
		_Frequency3("Blue/Z Frequency",float) = 3
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
			uniform float _Speed;
			uniform float _Frequency;
			uniform float _Frequency2;
			uniform float _Frequency3;
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
			};

			float4 vertexAnimWave(float4 pos, float2 uv)
			{
			   pos.y = pos.y + (sin((uv.x - _Time.y * _Speed) * _Frequency)+sin((uv.y - _Time.y * _Speed) * _Frequency2)+sin(_Time.y*_Frequency3)) * _Amplitude;
			   return pos;
			}

			half4 waveColor(float2 uv){
				half4 col;
				col.r = sin((uv.x - _Time.y * _Speed) * _Frequency);
				col.g = sin((uv.y - _Time.y * _Speed) * _Frequency2);
				col.b = sin(_Time.y*_Frequency3);
				col.a = 1;
				return col;
			}


			VertexOutput vert(VertexInput v)
			{
				VertexOutput o;
				v.vertex = vertexAnimWave(v.vertex,v.texcoord.xy);
				float newPosY = (v.vertex.y);
				o.pos = UnityObjectToClipPos(v.vertex + (v.normal * _Height));
				o.texcoord.xy = (v.texcoord.xy);
				return o;
			}

			half4 frag(VertexOutput i): COLOR 
			{
				return waveColor(i.texcoord);
			}

		  
			ENDCG
		}
	}
}
