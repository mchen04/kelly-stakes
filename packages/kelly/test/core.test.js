import assert from 'node:assert/strict';
import test from 'node:test';
import { americanToDecimal, extensionAmericanToDecimal, impliedPercentage, kellyFraction } from '../index.js';

test('American conversion preserves both signs and the web decimal input', () => {
  assert.equal(americanToDecimal('+150'), 2.5);
  assert.equal(americanToDecimal('-200'), 1.5);
  assert.equal(americanToDecimal('100'), 2);
  assert.equal(americanToDecimal(2.5), 2.5);
  assert.equal(extensionAmericanToDecimal('+150'), 2.5);
  assert.equal(extensionAmericanToDecimal('-200'), 1.5);
});

test('extensions retain their two-decimal probability percentage', () => {
  assert.equal(impliedPercentage('-110'), 52.38);
  assert.equal(impliedPercentage('+120'), 45.45);
  assert.equal(impliedPercentage('invalid'), 0);
});

test('web sizing uses full probability while extensions preserve legacy rounding', () => {
  const decimal = americanToDecimal('+150');
  const full = kellyFraction(decimal, 1 / americanToDecimal('-110'));
  assert.ok(Math.abs(full - 13 / 63) < 1e-12);
  assert.equal(Math.round(10000 * full * 0.25), 516);
  const rounded = kellyFraction(decimal, impliedPercentage('-110') / 100);
  assert.equal((4000 * rounded).toFixed(2), '825.33');
});

test('a negative edge recommends zero and fractional Kelly scales the result', () => {
  assert.equal(kellyFraction(2, 0.4), 0);
  assert.equal(kellyFraction(3, 0.5), 0.25);
  assert.equal(1000 * kellyFraction(3, 0.5) * 0.5, 125);
});
