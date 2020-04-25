#ifdef GL_ES
precision mediump float;
#endif

#define PROCESSING_COLOR_SHADER

#define M_PI 3.1415926535897932384626433832795

uniform vec2 u_resolution;
uniform float u_frame;
uniform float u_nFrame;

vec3 green =vec3(0.494, 0.741, 0.705);
vec3 yellow = vec3(0.964, 0.819, 0.596);
vec3 orange = vec3(0.956, 0.647, 0.282);
vec3 red = vec3(0.525, 0.164, 0.360);

float ball(float d1, float d2, float d3, float d4, float r1) {
  return step(0.13, 
      (
       smoothstep(r1, 0, d1) +
       smoothstep(r1, 0, d2) +
       smoothstep(r1, 0, d3) +
       smoothstep(r1, 0, d4) ) / 4.0 );
}

void main() {
  vec2 xy = gl_FragCoord.xy / u_resolution;

  vec2 c1 = vec2(
      0.5 + 0.25 * cos(u_nFrame * M_PI * 2 * 2 + M_PI),
      0.5 + 0.25 * sin(u_nFrame * M_PI * 2));

  vec2 c2 = vec2(
      0.5 + 0.25 * cos(u_nFrame * M_PI * 2),
      0.5 + 0.25 * sin(u_nFrame * M_PI * 2 * 2 + M_PI * 1.5));

  vec2 c3 = vec2(
      0.5 + 0.25 * cos(u_nFrame * M_PI * 2 + M_PI * 3),
      0.5 + 0.25 * sin(u_nFrame * M_PI * 2 * 2 + M_PI ));

  vec2 c4 = vec2(
      0.5 + 0.25 * cos(u_nFrame * M_PI * 2 * 4 + M_PI),
      0.5 + 0.25 * sin(u_nFrame * M_PI * 2 * 2 + M_PI * 3));

  float d1 = distance(xy, c1);
  float d2 = distance(xy, c2);
  float d3 = distance(xy, c3);
  float d4 = distance(xy, c4);

  float b1 = ball(d1, d2, d3, d4, 0.3);
  float b2 = ball(d1, d2, d3, d4, 0.2);
  float b3 = ball(d1, d2, d3, d4, 0.1);

  vec3 color =
    b3 != 0 ? b3 * green :
    b2 != 0 ? b2 * yellow :
    b1 != 0 ? b1 * orange :
    red;

  gl_FragColor = vec4(color, 1.0);
}
