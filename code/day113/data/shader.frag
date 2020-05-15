#ifdef GL_ES
precision mediump float;
#endif

#define PROCESSING_COLOR_SHADER

#define M_PI 3.1415926535897932384626433832795

// clang-format off
#pragma glslify: snoise2 = require(glsl-noise/simplex/2d)
// clang-format on

varying vec4 vertColor;
varying vec4 vertTexCoord;

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
  vec2 xy = vertTexCoord.st; // gl_FragCoord.xy / u_resolution;

  int x = int(mod(xy.x * 320., 8));
  int y = int(mod(xy.y * 320., 8));
  float final = find_closest(
      x, y,
      fract(0.5 + (xy.x + xy.y) * sin(sin(u_nFrame * M_PI) * M_PI * 0.5)));

  gl_FragColor = vec4(vec3(final), (1.3 - final));
}
