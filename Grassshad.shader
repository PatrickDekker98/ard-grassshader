// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Grassshad"{
    Properties {
        _Thickness ("Thickness", Float) = 0.1
        _Color("Color", Color) = (1,1,1,1)
        _Shear("Shear", Float) = 0.0
        _BaseDiff("BaseDiff", Float) = 0.3
    }
    SubShader { // Unity chooses the subshader that fits the GPU best
      Pass { // some shaders require multiple passes
        Stencil {
                Ref 1
                Comp Always
                Pass Replace
            }

         CGPROGRAM // here begins the part in Unity's Cg
         
         #pragma vertex vert 
         #pragma fragment frag

         #include "UnityCG.cginc"
         #include "shaderTransform.cginc"
         struct vertexInput {
            float4 vertex: POSITION;
            float3 normal: NORMAL;
         };

         struct vertexOutput {
            float4 pos : SV_POSITION;
            float4 col : TEXCOORD0;
         };

        uniform float4 _LightColor0;

        uniform float4 _Color;
        uniform float _Shear;
        uniform float _BaseDiff;

         vertexOutput vert(vertexInput input) {
            vertexOutput output;
            output.pos = UnityObjectToClipPos(Shear_x(input.vertex, _Shear));
            
            float4x4 modelMatrix = unity_ObjectToWorld;
            float4x4 modelMatrixInverse = unity_WorldToObject;

            float3 normalDirection = normalize(
               mul(float4(input.normal, 0.0), modelMatrixInverse).xyz);

            float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);

            float diffuse = dot(normalDirection, lightDirection);
            
            if (diffuse > 0.6) {
                diffuse = _BaseDiff + 0.7;
            } else if (diffuse > -0.2) {
                diffuse = _BaseDiff + 0.35;
            } else {
                diffuse = _BaseDiff;
            }

            float3 diffuseReflection = _LightColor0.rgb * _Color.rgb * max(0.0, diffuse);

            output.col = float4(diffuseReflection, 1.0);
            return output;
         }

         float4 frag(vertexOutput input) : COLOR  {
            return input.col;
        }

         ENDCG // here ends the part in Cg 
      }

        Pass {
            Cull Off
            Stencil {
                Ref 1
                Comp NotEqual
                Pass Keep
            }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "shaderTransform.cginc"
    
            uniform float _Thickness;
            float _Shear;

            float4 vert(float4 vertex : POSITION, float3 normal : NORMAL) : SV_POSITION {
                // maa
                return UnityObjectToClipPos(Shear_x(vertex, _Shear) + normal * _Thickness);
            }

            float4 frag(void) : COLOR {
                return float4(0.0, 0.0, 0.0, 0.0);
            }
            ENDCG
       }
   }
}
