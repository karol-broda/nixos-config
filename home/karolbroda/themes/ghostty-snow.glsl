float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float snowChar(vec2 p, int charType) {
    if (p.x < 0.0 || p.x >= 5.0 || p.y < 0.0 || p.y >= 5.0) {
        return 0.0;
    }
    
    int px = int(p.x);
    int py = int(p.y);
    
    if (charType == 0) {
        return (px == 2 && py == 2) ? 1.0 : 0.0;
    }
    if (charType == 1) {
        return (px == 2 || py == 2) ? 1.0 : 0.0;
    }
    if (charType == 2) {
        if (px == 2 && py >= 1 && py <= 3) return 1.0;
        if (py == 2 && px >= 1 && px <= 3) return 1.0;
        return 0.0;
    }
    if (charType == 3) {
        return (px >= 1 && px <= 3 && py >= 1 && py <= 3) ? 1.0 : 0.0;
    }
    return (px >= 2 && px <= 3 && py >= 2 && py <= 3) ? 1.0 : 0.0;
}

float snowLayer(vec2 pixel, float colWidth, float numRows, float baseSpeed, float time, float layerSeed) {
    // which column is this pixel in
    float col = floor(pixel.x / colWidth);
    float inColX = mod(pixel.x, colWidth);
    
    float result = 0.0;
    
    // check each snowflake "slot" in this column
    for (float row = 0.0; row < numRows; row += 1.0) {
        // unique id for this snowflake
        vec2 flakeId = vec2(col, row + layerSeed);
        
        // this flake's properties (fixed for its lifetime)
        float flakeHash = hash(flakeId);
        float flakeHash2 = hash(flakeId * 1.7);
        float flakeHash3 = hash(flakeId * 2.3);
        float flakeHash4 = hash(flakeId * 3.1);
        
        // skip some slots for sparsity
        if (flakeHash > 0.4) continue;
        
        // this flake's speed (varies per flake)
        float speed = baseSpeed * (0.7 + flakeHash2 * 0.6);
        
        // horizontal position within column (fixed)
        float flakeX = flakeHash3 * (colWidth - 6.0);
        
        // vertical position (falls down over time, wraps around)
        float screenHeight = 1000.0; // virtual height for wrapping
        float startY = flakeHash4 * screenHeight;
        float flakeY = mod(startY - time * speed + screenHeight * 10.0, screenHeight);
        
        // slight horizontal sway based on this flake's seed
        float sway = sin(time * 0.5 + flakeHash * 6.28) * 3.0;
        flakeX += sway;
        
        // check if this pixel is within this flake's 5x5 character
        vec2 charPx = vec2(inColX - flakeX, pixel.y - flakeY);
        
        // character type for this flake
        int charType = int(flakeHash2 * 5.0);
        
        result += snowChar(charPx, charType);
    }
    
    return min(result, 1.0);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec4 terminal = texture(iChannel0, uv);
    
    // work in screen pixels, snapped to 2x2 blocks
    vec2 pixel = floor(fragCoord / 2.0);
    
    float snow = 0.0;
    
    // back layer - smaller, slower
    snow += snowLayer(pixel, 50.0, 8.0, 15.0, iTime, 0.0) * 0.4;
    
    // middle layer
    snow += snowLayer(pixel, 45.0, 8.0, 22.0, iTime, 100.0) * 0.6;
    
    // front layer - larger, faster
    snow += snowLayer(pixel, 40.0, 8.0, 30.0, iTime, 200.0) * 0.9;
    
    snow = min(snow, 1.0);
    
    vec3 snowColor = vec3(0.9, 0.95, 1.0);
    vec3 finalColor = mix(terminal.rgb, snowColor, snow);
    
    fragColor = vec4(finalColor, terminal.a);
}
