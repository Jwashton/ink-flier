import { IDENTITY, encodeMatrix, findInverse } from "./canvasMatrix.mjs";

export const View = function View() {
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

export default View;
