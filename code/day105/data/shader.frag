#ifdef GL_ES
precision mediump float;
#endif

#define PROCESSING_COLOR_SHADER

#define PI 3.1415926535897932384626433832795

#define STRAWBERRY vec3(0.952, 0.333, 0.533)
#define AQUA vec3(0.019, 0.874, 0.843)
#define LEMON vec3(1, 0.960, 0.568)
#define GREEN vec3(0.639, 0.968, 0.749)
#define WHITE vec3(1.0, 1.0, 1.0)

#define N 2

uniform vec2 u_resolution;
uniform float u_frame;
uniform float u_nFrame;

vec3 addSquare(vec2 xy, float scale) {
  // Angle and radius from the current pixel
  float a = atan(xy.x , xy.y) ;
  float r = PI / float(N);

  // Shaping function that modulate the distance
  float d = cos(floor( 0.5 + a / r) * r - a)*length(xy) * scale;

  return vec3(1. - step(.41, d)) - vec3(1. - step(.40,d));
}

vec3 addBluredSquare(vec2 xy, float scale) {
  // Angle and radius from the current pixel
  float a = atan(xy.x , xy.y) ;
  float r = PI / float(N);

  // Shaping function that modulate the distance
  float d = cos(floor( 0.5 + a / r) * r - a)*length(xy) * scale;

  return vec3(1. - smoothstep(0.8, 0., d)) - vec3(1. - smoothstep(0.950, 0.35, d));
}


void main() {
  vec2 xy = gl_FragCoord.xy / u_resolution;
  // Remap the space to -1. to 1.
  xy = xy * 2. - 1.;

  int s = int(floor((1. - u_nFrame) * 10));

  // Angle and radius from the current pixel
  float a = atan(xy.x , xy.y) ;
  float r = PI / float(N);

  // Shaping function that modulate the distance
  float d = cos(floor( 0.5 + a / r) * r - a)*length(xy) * .50;

  vec3 color = vec3(0);
  for(int i = 0; i < 20; i++) {
    bool isLight = (i % 5) == (s % 5);
    vec3 tint = isLight ? (i % 2 == 0 ? STRAWBERRY : AQUA) : WHITE;
    color += 
      (isLight ? 1.0 : 0.3) * addSquare(xy, 0.5 + 0.15 * float(i)) * tint +
      (isLight ? 0.15 : 0.0) * addBluredSquare(xy, 0.5 + 0.1 * float(i))  * tint;
  }

  gl_FragColor = vec4(color, 1.0);
}
