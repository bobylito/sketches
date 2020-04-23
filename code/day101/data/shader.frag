#ifdef GL_ES
precision mediump float;
#endif

#define PROCESSING_COLOR_SHADER

uniform vec2 u_resolution;
uniform float u_frame;
uniform float u_nFrame;

void main() {
    float n2 = mod(u_nFrame + 0.25, 1);
    vec2 c1 = vec2(1 + 0.1 * cos(n2 * 6.28), 1 + 0.5 * sin(n2 * 6.28));
    vec2 c2 = vec2(1 + 0.5 * cos(n2 * 6.28), 1 + 0.1 * sin(n2 * 6.28));
    vec2 c3 = vec2(1 + 0.3 * cos(n2 * 6.28), 1 + 0.3 * sin(n2 * 6.28));

    vec2 st = gl_FragCoord.st / u_resolution;

    float d1 = distance(c1, st) * 2.0;
    float d2 = distance(c2, st) * 2.0;
    float d3 = distance(c3, st) * 2.0;

    float d = (d1 + d2 + d3) / 3.0;

    float shade = sin(u_nFrame * 3.14) * 0.8 + 0.2;
    if(d < 0.5) gl_FragColor = vec4(shade, shade, shade, 1.0);
    else gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
}
