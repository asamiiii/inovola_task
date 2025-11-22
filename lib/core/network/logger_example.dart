// Example of how the pretty logger will format API requests:

/*
┌──────────────────────────────────────────────────────────────────────────────────────────────────
│ Request ⬆
├──────────────────────────────────────────────────────────────────────────────────────────────────
│ GET https://open.er-api.com/v6/latest/USD
│ Headers:
│  • Content-Type: application/json
│  • Accept: application/json
│ Body: None
└──────────────────────────────────────────────────────────────────────────────────────────────────

┌──────────────────────────────────────────────────────────────────────────────────────────────────
│ Response ⬇
├──────────────────────────────────────────────────────────────────────────────────────────────────
│ Status Code: 200 OK
│ Body:
│ {
│   "result": "success",
│   "provider": "https://www.exchangerate-api.com",
│   "documentation": "https://www.exchangerate-api.com/docs/free",
│   "terms_of_use": "https://www.exchangerate-api.com/terms",
│   "time_last_update_unix": 1700611200,
│   "time_last_update_utc": "Wed, 22 Nov 2023 00:00:00 +0000",
│   "time_next_update_unix": 1700697600,
│   "time_next_update_utc": "Thu, 23 Nov 2023 00:00:00 +0000",
│   "time_eol_unix": 0,
│   "base_code": "USD",
│   "rates": {
│     "USD": 1,
│     "EUR": 0.92,
│     "GBP": 0.79,
│     "EGP": 30.90,
│     ...
│   }
│ }
└──────────────────────────────────────────────────────────────────────────────────────────────────
*/

// Configuration used:
// - requestHeader: true - Shows request headers
// - requestBody: true - Shows request body
// - responseBody: true - Shows response body
// - responseHeader: false - Hides response headers for cleaner output
// - error: true - Shows errors
// - compact: true - Uses compact formatting
// - maxWidth: 90 - Sets maximum width to 90 characters
