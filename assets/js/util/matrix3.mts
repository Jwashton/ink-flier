export const Matrix3 = function Matrix3(values: number[]) {
  if (values.length === 9) {
    return [...values];
  }

  return [0, 0, 0, 0, 0, 0, 0, 0, 0];
};

export default Matrix3;
