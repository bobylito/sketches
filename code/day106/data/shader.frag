#ifdef GL_ES
precision mediump float;
#endif

#define STRAWBERRY vec3(0.952, 0.333, 0.533)
#define AQUA vec3(0.019, 0.874, 0.843)
#define LEMON vec3(1, 0.960, 0.568)
#define PROCESSING_COLOR_SHADER

#define M_PI 3.1415926535897932384626433832795

uniform vec2 u_resolution;
uniform float u_frame;
uniform float u_nFrame;
uniform vec3 colorA;

mat2 rotate(float a) { return mat2(cos(a), -sin(a), sin(a), cos(a)); }

float f(vec2 xy, vec2 center, float beat) {
  float a = atan(center.y, center.x);
  float r = length(center) * (2.0 + beat);

  float f = 0.7 + 0.3 * sin(a * 5.0);

  return step(f, r);
}

void main() {
  vec2 xy = gl_FragCoord.xy / u_resolution;

  float c = 0.;
  float beat = 0.5 * min(-0.5, sin(u_nFrame * M_PI * 10.));
  for (int i = 0; i < 10; i++) {
    float shift = M_PI * float(i) / 5.;
    vec2 pos = vec2(0.5 + 0.1 * cos(u_nFrame * M_PI * 2. + shift),
                    0.5 + 0.1 * sin(u_nFrame * M_PI * 2. + shift)) -
               xy;
    c += f(xy, pos, beat) * 0.1;
  }

  vec3 color = mix(STRAWBERRY, LEMON, c);
  gl_FragColor = vec4(color, 1.0);
}
