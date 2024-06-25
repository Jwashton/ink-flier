export const Vector2D = function Vector2D(x, y) {
  return { x, y };
};

Vector2D.add = function add(v1, v2) {
  return Vector2D(v1.x + v2.x, v1.y + v2.y);
};

Vector2D.sub = function sub(v1, v2) {
  return Vector2D(v1.x - v2.x, v1.y - v2.y);
};

Vector2D.negate = function negate({ x, y }) {
  return Vector2D(-x, -y);
};

Vector2D.magnitude = function magnitude({ x, y }) {
  return Math.sqrt(x * x + y * y);
};

Vector2D.distance = function distance(v1, v2) {
  return Vector2D.magnitude(Vector2D.sub(v1, v2));
};

Vector2D.normalize = function normalize(v) {
  const mag = Vector2D.magnitude(v);

  return Vector2D(v.x / mag, v.y / mag);
};

Vector2D.scale = function scale(v, scalar) {
  return Vector2D(v.x * scalar, v.y * scalar);
};

Vector2D.dot = function dot(v1, v2) {
  return v1.x * v2.x + v1.y * v2.y;
};

Vector2D.projection = function projection(v1, v2) {
  const v1Normalized = Vector2D.normalize(v1);
  const scalar = Vector2D.dot(v1Normalized, v2);

  return Vector2D.scale(v1Normalized, scalar);
};

export default Vector2D;
