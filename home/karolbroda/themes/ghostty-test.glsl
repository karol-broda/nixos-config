void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec4 terminal = texture(iChannel0, uv);
    fragColor = vec4(terminal.r + 0.2, terminal.g, terminal.b, terminal.a);
}

