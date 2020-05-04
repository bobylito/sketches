#ifdef GL_ES
precision mediump float;
#endif

#define PROCESSING_COLOR_SHADER

#define beige vec3(0.980, 0.949, 0.949)
#define taupe vec3(0.490, 0.352, 0.352)

#define M_PI 3.1415926535897932384626433832795

uniform vec2 u_resolution;
uniform float u_nFrame;

float f(vec2 xy, vec2 center, float zoom) {
  float a = atan(center.y, center.x);
  float r = length(center) * (2.0 * zoom);

  float f = 0.7 * cos(a * 2.); //+ 0.3 * sin(a * 5.0);

  return step(f, r);
}

void main() {
  vec2 xy = gl_FragCoord.xy / u_resolution;

  float c = 0.;
  float frameShift = sin(u_nFrame * M_PI);
  for (int i = 0; i < 10; i++) {
    float shift = M_PI * float(i * frameShift) / 5.;
    vec2 pos = vec2(0.5 + 0.1 * cos(u_nFrame * M_PI * 2. + shift),
                    0.5 + 0.1 * sin(u_nFrame * M_PI * 2. + shift)) -
               xy;
    c += f(xy, pos, 1.0) * 0.1;
  }

  gl_FragColor = vec4(mix(beige, taupe, c), 1.0);
}
