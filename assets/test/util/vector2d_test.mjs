import assert from 'node:assert';
import test from 'node:test';

import Vector2D from '../../js/util/vector2d.mjs';

test('Adding two vectors', (_t) => {
  const v1 = new Vector2D(1, 2);
  const v2 = new Vector2D(3, 4);
  const result = Vector2D.add(v1, v2);

  assert.strictEqual(result.x, 4);
  assert.strictEqual(result.y, 6);
});

test('Subtracting two vectors', (_t) => {
  const v1 = new Vector2D(1, 3);
  const v2 = new Vector2D(3, 4);
  const result = Vector2D.sub(v1, v2);

  assert.strictEqual(result.x, -2);
  assert.strictEqual(result.y, -1);
});

test('Negating a vector', (_t) => {
  const v = new Vector2D(1, -2);
  const result = Vector2D.negate(v);

  assert.strictEqual(result.x, -1);
  assert.strictEqual(result.y, 2);
});

test('Calculating the magnitude of a vector', (_t) => {
  const v = new Vector2D(3, 4);

  assert.strictEqual(Vector2D.magnitude(v), 5);
});

test('Calculating the distance between two vectors', (_t) => {
  const v1 = new Vector2D(1, 2);
  const v2 = new Vector2D(4, 6);

  assert.strictEqual(Vector2D.distance(v1, v2), 5);
});

test('Normalizing a vector', (_t) => {
  const v = new Vector2D(3, 4);
  const result = Vector2D.normalize(v);

  assert.strictEqual(result.x, 0.6);
  assert.strictEqual(result.y, 0.8);
});

test('Scaling a vector', (_t) => {
  const v = new Vector2D(3, 4);
  const result = Vector2D.scale(v, 2);

  assert.strictEqual(result.x, 6);
  assert.strictEqual(result.y, 8);
});

test('Calculating the dot product of two vectors', (_t) => {
  const v1 = new Vector2D(1, 2);
  const v2 = new Vector2D(3, 4);

  assert.strictEqual(Vector2D.dot(v1, v2), 11);
});

test('Calculating the projection of one vector onto another', (_t) => {
  const v1 = new Vector2D(1, 0);
  const v2 = new Vector2D(3, 4);
  const result = Vector2D.projection(v1, v2);

  assert.strictEqual(result.x, 3);
  assert.strictEqual(result.y, 0);
});
