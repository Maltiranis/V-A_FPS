// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/sh_water"
{
	Properties
	{
		_WaveSpeed("WaveSpeed", Float) = 1
		_DeformationScale("DeformationScale", Float) = 1
		_VoroScale("VoroScale", Float) = 1
		_VoroScale2("VoroScale2", Float) = 5
		_TextureSpeed("TextureSpeed", Float) = 1
		_VoroSpeed2("VoroSpeed2", Float) = 1
		_TextureScale("TextureScale", Float) = 3
		_TexturePower("TexturePower", Float) = 1
		_TextureStrength("TextureStrength", Vector) = (1,1,0,0)
		_GlobalColor("GlobalColor", Color) = (0,0.5912301,0.6698113,0)
		_TextureColor("TextureColor", Color) = (0,0.5470908,1,0)
		_EmColor1("EmColor1", Color) = (0,0.5470908,1,0)
		_EmColor2("EmColor2", Color) = (0,0.5470908,1,0)
		_EmColor3("EmColor3", Color) = (0,0.5470908,1,0)
		_EmPower("EmPower", Vector) = (1,1,1,0)
		_WaterXY("WaterXY", Vector) = (0,0,0,0)
		_StepEm("StepEm", Vector) = (0,0,0,0)
		_ScaleXY("ScaleXY", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _VoroScale;
		uniform float _WaveSpeed;
		uniform float _DeformationScale;
		uniform float _TextureScale;
		uniform float _TextureSpeed;
		uniform float2 _TextureStrength;
		uniform float2 _WaterXY;
		uniform float _TexturePower;
		uniform float4 _TextureColor;
		uniform float4 _GlobalColor;
		uniform float _VoroScale2;
		uniform float _VoroSpeed2;
		uniform float2 _ScaleXY;
		uniform float3 _StepEm;
		uniform float4 _EmColor1;
		uniform float3 _EmPower;
		uniform float4 _EmColor2;
		uniform float4 _EmColor3;


		float2 voronoihash8( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi8( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash8( n + g );
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


		float2 voronoihash13( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi13( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash13( n + g );
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


		float2 voronoihash62( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi62( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash62( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.707 * sqrt(dot( r, r ));
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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float time8 = (0.0*1.0 + ( _Time.y * _WaveSpeed ));
			float2 coords8 = v.texcoord.xy * _VoroScale;
			float2 id8 = 0;
			float2 uv8 = 0;
			float voroi8 = voronoi8( coords8, time8, id8, uv8, 0 );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 Deformation43 = ( ( ase_vertexNormal * voroi8 * _DeformationScale ) + ase_vertex3Pos.y );
			v.vertex.xyz += Deformation43;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float time13 = ( _Time.y * _TextureSpeed );
			float2 temp_output_1_0_g1 = i.uv_texcoord;
			float2 temp_output_11_0_g1 = ( temp_output_1_0_g1 - float2( 0.5,0.5 ) );
			float2 break18_g1 = temp_output_11_0_g1;
			float2 appendResult19_g1 = (float2(break18_g1.y , -break18_g1.x));
			float dotResult12_g1 = dot( temp_output_11_0_g1 , temp_output_11_0_g1 );
			float4 appendResult37 = (float4(( _Time.y * _WaterXY.x ) , ( _Time.y * _WaterXY.y ) , 0.0 , 0.0));
			float2 temp_output_32_0 = (( temp_output_1_0_g1 + ( appendResult19_g1 * ( dotResult12_g1 * _TextureStrength ) ) + float2( 0,0 ) )*1.0 + appendResult37.xy);
			float2 coords13 = temp_output_32_0 * _TextureScale;
			float2 id13 = 0;
			float2 uv13 = 0;
			float fade13 = 0.5;
			float voroi13 = 0;
			float rest13 = 0;
			for( int it13 = 0; it13 <8; it13++ ){
			voroi13 += fade13 * voronoi13( coords13, time13, id13, uv13, 0 );
			rest13 += fade13;
			coords13 *= 2;
			fade13 *= 0.5;
			}//Voronoi13
			voroi13 /= rest13;
			float4 Colors47 = ( ( pow( voroi13 , _TexturePower ) * _TextureColor ) + _GlobalColor );
			o.Albedo = Colors47.rgb;
			float time62 = ( _Time.y * _VoroSpeed2 );
			float4 appendResult76 = (float4(_ScaleXY.x , _ScaleXY.y , 0.0 , 0.0));
			float2 coords62 = (temp_output_32_0*appendResult76.xy + float2( 0,0 )) * _VoroScale2;
			float2 id62 = 0;
			float2 uv62 = 0;
			float voroi62 = voronoi62( coords62, time62, id62, uv62, 0 );
			float temp_output_77_0 = ( voroi13 + voroi62 );
			float4 Emissive54 = ( ( step( temp_output_77_0 , _StepEm.x ) * _EmColor1 * _EmPower.x ) + ( step( temp_output_77_0 , _StepEm.y ) * _EmColor2 * _EmPower.y ) + ( step( temp_output_77_0 , _StepEm.z ) * _EmColor3 * _EmPower.z ) );
			o.Emission = Emissive54.rgb;
			float Opacity59 = temp_output_77_0;
			o.Alpha = Opacity59;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
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
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
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
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
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
239;73;1286;627;3602.972;1945.918;1.561617;True;True
Node;AmplifyShaderEditor.CommentaryNode;46;-4396.659,-2358.847;Inherit;False;4404.815;1909.728;Comment;46;50;54;59;47;51;28;27;29;82;26;24;84;69;77;25;85;13;83;62;66;17;16;63;71;32;64;65;76;15;14;18;73;37;40;34;21;22;33;39;87;89;90;92;93;95;97;WaveColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;39;-4227.473,-1793.778;Inherit;False;Property;_WaterXY;WaterXY;15;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TimeNode;33;-4245.16,-1943.821;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;22;-4346.659,-2175.723;Inherit;False;Property;_TextureStrength;TextureStrength;8;0;Create;True;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;21;-4337.583,-2308.847;Inherit;False;Constant;_Vector3;Vector 3;3;0;Create;True;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-3956.061,-1957.261;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-3962.143,-1858.38;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;18;-4015.364,-2246.824;Inherit;True;Radial Shear;-1;;1;c6dc9fc7fa9b08c4d95138f2ae88b526;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;37;-3757.923,-2034.782;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;73;-3673.156,-1211.508;Inherit;False;Property;_ScaleXY;ScaleXY;17;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;64;-3567.331,-1449.087;Inherit;False;Property;_VoroSpeed2;VoroSpeed2;5;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;76;-3472.919,-1174.828;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TimeNode;65;-3593.047,-1617.005;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;45;-3894.596,339.6329;Inherit;False;1986.052;863.3153;Comment;14;1;2;3;4;42;8;10;41;11;9;12;6;30;43;Deformation;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;32;-3495.75,-2217.926;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-3529.087,-1829.238;Inherit;False;Property;_TextureSpeed;TextureSpeed;4;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;14;-3554.804,-1997.155;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-3532.113,-1753.599;Inherit;False;Property;_TextureScale;TextureScale;6;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-3265.703,-2010.595;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;1;-3819.825,536.9608;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2;-3844.596,709.4166;Inherit;False;Property;_WaveSpeed;WaveSpeed;0;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-3570.356,-1373.449;Inherit;False;Property;_VoroScale2;VoroScale2;3;0;Create;True;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;71;-3241.562,-1218.672;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-3303.947,-1630.444;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-3556.602,645.8802;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;62;-3055.834,-1596.108;Inherit;True;0;1;1;3;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;5.19;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.VoronoiNode;13;-3100.812,-2039.339;Inherit;True;0;0;1;3;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;42;-3374.574,797.3044;Inherit;False;Property;_VoroScale;VoroScale;2;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-2903.473,-1952.202;Inherit;False;Property;_TexturePower;TexturePower;7;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;97;-2465.146,-1315.992;Inherit;False;Property;_StepEm;StepEm;16;0;Create;True;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScaleAndOffsetNode;4;-3378.095,598.9843;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;77;-2758.649,-1573.274;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;24;-2711.318,-2035.589;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;95;-1372.291,-1270.828;Inherit;False;Property;_EmPower;EmPower;14;0;Create;True;0;0;False;0;False;1,1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;41;-2936.954,670.685;Inherit;False;Property;_DeformationScale;DeformationScale;1;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;50;-1368.843,-1013.224;Inherit;False;Property;_EmColor1;EmColor1;11;0;Create;True;0;0;False;0;False;0,0.5470908,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;26;-2684.927,-1818.939;Inherit;False;Property;_TextureColor;TextureColor;10;0;Create;True;0;0;False;0;False;0,0.5470908,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;69;-1850.195,-1632.19;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.84;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;82;-1857.808,-1404.214;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.02;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;8;-3152.479,594.6352;Inherit;True;0;0;1;3;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.StepOpNode;84;-1865.057,-1165.731;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.02;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;93;-1343.311,-649.7648;Inherit;False;Property;_EmColor3;EmColor3;13;0;Create;True;0;0;False;0;False;0,0.5470908,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;90;-1354.733,-835.9583;Inherit;False;Property;_EmColor2;EmColor2;12;0;Create;True;0;0;False;0;False;0,0.5470908,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;10;-3121.372,389.6329;Inherit;True;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-1053.809,-1316.334;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosVertexDataNode;11;-2918.519,794.8712;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-1047.611,-1554.068;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-2439.927,-2035.939;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-1064.301,-1078.977;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;29;-2410.394,-1758.094;Inherit;False;Property;_GlobalColor;GlobalColor;9;0;Create;True;0;0;False;0;False;0,0.5912301,0.6698113,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-2703.186,506.8952;Inherit;True;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-2163.238,-1994.066;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-2426.673,674.8126;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;87;-738.2047,-1296.159;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;-431.3282,-1261.925;Inherit;True;Emissive;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;-1847.976,-1994.663;Inherit;True;Colors;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;-2452.781,-795.8199;Inherit;True;Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;43;-2132.545,699.946;Inherit;False;Deformation;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;83;-2381.589,-1110.933;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;85;-2266.485,-990.2544;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;84.44186,38.87478;Inherit;False;43;Deformation;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;30;-2667.609,845.9464;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;60;82.40857,-43.65128;Inherit;False;59;Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;74.09302,-284.3857;Inherit;False;47;Colors;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;74.88,-209.5782;Inherit;False;54;Emissive;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;6;-2984.903,943.9483;Inherit;True;Gradient;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;346.4537,-243.6971;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Custom/sh_water;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;True;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;34;0;33;2
WireConnection;34;1;39;1
WireConnection;40;0;33;2
WireConnection;40;1;39;2
WireConnection;18;2;21;0
WireConnection;18;3;22;0
WireConnection;37;0;34;0
WireConnection;37;1;40;0
WireConnection;76;0;73;1
WireConnection;76;1;73;2
WireConnection;32;0;18;0
WireConnection;32;2;37;0
WireConnection;16;0;14;2
WireConnection;16;1;15;0
WireConnection;71;0;32;0
WireConnection;71;1;76;0
WireConnection;63;0;65;2
WireConnection;63;1;64;0
WireConnection;3;0;1;2
WireConnection;3;1;2;0
WireConnection;62;0;71;0
WireConnection;62;1;63;0
WireConnection;62;2;66;0
WireConnection;13;0;32;0
WireConnection;13;1;16;0
WireConnection;13;2;17;0
WireConnection;4;2;3;0
WireConnection;77;0;13;0
WireConnection;77;1;62;0
WireConnection;24;0;13;0
WireConnection;24;1;25;0
WireConnection;69;0;77;0
WireConnection;69;1;97;1
WireConnection;82;0;77;0
WireConnection;82;1;97;2
WireConnection;8;1;4;0
WireConnection;8;2;42;0
WireConnection;84;0;77;0
WireConnection;84;1;97;3
WireConnection;89;0;82;0
WireConnection;89;1;90;0
WireConnection;89;2;95;2
WireConnection;51;0;69;0
WireConnection;51;1;50;0
WireConnection;51;2;95;1
WireConnection;27;0;24;0
WireConnection;27;1;26;0
WireConnection;92;0;84;0
WireConnection;92;1;93;0
WireConnection;92;2;95;3
WireConnection;9;0;10;0
WireConnection;9;1;8;0
WireConnection;9;2;41;0
WireConnection;28;0;27;0
WireConnection;28;1;29;0
WireConnection;12;0;9;0
WireConnection;12;1;11;2
WireConnection;87;0;51;0
WireConnection;87;1;89;0
WireConnection;87;2;92;0
WireConnection;54;0;87;0
WireConnection;47;0;28;0
WireConnection;59;0;77;0
WireConnection;43;0;12;0
WireConnection;85;0;83;0
WireConnection;0;0;49;0
WireConnection;0;2;55;0
WireConnection;0;9;60;0
WireConnection;0;11;44;0
ASEEND*/
//CHKSM=4BC776AB44EE8A791A4EC6C9815C66AADB8FB9CB