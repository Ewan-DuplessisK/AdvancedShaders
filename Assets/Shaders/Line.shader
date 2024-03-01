Shader "Unlit/Line"
{
	Properties
	{
		_Color ("Main Color", Color) = (1,0,0,1)
		_SecColor("Secondary Color", Color) = (0,1,0,1)
		_MainTex("Main Texture", 2D) = "white"{}
		_Start ("Line offset", float) = 0.1
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
			uniform half4 _SecColor;

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
			uniform int _Number;

			VertexOutput vert(VertexInput v)
			{
				VertexOutput o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
				return o;
			}

			half4 drawLine(float2 uv, float lineWidth)
			{
				if(uv.x%(2*lineWidth)<lineWidth || uv.y%(2*lineWidth)<lineWidth){
					return _Color;
				}else{
					return _SecColor;
				}
			}

			half4 frag(VertexOutput i): COLOR  
			{
				float width = (1.0/_Number);
				float4 color = tex2D(_MainTex, i.texcoord) * drawLine(i.texcoord,width);
				
				return color;
			}

		  
			ENDCG
		}
	}
}
