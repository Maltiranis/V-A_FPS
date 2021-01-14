// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/sh_water2ndJet"
{
	Properties
	{
		[HDR]_EmColor("EmColor", Color) = (0,0.5470908,1,0)
		_EmVorSpeed("EmVorSpeed", Float) = 1
		_EmVorScale("EmVorScale", Float) = 3
		_WaveSpeed("WaveSpeed", Float) = 1
		_DeformationScale("DeformationScale", Float) = 1
		_VoroScale("VoroScale", Float) = 1
		_VoroSep("VoroSep", Float) = 1
		_TextureSpeed("TextureSpeed", Float) = 1
		_TextureScale("TextureScale", Float) = 3
		_TexturePower("TexturePower", Float) = 1
		_GlobalColor("GlobalColor", Color) = (0,0.5912301,0.6698113,0)
		_TextureColor("TextureColor", Color) = (0,0.5470908,1,0)
		_Vector5("Vector 5", Vector) = (0,0,0,0)
		_WaterXY("WaterXY", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _VoroScale;
		uniform float _WaveSpeed;
		uniform float _VoroSep;
		uniform float _DeformationScale;
		uniform float _TextureScale;
		uniform float _TextureSpeed;
		uniform float2 _WaterXY;
		uniform float _TexturePower;
		uniform float4 _TextureColor;
		uniform float4 _GlobalColor;
		uniform float _EmVorScale;
		uniform float _EmVorSpeed;
		uniform float2 _Vector5;
		uniform float4 _EmColor;


		float2 voronoihash103( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi103( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash103( n + g );
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
			return F1;
		}


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
			return F1;
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
			return F1;
		}


		float2 voronoihash122( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi122( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash122( n + g );
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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float temp_output_3_0 = ( _Time.y * _WaveSpeed );
			float time103 = (0.0*1.0 + ( temp_output_3_0 + _VoroSep ));
			float2 coords103 = v.texcoord.xy * _VoroScale;
			float2 id103 = 0;
			float2 uv103 = 0;
			float fade103 = 0.5;
			float voroi103 = 0;
			float rest103 = 0;
			for( int it103 = 0; it103 <8; it103++ ){
			voroi103 += fade103 * voronoi103( coords103, time103, id103, uv103, 0 );
			rest103 += fade103;
			coords103 *= 2;
			fade103 *= 0.5;
			}//Voronoi103
			voroi103 /= rest103;
			float time8 = (0.0*1.0 + temp_output_3_0);
			float2 coords8 = v.texcoord.xy * _VoroScale;
			float2 id8 = 0;
			float2 uv8 = 0;
			float fade8 = 0.5;
			float voroi8 = 0;
			float rest8 = 0;
			for( int it8 = 0; it8 <8; it8++ ){
			voroi8 += fade8 * voronoi8( coords8, time8, id8, uv8, 0 );
			rest8 += fade8;
			coords8 *= 2;
			fade8 *= 0.5;
			}//Voronoi8
			voroi8 /= rest8;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 Deformation43 = ( ( ase_vertexNormal * ( voroi103 - voroi8 ) * _DeformationScale ) + ase_vertex3Pos.y );
			v.vertex.xyz += Deformation43;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float time13 = ( _Time.y * _TextureSpeed );
			float4 appendResult37 = (float4(( _Time.y * _WaterXY.x ) , ( _Time.y * _WaterXY.y ) , 0.0 , 0.0));
			float2 temp_cast_1 = ((0.0*1.0 + appendResult37.x)).xx;
			float2 coords13 = temp_cast_1 * _TextureScale;
			float2 id13 = 0;
			float2 uv13 = 0;
			float voroi13 = voronoi13( coords13, time13, id13, uv13, 0 );
			float4 Colors47 = ( ( pow( ( 1.0 - voroi13 ) , _TexturePower ) * _TextureColor ) + _GlobalColor );
			o.Albedo = Colors47.rgb;
			float time122 = ( _Time.y * _EmVorSpeed );
			float2 appendResult115 = (float2(( _Time.y * _Vector5.x ) , ( _Time.y * _Vector5.y )));
			float2 uv_TexCoord143 = i.uv_texcoord + appendResult115;
			float2 coords122 = uv_TexCoord143 * _EmVorScale;
			float2 id122 = 0;
			float2 uv122 = 0;
			float fade122 = 0.5;
			float voroi122 = 0;
			float rest122 = 0;
			for( int it122 = 0; it122 <8; it122++ ){
			voroi122 += fade122 * voronoi122( coords122, time122, id122, uv122, 0 );
			rest122 += fade122;
			coords122 *= 2;
			fade122 *= 0.5;
			}//Voronoi122
			voroi122 /= rest122;
			float temp_output_150_0 = ( 1.0 - voroi122 );
			float4 EmColors130 = ( (0.0 + (voroi122 - 0.0) * (temp_output_150_0 - 0.0) / (temp_output_150_0 - 0.0)) * _EmColor );
			o.Emission = EmColors130.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18400
284;73;1183;655;4091.992;3290.256;1.342885;True;False
Node;AmplifyShaderEditor.CommentaryNode;46;-4396.659,-2358.847;Inherit;False;3539.946;857.0228;Comment;22;47;28;27;29;26;24;25;13;17;16;32;14;18;37;15;21;22;34;40;33;39;98;WaveColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.TimeNode;33;-4245.16,-1943.821;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;39;-4227.473,-1793.778;Inherit;False;Property;_WaterXY;WaterXY;17;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;106;-4404.594,-1219.084;Inherit;False;2166.054;972.2637;Comment;17;1;2;100;3;105;104;4;42;103;8;41;10;102;9;11;12;43;Deformation;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;109;-4072.895,-3432.98;Inherit;False;Property;_Vector5;Vector 5;16;0;Create;True;0;0;False;0;False;0,0;0,-0.02;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TimeNode;110;-4090.582,-3583.023;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;1;-4329.822,-1021.757;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-3956.061,-1957.261;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-3962.143,-1858.38;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-4354.594,-849.3016;Inherit;False;Property;_WaveSpeed;WaveSpeed;3;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;100;-4156.982,-362.8203;Inherit;False;Property;_VoroSep;VoroSep;6;0;Create;True;0;0;False;0;False;1;3.18;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-3529.087,-1829.238;Inherit;False;Property;_TextureSpeed;TextureSpeed;9;0;Create;True;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;37;-3757.923,-2034.782;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TimeNode;14;-3554.804,-1997.155;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;-3807.567,-3497.582;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;108;-4327.194,-3258.922;Inherit;False;3539.946;857.0228;Comment;17;130;128;126;122;120;119;118;117;140;141;143;144;147;149;148;150;152;WaveEm;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-3801.485,-3596.463;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-4066.597,-912.8379;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-3532.113,-1753.599;Inherit;False;Property;_TextureScale;TextureScale;10;0;Create;True;0;0;False;0;False;3;0.0001;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;105;-4046.555,-584.9233;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;32;-3495.75,-2217.926;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-3265.703,-2010.595;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;117;-4208.305,-2715.533;Inherit;False;Property;_EmVorSpeed;EmVorSpeed;1;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;115;-3542.444,-3561.201;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TimeNode;118;-4234.022,-2883.45;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;119;-3944.922,-2896.89;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;120;-4201.331,-2635.894;Inherit;False;Property;_EmVorScale;EmVorScale;2;0;Create;True;0;0;False;0;False;3;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;4;-3888.09,-959.7335;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;104;-3886.429,-651.3015;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;13;-3100.812,-2039.339;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;42;-3884.569,-761.4137;Inherit;False;Property;_VoroScale;VoroScale;5;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;143;-4007.25,-3073.784;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;122;-3748.672,-2927.477;Inherit;True;0;0;1;3;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.OneMinusNode;98;-2727.207,-2037.374;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;103;-3660.813,-655.6506;Inherit;True;0;0;1;0;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;25;-2430.032,-1978.615;Inherit;False;Property;_TexturePower;TexturePower;11;0;Create;True;0;0;False;0;False;1;-2.33;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;8;-3662.474,-964.0826;Inherit;True;0;0;1;0;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.ColorNode;26;-2226.486,-1830.352;Inherit;False;Property;_TextureColor;TextureColor;15;0;Create;True;0;0;False;0;False;0,0.5470908,1,0;0,0.2845906,0.5849056,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;102;-3272.003,-958.3829;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;10;-3631.367,-1169.084;Inherit;True;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;41;-3191.979,-633.2983;Inherit;False;Property;_DeformationScale;DeformationScale;4;0;Create;True;0;0;False;0;False;1;1.44;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;150;-3257.555,-2931.251;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;24;-2252.877,-2047.002;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;126;-2157.021,-2730.427;Inherit;False;Property;_EmColor;EmColor;0;1;[HDR];Create;True;0;0;False;0;False;0,0.5470908,1,0;0,0.2496474,0.7578583,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-3033.181,-1023.822;Inherit;True;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;11;-3173.543,-509.1122;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;152;-3003.525,-3168.834;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-1981.488,-2047.352;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;29;-1951.954,-1769.507;Inherit;False;Property;_GlobalColor;GlobalColor;14;0;Create;True;0;0;False;0;False;0,0.5912301,0.6698113,0;0,0.5911952,0.8867924,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;128;-1912.023,-2947.427;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-2756.668,-855.9055;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-1704.799,-2005.479;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;43;-2462.54,-830.7722;Inherit;False;Deformation;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;-1389.536,-2006.076;Inherit;True;Colors;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;130;-1320.071,-2906.151;Inherit;True;EmColors;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;140;-1561.908,-3122.763;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StepOpNode;144;-3419.998,-2715.217;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.23;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;149;-3296.501,-2408.556;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;147;-3554.383,-2420.695;Inherit;False;Property;_EmVoroStep;EmVoroStep;19;0;Create;True;0;0;False;0;False;0;0.22;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;21;-4337.583,-2308.847;Inherit;False;Property;_RadialShearCenter;RadialShearCenter;7;0;Create;True;0;0;False;0;False;0.5,0.5;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;49;74.09302,-284.3857;Inherit;False;47;Colors;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenColorNode;135;-5564.258,-2936.326;Inherit;False;Global;_GrabScreen0;Grab Screen 0;18;0;Create;True;0;0;False;0;False;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;18;-4015.364,-2246.824;Inherit;True;Radial Shear;-1;;1;c6dc9fc7fa9b08c4d95138f2ae88b526;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;139;-4695.419,-3041.164;Inherit;True;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;1,1,1,1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenDepthNode;136;-5350.648,-3089.648;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;132;-5617.929,-3136.895;Float;False;1;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;134;-5323.355,-2934.158;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;22;-4346.659,-2175.723;Inherit;False;Property;_TextureStrength;TextureStrength;12;0;Create;True;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;113;-4310.972,-3984.853;Inherit;False;Property;_Vector4;Vector 4;8;0;Create;True;0;0;False;0;False;0.5,0.5;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;111;-4320.048,-3851.729;Inherit;False;Property;_Vector3;Vector 3;13;0;Create;True;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StepOpNode;148;-3144.599,-2641.534;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.23;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;141;-2513.018,-2646.208;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;137;-5127.872,-3039.851;Inherit;False;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;84.44186,38.87478;Inherit;False;43;Deformation;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;138;-4895.918,-3039.853;Inherit;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;133;-5546.309,-2738.261;Inherit;True;Property;_Float0;Float 0;18;0;Create;True;0;0;False;0;False;0;11.68;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;131;68.40082,-189.9477;Inherit;False;130;EmColors;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;116;-3988.755,-3922.83;Inherit;True;Radial Shear;-1;;2;c6dc9fc7fa9b08c4d95138f2ae88b526;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;346.4537,-243.6971;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Custom/sh_water2ndJet;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;True;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;34;0;33;2
WireConnection;34;1;39;1
WireConnection;40;0;33;2
WireConnection;40;1;39;2
WireConnection;37;0;34;0
WireConnection;37;1;40;0
WireConnection;112;0;110;2
WireConnection;112;1;109;2
WireConnection;114;0;110;2
WireConnection;114;1;109;1
WireConnection;3;0;1;2
WireConnection;3;1;2;0
WireConnection;105;0;3;0
WireConnection;105;1;100;0
WireConnection;32;2;37;0
WireConnection;16;0;14;2
WireConnection;16;1;15;0
WireConnection;115;0;114;0
WireConnection;115;1;112;0
WireConnection;119;0;118;2
WireConnection;119;1;117;0
WireConnection;4;2;3;0
WireConnection;104;2;105;0
WireConnection;13;0;32;0
WireConnection;13;1;16;0
WireConnection;13;2;17;0
WireConnection;143;1;115;0
WireConnection;122;0;143;0
WireConnection;122;1;119;0
WireConnection;122;2;120;0
WireConnection;98;0;13;0
WireConnection;103;1;104;0
WireConnection;103;2;42;0
WireConnection;8;1;4;0
WireConnection;8;2;42;0
WireConnection;102;0;103;0
WireConnection;102;1;8;0
WireConnection;150;0;122;0
WireConnection;24;0;98;0
WireConnection;24;1;25;0
WireConnection;9;0;10;0
WireConnection;9;1;102;0
WireConnection;9;2;41;0
WireConnection;152;0;122;0
WireConnection;152;2;150;0
WireConnection;152;4;150;0
WireConnection;27;0;24;0
WireConnection;27;1;26;0
WireConnection;128;0;152;0
WireConnection;128;1;126;0
WireConnection;12;0;9;0
WireConnection;12;1;11;2
WireConnection;28;0;27;0
WireConnection;28;1;29;0
WireConnection;43;0;12;0
WireConnection;47;0;28;0
WireConnection;130;0;128;0
WireConnection;144;0;122;0
WireConnection;144;1;147;0
WireConnection;149;0;147;0
WireConnection;18;2;21;0
WireConnection;18;3;22;0
WireConnection;139;0;138;0
WireConnection;134;0;132;0
WireConnection;134;1;133;0
WireConnection;148;0;144;0
WireConnection;148;1;149;0
WireConnection;137;0;136;0
WireConnection;137;1;134;0
WireConnection;138;0;137;0
WireConnection;116;2;113;0
WireConnection;116;3;111;0
WireConnection;0;0;49;0
WireConnection;0;2;131;0
WireConnection;0;11;44;0
ASEEND*/
//CHKSM=E2498629A74290CEC2B10F8597CFCBE992A502CE