#version 300 es

precision highp float;

uniform vec2 u_resolution;

out vec4 outColor;

void main() {
  vec2 st = gl_FragCoord.xy / u_resolution.xy;
  st.x *= u_resolution.x / u_resolution.y;

  float scale = 10.0f;
  float pointSize = 0.1f;
  float halfPoint = pointSize * 0.5f;
  float x = 1.0f - step(pointSize, fract(st.x * scale + halfPoint));
  float y = 1.0f - step(pointSize, fract(st.y * scale + halfPoint));

  vec3 color = vec3(x * y);

  outColor = vec4(color, 1.0f);
}
