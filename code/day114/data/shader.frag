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

void main() {
  // vec2 xy = gl_FragCoord.xy / u_resolution;
  vec2 xy = vertTexCoord.st;

  float minD = 2.0;

  for (int i = -1; i <= 1; i++) {
    for (int j = -1; j <= 1; j++) {
      vec2 point = vec2(float(i) + 0.5 * cos(u_nFrame * M_PI * 2.),
                        float(j) + 0.5 * sin(u_nFrame * M_PI * 2.));
      float dist = distance(point, xy);
      minD = min(minD, dist);
    }
  }

  float brightness =
      (smoothstep(0.25, 0.35, minD) - smoothstep(0.05, .5, minD));

  gl_FragColor = vec4(vec3(brightness), 1.);
}
