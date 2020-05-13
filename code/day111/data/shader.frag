#ifdef GL_ES
precision mediump float;
#endif

#define PROCESSING_COLOR_SHADER

#define M_PI 3.1415926535897932384626433832795

// clang-format off
#pragma glslify: snoise2 = require(glsl-noise/simplex/2d)
// clang-format on

uniform vec2 u_resolution;
uniform float u_nFrame;

int dither[64] =
    int[64](0, 32, 8, 40, 2, 34, 10, 42, 48, 16, 56, 24, 50, 18, 58, 26, 12, 44,
            4, 36, 14, 46, 6, 38, 60, 28, 52, 20, 62, 30, 54, 22, 3, 35, 11, 43,
            1, 33, 9, 41, 51, 19, 59, 27, 49, 17, 57, 25, 15, 47, 7, 39, 13, 45,
            5, 37, 63, 31, 55, 23, 61, 29, 53, 21);

float find_closest(int x, int y, float c0) {
  float limit = 0.0;
  if (x < 8) {
    limit = (dither[x + y * 8] + 1) / 64.0;
  }

  if (c0 < limit)
    return 0.0;
  return 1.0;
}

vec2 random2(vec2 p) {
  return fract(
      sin(vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)))) *
      43758.5453);
}

void main() {
  float scale = 5.;
  vec2 xy = gl_FragCoord.xy / u_resolution;

  xy *= scale;

  vec2 i_xy = floor(xy);
  vec2 f_xy = fract(xy);

  float minD = 2.0;

  for (int i = -1; i <= 1; i++) {
    for (int j = -1; j <= 1; j++) {
      vec2 cell = vec2(float(i), float(j));
      vec2 point = random2((cell + i_xy));
      point = 0.5 + 0.5 * sin(u_nFrame + M_PI * 2 * point);
      float dist = length(max(abs(cell + point - f_xy) - .1, 0.)) *
                   abs(snoise2(vec2(0.3 + 0.2 * cos(u_nFrame * M_PI),
                                    0.6 + 0.2 * sin(u_nFrame * M_PI))));
      minD = min(minD, dist);
    }
  }

  int x = int(mod(gl_FragCoord.x, 8));
  int y = int(mod(gl_FragCoord.y, 8));

  vec3 color =
      vec3(find_closest(x, y, smoothstep(0.3, 0.9, fract(minD * 20.))));

  gl_FragColor = vec4(color, 1.0);
}
