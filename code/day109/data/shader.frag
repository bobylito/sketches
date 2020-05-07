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

void main() {
  vec2 xy = gl_FragCoord.xy;

  int x = int(mod(xy.x, 8));
  int y = int(mod(xy.y, 8));

  vec2 xy1 =
      ((xy - u_resolution * 0.5) * 0.001 * (1.2 + sin(u_nFrame * M_PI))) +
      u_resolution * 0.5;
  vec2 xy2 = ((1.3 + sin(u_nFrame * M_PI)) * (xy - u_resolution * 0.5) * 0.01) +
             u_resolution * 0.5;

  float final = find_closest(x, y, snoise2(xy1) * snoise2(xy2));

  gl_FragColor = vec4(vec3(final), 1.0);
}
