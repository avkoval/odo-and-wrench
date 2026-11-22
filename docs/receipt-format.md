# Receipt format (for AI transcription)

A garage receipt (наряд-замовлення, invoice) becomes a diary entry with its parts and labour lines without typing:
give the photo and the prompt below to any AI chat (Claude, ChatGPT, Gemini …), copy its answer, and paste it into
**Log work → Paste receipt** in the app. The app checks the numbers (each sum = quantity × price, total = all sums)
and shows the entry before saving; you tick the scheduled jobs the visit covered and the issues it fixed.

The app has a **Copy prompt** button with the same text.

## Prompt

```text
Transcribe this car service receipt into JSON, exactly in this shape and nothing else (no comments, no markdown):

{"date": "YYYY-MM-DD", "km": 123456, "place": "garage name", "order_no": "receipt number", "currency": "UAH",
 "parts": [{"name": "...", "qty": 1, "unit": "pcs", "price": 0.00, "sum": 0.00}],
 "labor": [{"name": "...", "qty": 1, "unit": "h", "price": 0.00, "sum": 0.00}],
 "total": 0.00}

Rules:
- parts = the spare parts / materials table, labor = the works table; one object per line, in receipt order.
- Numbers as plain JSON numbers with a dot: 1 600,00 -> 1600.00; km without spaces: 248 258 -> 248258.
- Keep names as printed (any language); unit as printed (l, шт, год …); leave out lines with no price.
- "km" is the mileage on the receipt; "date" is the receipt date; omit a field you cannot read.
- Do not include personal data (customer name, phone, VIN, plate, mechanic names).
- Check: every sum = qty × price, total = sum of all lines. If the receipt disagrees, copy the receipt's numbers.
```

## Fields

| Field | Required | Meaning |
|---|---|---|
| `date` | yes | receipt date, `YYYY-MM-DD` |
| `km` | yes | odometer km on the receipt (integer) |
| `place` | no | garage / service centre |
| `order_no` | no | receipt or order number |
| `currency` | no | default `UAH` |
| `parts` | no | spare parts and materials: `name`, `qty`, `unit`, `price`, `sum` |
| `labor` | no | works: `name`, `qty`, `unit`, `price`, `sum` |
| `total` | yes | the receipt's total; must equal the sum of all lines |

At least one line is needed. Example (invented values):

```json
{"date": "2026-11-17", "km": 248300, "place": "Service centre", "order_no": "1234", "currency": "UAH",
 "parts": [{"name": "Transmission oil 75W-80", "qty": 2.3, "unit": "l", "price": 850.00, "sum": 1955.00}],
 "labor": [{"name": "Remove and refit the underbody shield", "qty": 0.2, "unit": "h", "price": 1700.00, "sum": 340.00}],
 "total": 2295.00}
```
