import assert from 'node:assert';
import { test } from 'node:test';

import { Matrix3 } from '../../js/util/matrix3.mjs';

test('Matrix3#constructor', () => {
  const matrix = Matrix3([1, 2, 3, 4, 5, 6, 7, 8, 9]);
  assert.deepStrictEqual(matrix, [1, 2, 3, 4, 5, 6, 7, 8, 9]);
});
