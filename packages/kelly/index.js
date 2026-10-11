/** Convert legacy American odds text; numeric input is already decimal (web). */
export function americanToDecimal(odds) {
  if (typeof odds === 'number') return odds;
  const value = parseInt(odds);
  return value > 0 ? 1 + value / 100 : 1 + 100 / Math.abs(value);
}

/** Extensions historically remove the first '+' before integer parsing. */
export function extensionAmericanToDecimal(odds) {
  return americanToDecimal(odds.replace('+', ''));
}

/** Legacy extension probability percentage, rounded before sizing to retain results. */
export function impliedPercentage(odds) {
  const value = parseInt(odds);
  if (Number.isNaN(value)) return 0;
  const percentage = value > 0
    ? 100 / (value + 100) * 100
    : Math.abs(value) / (Math.abs(value) + 100) * 100;
  return parseFloat(percentage.toFixed(2));
}

/** Full Kelly fraction; callers retain their existing multiplier and money rounding. */
export function kellyFraction(decimalOdds, probability) {
  const b = decimalOdds - 1;
  return Math.max(0, (b * probability - (1 - probability)) / b);
}
