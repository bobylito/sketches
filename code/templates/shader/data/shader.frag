#ifdef GL_ES
precision mediump float;
#endif

#define PROCESSING_COLOR_SHADER

#define M_PI 3.1415926535897932384626433832795

uniform vec2 u_resolution;
uniform float u_nFrame;

void main() {
  vec2 xy = gl_FragCoord.xy / u_resolution;
  gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
}
