#include "UnityCG.cginc"

float4 Rotate_z(float4 vertex, float degrees) {
    float alpha = degrees * UNITY_PI / 180;
    float sina, cosa;
    sincos(alpha, sina, cosa);
    float4x4 m = float4x4(  cosa, 0, sina, 0,
                            0, 1, 0, 0,
                            -sina, 0, cosa, 0,
                            0,0,0,1);
    return float4(mul(m, vertex.xzyw)).xzyw;
} 

float4 Rotate_x(float4 vertex, float degrees) {
    float alpha = degrees * UNITY_PI / 180;
    float sina, cosa;
    sincos(alpha, sina, cosa);
    float4x4 m = float4x4(1,0,0,0,
                          0, cosa, -sina, 0,
                          0, sina, cosa, 0,
                            0,0,0,0);
    return float4(mul(m, vertex.xzyw)).xzyw;
} 
float4 Rotate_y(float4 vertex, float degrees) {
    float alpha = degrees * UNITY_PI / 180;
    float sina, cosa;
    sincos(alpha, sina, cosa);
    float4x4 m = float4x4(  cosa, -sina, 0.0, 0.0,
                            sina, cosa, 0.0, 0.0,
                            0.0, 0.0, 1.0, 0.0,
                            0.0, 0.0, 0.0, 1.0);
    return float4(mul(m, vertex.xzyw)).xzyw;
}

float4 Shear_x(float4 vertex, float shear) {
    float4x4 m = float4x4(1,0,shear,0,
                          0,1,0,0,
                          0,0,1,0,
                          0,0,0,1);
    return float4(mul(m, vertex.xzyw)).xzyw;
}
