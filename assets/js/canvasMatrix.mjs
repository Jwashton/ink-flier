// context.transform takes values in the order m11, m12, m21, m22, m31, m32
// and the function assumes the last row of the matrix is 0, 0, 1. Therefor
// despite looking like two rows of 1, 0, 0, this is equivalent to this matrix:
//     |1 0 0|
//     |0 1 0|
//     |0 0 1|
export const IDENTITY = Object.freeze([1, 0, 0, 1, 0, 0]);

// All these functions expect an array of six elements, s.t. they could
// be passed to `context.transform`.
export const rotationalCrossProduct = function rotationalCrossProduct(matrix) {
  const [a, d, b, e, _c, _f] = matrix;

  return a * e - b * d;
};

export const encodeMatrix = function encodeMatrix({ x, y }, rotate, scale) {
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

export const findInverse = function findInverse(matrix) {
  const [a, d, b, e, _c, _f] = matrix;
  const cross = rotationalCrossProduct(matrix);

  console.log(cross);

  return [
    e / cross,
    -d / cross,
    -b / cross,
    a / cross,
    0,
    0
  ];
};

export default { IDENTITY, rotationalCrossProduct, encodeMatrix, findInverse };
