import Program from "../../director/program.mts";
import vertexShaderSource from "./vertex.glsl";
import fragmentShaderSource from './fragment.glsl';

const vertices = [
  0, 0,
  1, 0,
  0, 1,

  1, 0,
  0, 1,
  1, 1
];

export const init = function init(gl: WebGL2RenderingContext) {
  const program = Program(gl, vertexShaderSource, fragmentShaderSource);

  const buffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW);

  const vao = gl.createVertexArray();
  gl.bindVertexArray(vao);

  program.registerAttribute('a_position');
  program.enableAttribute('a_position', 2, gl.FLOAT, false, 0, 0);

  return {
    program,
    buffer
  };
};
