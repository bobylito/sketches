#ifdef GL_ES
precision mediump float;
#endif

#define PROCESSING_COLOR_SHADER

#define M_PI 3.1415926535897932384626433832795

uniform vec2 u_resolution;
uniform float u_frame;
uniform float u_nFrame;

void main() {
    vec2 xy = gl_FragCoord.xy / u_resolution;
    vec2 c1 = vec2(0.5, 0.5);
    float d1 = distance(c1, xy);

    float r = smoothstep(0.1 , 0.3, d1);
    float g = smoothstep(0.1, 0.2+ sin(u_nFrame * M_PI) * 0.2, d1);
    float b = smoothstep(0.15, 0.3+ sin(mod(u_nFrame * M_PI + M_PI, M_PI)) * 0.2, d1);

    gl_FragColor = vec4(r, g, b, 1.0);
}
