/*************************************
 * Useful constants for graphics     *
 ************************************/

const TWO_PI = 2 * Math.PI;

// context.transform takes values in the order m11, m12, m21, m22, m31, m32
// and the function assumes the last row of the matrix is 0, 0, 1. Therefor
// despite looking like two rows of 1, 0, 0, this is equivalent to this matrix:
//     |1 0 0|
//     |0 1 0|
//     |0 0 1|
const IDENTITY = Object.freeze([1, 0, 0, 1, 0, 0]);

/*************************************
 * Convenience library for nicer API *
 *************************************/
const withState = function withState(context, callback) {
  context.save();
  callback(context);
  context.restore();
};

const fillPath = function fillPath(context, fillStyle, callback) {
  withState(context, ctx => {
    ctx.fillStyle = fillStyle;
    ctx.beginPath();
    callback(ctx);
    ctx.fill();
  });
};

/*************************************
 * Matrix Library                    *
 *************************************/

// All these functions expect an array of six elements, s.t. they could
// be passed to `context.transform`.
const rotationalCrossProduct = function rotationalCrossProduct(matrix) {
  const [a, d, b, e, _c, _f] = matrix;

  return a * e - b * d;
};

const encodeMatrix = function encodeMatrix({ x, y }, rotate, scale) {
  const sinVal = Math.sin(rotate) * scale;
  const cosVal = Math.cos(rotate) * scale;

  return [
    cosVal,
    sinVal,
    -sinVal,
    cosVal,
    x,
    y
  ];
};

const findInverse = function findInverse(matrix) {
  const [a, d, b, e, _c, _f] = matrix;
  const cross = rotationalCrossProduct(matrix);

  return [
    e / cross,
    -b / cross,
    -d / cross,
    a / cross,
    0,
    0
  ];
};

const View = function View() {
  return {
    matrix: IDENTITY,
    inverseMatrix: IDENTITY,
    rotation: 0,
    scale: 1,
    position: { x: 0, y: 0 },
    pinchStart: { x: 0, y: 0 },
    pinchStartDistance: 0,
    pinchScale: 1,
    pinchAngle: 0,
    pinchStartAngle: 0
  };
};

View.update = function toMatrix(view) {
  view.matrix = encodeMatrix(view.position, view.rotation, view.scale);
  view.inverseMatrix = findInverse(view.matrix);
};

View.screenToWorld = function screenToWorld(view, { x: fromX, y: fromY }) {
  const xx = fromX - view.matrix[4];
  const yy = fromY - view.matrix[5];

  return {
    x: xx * view.inverseMatrix[0] + yy * view.inverseMatrix[2],
    y: xx * view.inverseMatrix[2] + yy * view.inverseMatrix[3]
  };
};

View.worldToScreen = function worldToScreen(view, { x: fromX, y: fromY }) {
  return {
    x: fromX * view.matrix[0] + fromY * view.matrix[2] + view.matrix[4],
    y: fromX * view.matrix[1] + fromY * view.matrix[3] + view.matrix[5]
  };
};

View.startPinch = function startPinch(view, p1, p2) {
  const x = p2.x - p1.x;
  const y = p2.y - p1.y;

  view.pinchStart = View.screenToWorld(p1);
  view.pinchStartDistance = Math.sqrt(x * x + y * y);
  view.pinchStartAngle = Math.atan2(y, x);
  view.pinchScale = view.scale;
  view.pinchAngle = view.rotate;
};

View.movePinch = function movePinch(view, p1, p2) {
  const x = p2.x - p1.x;
  const y = p2.y - p1.y;

  const pointDistance = Math.sqrt(x * x + y * y);
  const angle = Math.atan2(y, x);

  view.scale = view.pinchScale * (pointDistance / view.pinchStartDistance);
  view.rotation = view.pinchAngle + (angle - view.pinchStartAngle);

  // also x and y? Why two updates?

  return View.update(view);
};

/************************************
 * Scene state                      *
 ************************************/

const camera = View();

const objects = [
  { type: 'square', x: 20, y: 20, size: 20, fill: '#30a0aa' },
  { type: 'circle', x: 60, y: 40, radius: 25, fill: '#ffbb50' },
  { type: 'square', x: 80, y: 50, size: 30, fill: '#15ddaa' }
];

[...Array(20).keys()].forEach(n => {
  objects.push({
    type: 'square',
    x: n * 4 + 20,
    y: 50 - Math.sqrt(n * 20),
    size: 3,
    fill: `hsl(${n * 20} 90% 80%)`
  });
});

/************************************
 * Rendering functions              *
 ************************************/
const Stencils = {
  square(ctx, { x, y, size, fill }) {
    withState(ctx, context => {
      context.fillStyle = fill;
      context.fillRect(x, y, size, size);
    });
  },

  circle(ctx, { x, y, radius, fill }) {
    fillPath(ctx, fill, context => {
      context.arc(x, y, radius, 0, TWO_PI);
    });
  }
};

/************************************
 * Canvas management                *
 ************************************/
const draw = function draw(context) {
  context.clearRect(0, 0, context.canvas.width, context.canvas.height);
  withState(context, ctx => {
    context.transform(...camera.matrix);
    for (const object of objects) {
      Stencils[object.type](context, object);
    }
  });
};

const setCanvasSizes = function setCanvasSizes(canvas, context) {
  const ogWidth = canvas.width;
  const ogHeight = canvas.height;
};

const enqueueRerender = function enqueueRerender(context) {
  window.requestAnimationFrame(() => {
    draw(context);
  });
};

const updateDebugView = function updateDebugView(element) {
  element.textContent = JSON.stringify(camera, null, 2);
}

const registerEventCallbacks = function registerEventCallbacks(canvas, context) {

};

const init = function init() {
  const canvas = document.getElementById('mainView');
  const context = canvas.getContext('2d');

  const rotationInput = document.getElementById('rotation');
  const scaleInput = document.getElementById('scale');
  const debugView = document.getElementById('debug');
  updateDebugView(debugView);

  rotationInput.addEventListener('input', event => {
    camera.rotation = Number(event.target.value);
    View.update(camera);
    updateDebugView(debugView);
    enqueueRerender(context);
  });

  scaleInput.addEventListener('input', event => {
    camera.scale = Number(event.target.value);
    View.update(camera);
    updateDebugView(debugView);
    enqueueRerender(context);
  });

  registerEventCallbacks(canvas, context);

  setCanvasSizes(canvas, context);
  enqueueRerender(context);
};

init();
