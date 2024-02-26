Shader "Unlit/Line"
{
	Properties
	{
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex("Main Texture", 2D) = "white"{}
		_Start ("Line offset", float) = 0.1
		_Width ("Line width", float) = 0.1
		_Number ("Number of lines", int) = 5
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
			uniform float _Start;
			uniform float _Width;
			uniform int _Number;

			VertexOutput vert(VertexInput v)
			{
				VertexOutput o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
				return o;
			}

			float drawLine(float2 uv, float start, float end)
			{
			   if(uv.x > start && uv.x < end)
			   {
				   return 1;
			   }
			   return 0;
			}

			half4 frag(VertexOutput i): COLOR  
			{
				float4 color = tex2D(_MainTex, i.texcoord) * _Color;
				if(i.texcoord.x%(_Start+_Width)>0.1) color.a = drawLine(i.texcoord, i.texcoord.x%(_Start+_Width), i.texcoord.x%(_Start+_Width)+_Width);
				return color;
			}

		  
			ENDCG
		}
	}
}
