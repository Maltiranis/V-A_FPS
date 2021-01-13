// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "sh_izukuPower"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 15
		_Color0("Color 0", Color) = (0,0,0,0)
		_Color1("Color1", Color) = (0,0,0,0)
		_Color2("Color2", Color) = (0,0,0,0)
		_voronoi("voronoi", Float) = 0.2
		_step("step", Float) = 0.17
		_emissivePower("emissivePower", Float) = 0
		_scale("scale", Float) = 0.17
		_bsp("bsp", Vector) = (0,0,0,0)
		_angle("angle", Float) = 2.33
		_tiling("tiling", Vector) = (0,0,0,0)
		_offset("offset", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			float2 uv_texcoord;
		};

		uniform float3 _bsp;
		uniform float _scale;
		uniform float _angle;
		uniform float2 _tiling;
		uniform float2 _offset;
		uniform float _voronoi;
		uniform float _step;
		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform float4 _Color2;
		uniform float _emissivePower;
		uniform float _EdgeLength;


		float2 voronoihash2( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi2( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -3; j <= 3; j++ )
			{
				for ( int i = -3; i <= 3; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash2( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return (F2 + F1) * 0.5;
		}


		struct Gradient
		{
			int type;
			int colorsLength;
			int alphasLength;
			float4 colors[8];
			float2 alphas[8];
		};


		Gradient NewGradient(int type, int colorsLength, int alphasLength, 
		float4 colors0, float4 colors1, float4 colors2, float4 colors3, float4 colors4, float4 colors5, float4 colors6, float4 colors7,
		float2 alphas0, float2 alphas1, float2 alphas2, float2 alphas3, float2 alphas4, float2 alphas5, float2 alphas6, float2 alphas7)
		{
			Gradient g;
			g.type = type;
			g.colorsLength = colorsLength;
			g.alphasLength = alphasLength;
			g.colors[ 0 ] = colors0;
			g.colors[ 1 ] = colors1;
			g.colors[ 2 ] = colors2;
			g.colors[ 3 ] = colors3;
			g.colors[ 4 ] = colors4;
			g.colors[ 5 ] = colors5;
			g.colors[ 6 ] = colors6;
			g.colors[ 7 ] = colors7;
			g.alphas[ 0 ] = alphas0;
			g.alphas[ 1 ] = alphas1;
			g.alphas[ 2 ] = alphas2;
			g.alphas[ 3 ] = alphas3;
			g.alphas[ 4 ] = alphas4;
			g.alphas[ 5 ] = alphas5;
			g.alphas[ 6 ] = alphas6;
			g.alphas[ 7 ] = alphas7;
			return g;
		}


		float4 SampleGradient( Gradient gradient, float time )
		{
			float3 color = gradient.colors[0].rgb;
			UNITY_UNROLL
			for (int c = 1; c < 8; c++)
			{
			float colorPos = saturate((time - gradient.colors[c-1].w) / (gradient.colors[c].w - gradient.colors[c-1].w)) * step(c, (float)gradient.colorsLength-1);
			color = lerp(color, gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), gradient.type));
			}
			#ifndef UNITY_COLORSPACE_GAMMA
			color = half3(GammaToLinearSpaceExact(color.r), GammaToLinearSpaceExact(color.g), GammaToLinearSpaceExact(color.b));
			#endif
			float alpha = gradient.alphas[0].x;
			UNITY_UNROLL
			for (int a = 1; a < 8; a++)
			{
			float alphaPos = saturate((time - gradient.alphas[a-1].y) / (gradient.alphas[a].y - gradient.alphas[a-1].y)) * step(a, (float)gradient.alphasLength-1);
			alpha = lerp(alpha, gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), gradient.type));
			}
			return float4(color, alpha);
		}


		float2 voronoihash18( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi18( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -3; j <= 3; j++ )
			{
				for ( int i = -3; i <= 3; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash18( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return (F2 + F1) * 0.5;
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV149 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode149 = ( _bsp.x + _bsp.y * pow( 1.0 - fresnelNdotV149, _bsp.z ) );
			float temp_output_154_0 = ( fresnelNode149 * 1.1 );
			float temp_output_55_0 = ( _angle * _Time.y );
			float time2 = temp_output_55_0;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float2 uv_TexCoord39 = i.uv_texcoord * _tiling + _offset;
			float3 temp_output_41_0 = ( ( ase_vertex3Pos + float3( i.uv_texcoord ,  0.0 ) ) * float3( uv_TexCoord39 ,  0.0 ) );
			float2 coords2 = temp_output_41_0.xy * _scale;
			float2 id2 = 0;
			float2 uv2 = 0;
			float fade2 = 0.5;
			float voroi2 = 0;
			float rest2 = 0;
			for( int it2 = 0; it2 <8; it2++ ){
			voroi2 += fade2 * voronoi2( coords2, time2, id2, uv2, 0 );
			rest2 += fade2;
			coords2 *= 2;
			fade2 *= 0.5;
			}//Voronoi2
			voroi2 /= rest2;
			Gradient gradient11 = NewGradient( 0, 2, 2, float4( 1, 1, 1, 0 ), float4( 0, 0, 0, 1 ), 0, 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
			float4 temp_cast_3 = (_step).xxxx;
			float4 temp_cast_4 = (step( voroi2 , _step )).xxxx;
			float4 temp_output_17_0 = ( step( ( voroi2 * SampleGradient( gradient11, _voronoi ) ) , temp_cast_3 ) - temp_cast_4 );
			float time18 = temp_output_55_0;
			float2 coords18 = temp_output_41_0.xy * _scale;
			float2 id18 = 0;
			float2 uv18 = 0;
			float fade18 = 0.5;
			float voroi18 = 0;
			float rest18 = 0;
			for( int it18 = 0; it18 <8; it18++ ){
			voroi18 += fade18 * voronoi18( coords18, time18, id18, uv18, 0 );
			rest18 += fade18;
			coords18 *= 2;
			fade18 *= 0.5;
			}//Voronoi18
			voroi18 /= rest18;
			float4 temp_cast_8 = (_step).xxxx;
			float4 temp_cast_9 = (step( voroi18 , _step )).xxxx;
			float4 temp_output_22_0 = ( step( ( voroi18 * SampleGradient( gradient11, _voronoi ) ) , temp_cast_8 ) - temp_cast_9 );
			float4 temp_cast_10 = (_step).xxxx;
			float4 temp_cast_11 = (step( voroi2 , _step )).xxxx;
			float4 temp_cast_12 = (_step).xxxx;
			float4 temp_cast_13 = (step( voroi18 , _step )).xxxx;
			o.Emission = ( ( ( temp_output_154_0 - step( fresnelNode149 , temp_output_154_0 ) ) * ( ( 1.0 - ( temp_output_17_0 + temp_output_22_0 ) ) * _Color0 ) ) + ( ( ( _Color1 * temp_output_17_0 ) + ( _Color2 * temp_output_22_0 ) ) * _emissivePower ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18400
312;73;1176;650;-833.7629;562.1138;1.588221;True;True
Node;AmplifyShaderEditor.Vector2Node;40;-2592.5,-124.0806;Inherit;False;Property;_tiling;tiling;15;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;52;-2559.85,91.95468;Inherit;False;Property;_offset;offset;16;0;Create;True;0;0;False;0;False;0,0;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PosVertexDataNode;33;-2431.296,-683.8377;Inherit;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;3;-2448.105,-461.2742;Inherit;True;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-2152.857,-127.0806;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;42;-1558.252,610.6316;Inherit;False;Property;_angle;angle;14;0;Create;True;0;0;False;0;False;2.33;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;56;-1536.165,980.6018;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;53;-2118.262,-519.1347;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-1550.048,508.5876;Inherit;False;Property;_scale;scale;11;0;Create;True;0;0;False;0;False;0.17;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-1811.979,-534.2272;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1788.671,338.118;Inherit;False;Property;_voronoi;voronoi;8;0;Create;True;0;0;False;0;False;0.2;0.14;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GradientNode;11;-1826.329,243.0094;Inherit;False;0;2;2;1,1,1,0;0,0,0,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-1250.165,732.6017;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;2;-961.0046,67.99995;Inherit;True;2;0;5;3;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;-0.34;False;2;FLOAT;3;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.VoronoiNode;18;-945.4995,371.9335;Inherit;True;2;0;5;3;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;-0.34;False;2;FLOAT;2.99;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.GradientSampleNode;12;-1619.369,243.4093;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-488.879,590.5585;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;6.05,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-792.7996,-153.2649;Inherit;False;Property;_step;step;9;0;Create;True;0;0;False;0;False;0.17;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-539.8289,50.37799;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;6.05,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;8;-290.3918,39.71521;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;151;1174.647,1.672705;Inherit;False;Property;_bsp;bsp;13;0;Create;True;0;0;False;0;False;0,0,0;0.68,0.35,0.97;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StepOpNode;21;-247.154,331.7034;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;20;-239.4419,579.8957;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;4;-298.1039,-208.4771;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;149;1400.655,-18.27733;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;-0.09;False;2;FLOAT;0.18;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;17;14.23785,2.295144;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;22;65.18777,542.4756;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;465.9231,-454.9447;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;154;1462.778,224.9879;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;23;20.83343,-186.8453;Inherit;False;Property;_Color1;Color1;6;0;Create;True;0;0;False;0;False;0,0,0,0;1,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;24;67.2337,361.9545;Inherit;False;Property;_Color2;Color2;7;0;Create;True;0;0;False;0;False;0,0,0,0;1,0.4103774,0.4103774,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;30;649.1797,-673.5209;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;308.6595,-65.23569;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;350.2596,459.9637;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;155;1710.037,29.27826;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;668.6547,-254.1113;Inherit;False;Property;_Color0;Color 0;5;0;Create;True;0;0;False;0;False;0,0,0,0;0,1,0.517647,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;29;815.9698,653.8815;Inherit;False;Property;_emissivePower;emissivePower;10;0;Create;True;0;0;False;0;False;0;1.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;153;1920.334,39.91879;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;27;625.8592,201.2642;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;914.6796,-485.4208;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;1037.477,427.518;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;150;2152.773,-23.48077;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;147;1276.933,-254.3225;Inherit;False;Property;_vertexPos;vertexPos;12;0;Create;True;0;0;False;0;False;1;0.8;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;148;1326.758,-481.0214;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;1960.239,-335.2157;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;59;2005.777,325.6574;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;1612,-331.5495;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2607.514,258.9675;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;sh_izukuPower;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;True;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;39;0;40;0
WireConnection;39;1;52;0
WireConnection;53;0;33;0
WireConnection;53;1;3;0
WireConnection;41;0;53;0
WireConnection;41;1;39;0
WireConnection;55;0;42;0
WireConnection;55;1;56;2
WireConnection;2;0;41;0
WireConnection;2;1;55;0
WireConnection;2;2;34;0
WireConnection;18;0;41;0
WireConnection;18;1;55;0
WireConnection;18;2;34;0
WireConnection;12;0;11;0
WireConnection;12;1;5;0
WireConnection;19;0;18;0
WireConnection;19;1;12;0
WireConnection;9;0;2;0
WireConnection;9;1;12;0
WireConnection;8;0;9;0
WireConnection;8;1;15;0
WireConnection;21;0;18;0
WireConnection;21;1;15;0
WireConnection;20;0;19;0
WireConnection;20;1;15;0
WireConnection;4;0;2;0
WireConnection;4;1;15;0
WireConnection;149;1;151;1
WireConnection;149;2;151;2
WireConnection;149;3;151;3
WireConnection;17;0;8;0
WireConnection;17;1;4;0
WireConnection;22;0;20;0
WireConnection;22;1;21;0
WireConnection;32;0;17;0
WireConnection;32;1;22;0
WireConnection;154;0;149;0
WireConnection;30;0;32;0
WireConnection;25;0;23;0
WireConnection;25;1;17;0
WireConnection;26;0;24;0
WireConnection;26;1;22;0
WireConnection;155;0;149;0
WireConnection;155;1;154;0
WireConnection;153;0;154;0
WireConnection;153;1;155;0
WireConnection;27;0;25;0
WireConnection;27;1;26;0
WireConnection;31;0;30;0
WireConnection;31;1;1;0
WireConnection;28;0;27;0
WireConnection;28;1;29;0
WireConnection;150;0;153;0
WireConnection;150;1;31;0
WireConnection;92;0;146;0
WireConnection;59;0;150;0
WireConnection;59;1;28;0
WireConnection;146;0;148;0
WireConnection;146;1;147;0
WireConnection;0;2;59;0
ASEEND*/
//CHKSM=E79391B390021BF9ED4313E75F78A386F907AC2E