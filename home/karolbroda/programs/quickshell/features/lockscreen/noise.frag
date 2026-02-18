#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float time;
    vec4 color1;
    vec4 color2;
    vec4 color3;
    vec4 color4;
    float seed;
};

const int bayer8x8[64] = int[64](
    0, 32, 8, 40, 2, 34, 10, 42,
    48, 16, 56, 24, 50, 18, 58, 26,
    12, 44, 4, 36, 14, 46, 6, 38,
    60, 28, 52, 20, 62, 30, 54, 22,
    3, 35, 11, 43, 1, 33, 9, 41,
    51, 19, 59, 27, 49, 17, 57, 25,
    15, 47, 7, 39, 13, 45, 5, 37,
    63, 31, 55, 23, 61, 29, 53, 21
);

float getBayerValue(vec2 uv) {
    int x = int(mod(floor(uv.x), 8.0));
    int y = int(mod(floor(uv.y), 8.0));
    int index = y * 8 + x;
    return float(bayer8x8[index]) / 64.0;
}

void main() {
    float t = 0.3 * time;

    float pxSize = 3.0;

    // pixelize
    vec2 pxSizeUV = gl_FragCoord.xy / pxSize;
    vec2 canvasPixelizedUV = floor(pxSizeUV) * pxSize;

    // warp pattern with irrational-ish frequency ratios
    vec2 shapeUV = canvasPixelizedUV * 0.003;
    shapeUV += seed * 0.1;

    float freqX[5] = float[5](2.13, 1.73, 3.07, 2.51, 1.37);
    float freqY[5] = float[5](1.57, 2.31, 1.19, 2.87, 1.91);

    for (int i = 0; i < 5; i++) {
        float fi = float(i) + 1.0;
        float speed = 0.5 + 0.2 * sin(fi * 1.3);
        shapeUV.x += 0.6 / fi * cos(freqX[i] * shapeUV.y + t * speed);
        shapeUV.y += 0.6 / fi * cos(freqY[i] * shapeUV.x + t * speed * 0.7);
    }

    float shape = 0.15 / max(0.001, abs(sin(t - shapeUV.y - shapeUV.x)));
    shape = smoothstep(0.2, 1.0, shape);

    // center mask: fade pattern out in center so text is readable
    // elliptical distance, wider than tall to match content layout
    vec2 center = qt_TexCoord0 - 0.5;
    center.x *= 0.8;
    center.y *= 1.4;
    float centerDist = length(center);
    // pattern fades in from edge of clear zone
    float centerMask = smoothstep(0.2, 0.55, centerDist);
    shape *= centerMask;

    // second warp layer for color variation
    vec2 shapeUV2 = canvasPixelizedUV * 0.002 + seed * 0.15;
    for (float i = 1.0; i < 4.0; i++) {
        shapeUV2.x += 0.5 / i * cos(i * 1.83 * shapeUV2.y + t * 0.4);
        shapeUV2.y += 0.5 / i * cos(i * 2.17 * shapeUV2.x - t * 0.35);
    }
    float colorBlend = 0.5 + 0.5 * sin(t * 0.2 - shapeUV2.y - shapeUV2.x);

    // dithering
    float dithering = getBayerValue(pxSizeUV);
    dithering -= 0.5;
    float res = step(0.5, shape + dithering);

    // blend foreground between color2 and color3
    vec3 fgColor = mix(color2.rgb, color3.rgb, colorBlend);
    vec3 bgColor = mix(color1.rgb, color4.rgb, 0.05);

    vec3 col = mix(bgColor, fgColor, res);

    // vignette on final output
    vec2 vc = qt_TexCoord0 - 0.5;
    float vignette = 1.0 - dot(vc, vc) * 0.5;
    col *= vignette;

    fragColor = vec4(col, 1.0) * qt_Opacity;
}
