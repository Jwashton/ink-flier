import { IDENTITY, encodeMatrix, findInverse } from "./util/canvasMatrix.mjs";

export const View = function View() {
  return {
    matrix: IDENTITY,
    inverseMatrix: IDENTITY,
    rotation: 0,
    scale: 1,
    position: { x: 0, y: 0 },
    moveStart: { x: 0, y: 0 },
    pinchStartDistance: 0,
    pinchScale: 1,
    pinchAngle: 0,
    pinchStartAngle: 0
  };
};

//   Update the matrix and inverseMatrix to match the current position,
// rotation, and scale.
View.update = function toMatrix(view) {
  view.matrix = encodeMatrix(view.position, view.rotation, view.scale);
  view.inverseMatrix = findInverse(view.matrix);
};

//   Convert a screen point to a world point.
View.screenToWorld = function screenToWorld(view, { x, y }) {
  const xx = x - view.matrix[4];
  const yy = y - view.matrix[5];

  return {
    x: xx * view.inverseMatrix[0] + yy * view.inverseMatrix[2],
    y: xx * view.inverseMatrix[1] + yy * view.inverseMatrix[3]
  };
};

//   Convert a world point to a screen point.
View.worldToScreen = function worldToScreen(view, { x, y }) {
  return {
    x: x * view.matrix[0] + y * view.matrix[2] + view.matrix[4],
    y: x * view.matrix[1] + y * view.matrix[3] + view.matrix[5]
  };
};

//   Start a pinch touch gesture.
View.startPinch = function startPinch(view, p1, p2) {
  const x = p2.x - p1.x;
  const y = p2.y - p1.y;

  view.pinchStartDistance = Math.sqrt(x * x + y * y);
  view.pinchStartAngle = Math.atan2(y, x);
  view.pinchScale = view.scale;
  view.pinchAngle = view.rotation;

  view.moveStart = View.screenToWorld(view, p1);
};

//   Start a drag mouse gesture.
View.startDrag = function startDrag(view, point) {
  view.moveStart = View.screenToWorld(view, point);
};

//   Move a pinch touch gesture.
View.movePinch = function movePinch(view, p1, p2) {
  const x = p2.x - p1.x;
  const y = p2.y - p1.y;

  const pointDistance = Math.sqrt(x * x + y * y);
  const angle = Math.atan2(y, x);

  view.scale = view.pinchScale * (pointDistance / view.pinchStartDistance);
  view.rotation = view.pinchAngle + (angle - view.pinchStartAngle);

  view.position.x = p1.x - view.moveStart.x * view.matrix[0] - view.moveStart.y * view.matrix[2];
  view.position.y = p1.y - view.moveStart.x * view.matrix[1] - view.moveStart.y * view.matrix[3];

  return View.update(view);
};

//   Move a drag mouse gesture.
View.moveDrag = function moveDrag(view, point) {
  view.position.x = point.x - view.moveStart.x * view.matrix[0] - view.moveStart.y * view.matrix[2];
  view.position.y = point.y - view.moveStart.x * view.matrix[1] - view.moveStart.y * view.matrix[3];

  return View.update(view);
};

//   Change just the scale. Consider adding a new function if you need to
// change more than one attribute, to save time updating the matrix.
View.setScale = function setScale(view, scale) {
  view.scale = scale;

  return View.update(view);
};

View.scale = function scale(view) {
  return view.scale;
};

View.setRotation = function setRotation(view, rotation) {
  view.rotation = rotation;

  return View.update(view);
};

View.setPosition = function setPosition(view, position) {
  view.position = position;

  return View.update(view);
};

View.setX = function setX(view, x) {
  view.position.x = x;

  return View.update(view);
};

View.setY = function setY(view, y) {
  view.position.y = y;

  return View.update(view);
};

View.setAll = function setAll(view, { position, rotation, scale }) {
  view.position = position;
  view.rotation = rotation;
  view.scale = scale;

  return View.update(view);
};

//   Get the current transformation matrix.
View.matrix = function matrix(view) {
  return view.matrix;
};

export default View;
