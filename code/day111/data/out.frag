#ifdef GL_ES
precision mediump float;
#define GLSLIFY 1
#endif

#define PROCESSING_COLOR_SHADER

#define M_PI 3.1415926535897932384626433832795

// clang-format off
//
// Description : Array and textureless GLSL 2D simplex noise function.
//      Author : Ian McEwan, Ashima Arts.
//  Maintainer : ijm
//     Lastmod : 20110822 (ijm)
//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.
//               Distributed under the MIT License. See LICENSE file.
//               https://github.com/ashima/webgl-noise
//

vec3 mod289(vec3 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec2 mod289(vec2 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec3 permute(vec3 x) {
  return mod289(((x*34.0)+1.0)*x);
}

float snoise(vec2 v)
  {
  const vec4 C = vec4(0.211324865405187,  // (3.0-sqrt(3.0))/6.0
                      0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
                     -0.577350269189626,  // -1.0 + 2.0 * C.x
                      0.024390243902439); // 1.0 / 41.0
// First corner
  vec2 i  = floor(v + dot(v, C.yy) );
  vec2 x0 = v -   i + dot(i, C.xx);

// Other corners
  vec2 i1;
  //i1.x = step( x0.y, x0.x ); // x0.x > x0.y ? 1.0 : 0.0
  //i1.y = 1.0 - i1.x;
  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  // x0 = x0 - 0.0 + 0.0 * C.xx ;
  // x1 = x0 - i1 + 1.0 * C.xx ;
  // x2 = x0 - 1.0 + 2.0 * C.xx ;
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;

// Permutations
  i = mod289(i); // Avoid truncation effects in permutation
  vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
    + i.x + vec3(0.0, i1.x, 1.0 ));

  vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
  m = m*m ;
  m = m*m ;

// Gradients: 41 points uniformly over a line, mapped onto a diamond.
// The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)

  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;

// Normalise gradients implicitly by scaling m
// Approximation of: m *= inversesqrt( a0*a0 + h*h );
  m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );

// Compute final noise value at P
  vec3 g;
  g.x  = a0.x  * x0.x  + h.x  * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}

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
                   abs(snoise(vec2(0.3 + 0.2 * cos(u_nFrame * M_PI),
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
