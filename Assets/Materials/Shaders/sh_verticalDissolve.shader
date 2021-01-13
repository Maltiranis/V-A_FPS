// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "sh_verticalDissolve"
{
	Properties
	{
		_noiseScale("noiseScale", Float) = 1
		_voronoiScale("voronoiScale", Float) = 1
		_voronoiAngle("voronoiAngle", Float) = 1
		_border1("border1", Float) = 0.05
		_border2("border2", Float) = 0.1
		_border3("border3", Float) = 0.15
		_remap2("remap2", Range( -1 , 2)) = -0.2708077
		_Color1("Color1", Color) = (0,0,1,0)
		_Color2("Color2", Color) = (1,0,0,0)
		_Color3("Color3", Color) = (1,0.7529412,0,0)
		_EMISSIVEBOOST("EMISSIVEBOOST", Float) = 1
		_UV("UV", Vector) = (1,0,0,0)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha Zero
		
		AlphaToMask On
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
		#endif//ASE Sampling Macros

		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		UNITY_DECLARE_TEX2D_NOSAMPLER(_TextureSample0);
		uniform float4 _TextureSample0_ST;
		SamplerState sampler_TextureSample0;
		uniform float _voronoiScale;
		uniform float _voronoiAngle;
		uniform float2 _UV;
		uniform float _noiseScale;
		uniform float _border3;
		uniform float _remap2;
		uniform float4 _Color3;
		uniform float _border2;
		uniform float4 _Color2;
		uniform float _border1;
		uniform float4 _Color1;
		uniform float _EMISSIVEBOOST;


		float2 voronoihash6( float2 p )
		{
			p = p - 2 * floor( p / 2 );
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi6( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash6( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.707 * pow( ( pow( abs( r.x ), 2 ) + pow( abs( r.y ), 2 ) ), 0.500 );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F1;
		}


		float2 voronoihash189( float2 p )
		{
			p = p - 2 * floor( p / 2 );
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi189( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash189( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.707 * pow( ( pow( abs( r.x ), 2 ) + pow( abs( r.y ), 2 ) ), 0.500 );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F1;
		}


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			o.Albedo = SAMPLE_TEXTURE2D( _TextureSample0, sampler_TextureSample0, uv_TextureSample0 ).rgb;
			float time6 = _voronoiAngle;
			float time189 = ( _voronoiAngle * -1.0 );
			float2 uv_TexCoord113 = i.uv_texcoord + ( _Time.y * _UV );
			float2 coords189 = uv_TexCoord113 * ( _voronoiScale * -1.0 );
			float2 id189 = 0;
			float2 uv189 = 0;
			float fade189 = 0.5;
			float voroi189 = 0;
			float rest189 = 0;
			for( int it189 = 0; it189 <8; it189++ ){
			voroi189 += fade189 * voronoi189( coords189, time189, id189, uv189, 0 );
			rest189 += fade189;
			coords189 *= 2;
			fade189 *= 0.5;
			}//Voronoi189
			voroi189 /= rest189;
			float2 temp_cast_1 = (voroi189).xx;
			float2 coords6 = temp_cast_1 * _voronoiScale;
			float2 id6 = 0;
			float2 uv6 = 0;
			float fade6 = 0.5;
			float voroi6 = 0;
			float rest6 = 0;
			for( int it6 = 0; it6 <8; it6++ ){
			voroi6 += fade6 * voronoi6( coords6, time6, id6, uv6, 0 );
			rest6 += fade6;
			coords6 *= 2;
			fade6 *= 0.5;
			}//Voronoi6
			voroi6 /= rest6;
			float2 temp_cast_2 = (voroi6).xx;
			float simplePerlin2D98 = snoise( temp_cast_2*( _noiseScale + _border3 ) );
			simplePerlin2D98 = simplePerlin2D98*0.5 + 0.5;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float temp_output_150_0 = step( ( simplePerlin2D98 + ase_vertex3Pos.y ) , _remap2 );
			float2 temp_cast_3 = (voroi6).xx;
			float simplePerlin2D78 = snoise( temp_cast_3*( _noiseScale + _border2 ) );
			simplePerlin2D78 = simplePerlin2D78*0.5 + 0.5;
			float temp_output_151_0 = step( ( simplePerlin2D78 + ase_vertex3Pos.y ) , _remap2 );
			float2 temp_cast_4 = (voroi6).xx;
			float simplePerlin2D35 = snoise( temp_cast_4*( _noiseScale + _border1 ) );
			simplePerlin2D35 = simplePerlin2D35*0.5 + 0.5;
			float temp_output_152_0 = step( ( simplePerlin2D35 + ase_vertex3Pos.y ) , _remap2 );
			o.Emission = ( ( ( temp_output_150_0 * _Color3 ) + ( temp_output_151_0 * _Color2 ) + ( temp_output_152_0 * _Color1 ) ) * _EMISSIVEBOOST ).rgb;
			float2 temp_cast_6 = (voroi6).xx;
			float simplePerlin2D5 = snoise( temp_cast_6*_noiseScale );
			simplePerlin2D5 = simplePerlin2D5*0.5 + 0.5;
			float temp_output_158_0 = step( ( simplePerlin2D5 + ase_vertex3Pos.y ) , _remap2 );
			o.Alpha = ( 1.0 - temp_output_158_0 );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			AlphaToMask Off
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
				surfIN.worldPos = worldPos;
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
-1876;120;1730;881;4019.843;623.5741;1.3;True;True
Node;AmplifyShaderEditor.SimpleTimeNode;23;-3944.936,-197.0816;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;119;-3952.38,-100.8779;Inherit;False;Property;_UV;UV;12;0;Create;True;0;0;False;0;False;1,0;0,0.45;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-3682.772,-180.6042;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;170;-3312.945,104.6577;Inherit;False;Property;_voronoiScale;voronoiScale;1;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;171;-3311.007,28.01313;Inherit;False;Property;_voronoiAngle;voronoiAngle;2;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;190;-3078.55,316.0517;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;191;-3074.651,202.9519;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;113;-3401.901,-230.3256;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;77;-2787.205,-782.0266;Inherit;False;Property;_border2;border2;4;0;Create;True;0;0;False;0;False;0.1;0.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-3037.039,-355.7192;Inherit;False;Property;_noiseScale;noiseScale;0;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;99;-2809.543,-1034.567;Inherit;False;Property;_border3;border3;5;0;Create;True;0;0;False;0;False;0.15;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;189;-2942.045,-201.3483;Inherit;True;2;4;2;0;8;True;2;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;2;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;37;-2805.005,-532.0593;Inherit;False;Property;_border1;border1;3;0;Create;True;0;0;False;0;False;0.05;0.21;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-2579.406,-477.6593;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;6;-2669.343,-202.6644;Inherit;True;2;4;2;0;8;True;2;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;2;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleAddOpNode;97;-2585.436,-980.1664;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;76;-2561.605,-727.6266;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;121;-1909.555,102.1745;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;123;-1595.43,104.6443;Inherit;True;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.NoiseGeneratorNode;35;-2347.406,-480.8593;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;2.07,0;False;1;FLOAT;1.55;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;78;-2328.912,-744.1624;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;2.07,0;False;1;FLOAT;1.55;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;98;-2352.742,-996.7023;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;2.07,0;False;1;FLOAT;1.55;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;125;-673.9605,253.3399;Inherit;False;Property;_remap2;remap2;6;0;Create;True;0;0;False;0;False;-0.2708077;0.64;-1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;143;-687.2926,-1092.668;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;142;-679.883,-771.1396;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;141;-671.0468,-465.7682;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;90;446.7599,-960.3416;Inherit;False;Property;_Color2;Color2;9;0;Create;True;0;0;False;0;False;1,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;5;-2350.402,-197.6363;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;2.07,0;False;1;FLOAT;1.55;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;152;7.057896,-387.3315;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;44;509.7708,-322.3249;Inherit;False;Property;_Color1;Color1;8;0;Create;True;0;0;False;0;False;0,0,1,0;1,0.3408259,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;151;-5.599215,-703.5251;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;150;44.07452,-1126.933;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;95;379.1985,-1581.906;Inherit;False;Property;_Color3;Color3;10;0;Create;True;0;0;False;0;False;1,0.7529412,0,0;1,0.792707,0.5896226,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;136;781.586,-1725.084;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;831.3488,-1085.125;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;898.8639,-449.3606;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;140;-694.4258,-119.1989;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;102;1906.689,-720.6352;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;158;1.269965,-56.66486;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;105;2027.21,-185.516;Inherit;False;Property;_EMISSIVEBOOST;EMISSIVEBOOST;11;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;169;2246.938,-103.2554;Inherit;True;Property;_TextureSample0;Texture Sample 0;13;0;Create;True;0;0;False;0;False;-1;80ab37a9e4f49c842903bb43bdd7bcd2;80ab37a9e4f49c842903bb43bdd7bcd2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;172;1105.578,436.7278;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;2309.857,-629.4175;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;162;1118.404,174.9712;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;174;1403.522,505.895;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2775.609,67.10598;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;sh_verticalDissolve;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Opaque;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;1;5;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;7;-1;-1;-1;0;True;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;True;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;21;0;23;0
WireConnection;21;1;119;0
WireConnection;190;0;170;0
WireConnection;191;0;171;0
WireConnection;113;1;21;0
WireConnection;189;0;113;0
WireConnection;189;1;191;0
WireConnection;189;2;190;0
WireConnection;36;0;7;0
WireConnection;36;1;37;0
WireConnection;6;0;189;0
WireConnection;6;1;171;0
WireConnection;6;2;170;0
WireConnection;97;0;7;0
WireConnection;97;1;99;0
WireConnection;76;0;7;0
WireConnection;76;1;77;0
WireConnection;123;0;121;0
WireConnection;35;0;6;0
WireConnection;35;1;36;0
WireConnection;78;0;6;0
WireConnection;78;1;76;0
WireConnection;98;0;6;0
WireConnection;98;1;97;0
WireConnection;143;0;98;0
WireConnection;143;1;123;1
WireConnection;142;0;78;0
WireConnection;142;1;123;1
WireConnection;141;0;35;0
WireConnection;141;1;123;1
WireConnection;5;0;6;0
WireConnection;5;1;7;0
WireConnection;152;0;141;0
WireConnection;152;1;125;0
WireConnection;151;0;142;0
WireConnection;151;1;125;0
WireConnection;150;0;143;0
WireConnection;150;1;125;0
WireConnection;136;0;150;0
WireConnection;136;1;95;0
WireConnection;87;0;151;0
WireConnection;87;1;90;0
WireConnection;45;0;152;0
WireConnection;45;1;44;0
WireConnection;140;0;5;0
WireConnection;140;1;123;1
WireConnection;102;0;136;0
WireConnection;102;1;87;0
WireConnection;102;2;45;0
WireConnection;158;0;140;0
WireConnection;158;1;125;0
WireConnection;172;0;150;0
WireConnection;172;1;151;0
WireConnection;172;2;152;0
WireConnection;172;3;158;0
WireConnection;104;0;102;0
WireConnection;104;1;105;0
WireConnection;162;0;158;0
WireConnection;174;0;172;0
WireConnection;0;0;169;0
WireConnection;0;2;104;0
WireConnection;0;9;162;0
ASEEND*/
//CHKSM=0EF1052E6F8436173490DE8BF529BF222660B0BC