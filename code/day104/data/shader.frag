#ifdef GL_ES
precision mediump float;
#endif

#define PROCESSING_COLOR_SHADER

#define M_PI 3.1415926535897932384626433832795

#define STRAWBERRY vec3(0.952, 0.333, 0.533)
#define AQUA vec3(0.019, 0.874, 0.843)
#define LEMON vec3(1, 0.960, 0.568)
#define GREEN vec3(0.639, 0.968, 0.749)
#define WHITE vec3(1.0, 1.0, 1.0)

uniform vec2 u_resolution;
uniform float u_frame;
uniform float u_nFrame;

vec3 colorfulGrid(float u_nFrame, vec2 xy) {
  float gridSize = floor(5 + sin(u_nFrame * M_PI) * 3.99);
  vec2 gridPos = floor(xy * gridSize) / gridSize;
  vec2 remappedXY = fract(xy * gridSize);
  float d = distance(
      vec2(
        0.5 + 0.1 * cos(u_nFrame * 8 * M_PI),
        0.5 + 0.1 * sin(u_nFrame * 8 * M_PI)), 
      remappedXY);
  vec3 bgColor = mix(mix(STRAWBERRY, LEMON, gridPos.x),AQUA, gridPos.y) ;
  vec3 fgColor = WHITE;
  vec3 c = mix(
      fgColor,
      bgColor,
      smoothstep(0.8, 0.3, d)
      );

  return c;
}

void main() {
  vec2 xy = gl_FragCoord.xy / u_resolution;

  float d = distance(vec2(0.5, 0.5), xy);

  vec3 c = mix(
      WHITE,
      colorfulGrid(u_nFrame, xy),
      (0.5 + fract(u_nFrame + d * 10) * 0.5)) ;

  gl_FragColor = vec4(c, 1.0);
}
