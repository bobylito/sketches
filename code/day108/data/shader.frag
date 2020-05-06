#ifdef GL_ES
precision mediump float;
#endif

#define PROCESSING_COLOR_SHADER

#define M_PI 3.1415926535897932384626433832795

uniform vec2 u_resolution;
uniform float u_nFrame;

// Ordered dithering aka Bayer matrix dithering
// Source:
// http://devlog-martinsh.blogspot.com/2011/03/glsl-8x8-bayer-matrix-dithering.html

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

float shape(vec2 xy, vec2 center, float size) {
  return smoothstep(size, 0, length(xy - center));
}

void main() {
  // nomralized value
  vec2 xy = gl_FragCoord.xy / u_resolution;

  int x = int(mod(gl_FragCoord.x, 8));
  int y = int(mod(gl_FragCoord.y, 8));

  float shade =
      smoothstep(0, .1,
                 (shape(xy, vec2(0.5, 0), (0.5 + .2 * sin(u_nFrame * M_PI))) +
                  shape(xy, vec2(0.5, 0.3 + 0.3 * sin(u_nFrame * M_PI)), 0.3) -
                  shape(xy, vec2(0.4, 0.3 + 0.3 * sin(u_nFrame * M_PI)),
                        0.1 + 0.1 * sin(u_nFrame * M_PI)) -
                  shape(xy, vec2(0.6, 0.3 + 0.3 * sin(u_nFrame * M_PI)),
                        0.1 + 0.1 * sin(u_nFrame * M_PI)) -
                  shape(xy, vec2(0.5, .2), (0.2 + .2 * sin(u_nFrame * M_PI)))) /
                     2.0);

  float final = find_closest(x, y, shade);

  gl_FragColor = vec4(vec3(final), 1.0);
}
