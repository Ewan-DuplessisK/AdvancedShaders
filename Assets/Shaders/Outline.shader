Shader "Unlit/Outline"
{
	Properties
	{
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex("Main Texture", 2D) = "white"{}
		_Outline("Outline thickness", float) = 0.1
		_OutlineColor("Outline color", Color) = (0,1,0,1)
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

			VertexOutput vert(VertexInput v)
			{
				VertexOutput o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
				return o;
			}

			half4 frag(VertexOutput i): COLOR   //half4 will be treated as a color
			{
				return tex2D(_MainTex, i.texcoord) * _Color;
			}
		  
			ENDCG
		}
		Pass{
			Cull front
			Zwrite off
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			uniform half4 _Color;
			uniform half4 _OutlineColor;
			uniform float _Outline;

			struct VertexInput
			{
				float4 vertex: POSITION;
				float4 texcoord: TEXCOORD0;
				float3 normal : NORMAL;
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
                /*float3 pos = mul(UNITY_MATRIX_M ,v.vertex);
 
                float3x3 view = UNITY_MATRIX_MV ;
 
                // First colunm.
                view._m00 = 1.0f;
                view._m10 = 0.0f;
                view._m20 = 0.0f;
 
                // Second colunm.
                view._m01 = 0.0f;
                view._m11 = 1.0f;
                view._m21 = 0.0f;
 
                // Third colunm.
                view._m02 = 0.0f;
                view._m12 = 0.0f;
                view._m22 = 1.0f;


				o.texcoord.xyz = mul(view, v.vertex.xyz);*/

				float3 outlineOffset = v.normal * _Outline;
    			float3 position = v.vertex + outlineOffset;
				o.pos = UnityObjectToClipPos(position); // faces are not scaled up

                return o;
			}

			half4 frag(VertexOutput i): COLOR   //half4 will be treated as a color
			{
				return _OutlineColor;
			}
		  
			ENDCG
		}
	}
}
