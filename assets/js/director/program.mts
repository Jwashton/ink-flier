const createShader = function createShader(gl: WebGL2RenderingContext, source: string, type: GLenum): WebGLShader {
  const shader = gl.createShader(type);

  if (!shader) {
    throw new Error('Could not create shader');
  }

  gl.shaderSource(shader, source);
  gl.compileShader(shader);

  if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
    const info = gl.getShaderInfoLog(shader);

    throw new Error(`Could not compile WebGL shader. \n\n${info}`);
  }

  return shader;
};

export interface Program {
  glProgram: WebGLProgram;
  attributes: Map<string, GLint>;
  uniforms: Map<string, WebGLUniformLocation>;

  use(): void;
  registerAttribute(name: string): void;

  enableAttribute(name: string, size: number, type: GLenum, normalize: boolean, stride: number, offset: number): void;
}

export const Program = function Program(gl: WebGL2RenderingContext, vertexShaderSource: string, fragmentShaderSource: string): Program {
  const glProgram = gl.createProgram();

  if (!glProgram) {
    throw new Error('Could not create WebGL program');
  }

  const vertexShader = createShader(gl, vertexShaderSource, gl.VERTEX_SHADER);
  const fragmentShader = createShader(gl, fragmentShaderSource, gl.FRAGMENT_SHADER);

  gl.attachShader(glProgram, vertexShader);
  gl.attachShader(glProgram, fragmentShader);

  gl.linkProgram(glProgram);

  const attributes = new Map();
  const uniforms = new Map();

  return {
    glProgram,

    attributes,

    uniforms,

    use() {
      gl.useProgram(glProgram);
    },

    registerAttribute(name: string) {
      const location = gl.getAttribLocation(glProgram, name);

      if (location === -1) {
        throw new Error(`Could not find attribute ${name}`);
      }

      attributes.set(name, location);
    },

    enableAttribute(name: string, size: number, type: GLenum, normalize: boolean, stride: number, offset: number) {
      const location = attributes.get(name);

      if (location === undefined) {
        throw new Error(`Could not find attribute ${name}`);
      }

      gl.enableVertexAttribArray(location);

      // WARNING! This also binds the buffer to the ARRAY_BUFFER target
      // Should this really be called here?
      gl.vertexAttribPointer(location, size, type, normalize, stride, offset);
    }
  };
};

export default Program;
