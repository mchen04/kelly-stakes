# Shared JavaScript Kelly helpers

Part of [mchen04/kelly-stakes](https://github.com/mchen04/kelly-stakes), maintained on the default branch `consolidate/kelly-monorepo`.

`@kelly-stakes/kelly` is a native ES module with TypeScript declarations and no runtime dependencies. Hero/LiveDemo import its odds converter and Kelly fraction; both extension popups and the OddsJam worker import its converter and rounded probability helper. Extension builds bundle these imports locally.

- `americanToDecimal(string | number)`: legacy integer American-text conversion; numbers pass through as decimal odds for the web.
- `extensionAmericanToDecimal(string)`: retains the extensions' first-plus stripping before conversion.
- `impliedPercentage(string)`: legacy extension percentage rounded to two decimals before sizing.
- `kellyFraction(decimalOdds, probability)`: `max(0, (b*p - (1-p))/b)`, where `b = decimalOdds - 1`.

Callers retain validation, multiplier, defaults and formatting. Swift retains its Foundation/Decimal engine, stricter constraints and full-precision probabilities. These differences preserve the original calculations. No new validation contract or cross-platform runtime bridge was introduced.

Run `npm test` at root for conversion, precision/legacy-rounding, negative-edge and fractional-sizing regression checks.
