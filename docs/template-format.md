# Schedule template format (for AI from an owner's manual)

A schedule template is the list of recurring maintenance jobs for one kind of car. The app ships a few
(`assets/templates/`); for any other car you make one from its owner's manual without typing it in:

1. Car → **Schedule** → **Paste template** → **Copy prompt** (the prompt below goes to the clipboard).
2. In any AI chat (Claude, ChatGPT, Gemini …) paste the prompt and attach the manual — the PDF, or photos of the
   maintenance-schedule pages. Copy the JSON answer.
3. Back in the app: paste it → **Use**. The app checks it and keeps it on the phone (it is offered to every car that
   matches, and it is in the backup), then shows the jobs with their intervals: untick what does not apply →
   **Add N jobs to the schedule**.

To update a template, ask for the same `template` id with a higher `version` and paste it again. The format is the
same as the templates shipped with the app (decision D21 in `model/review-2026-11-21-first-cut.org`).

## Prompt

```text
From the attached owner's manual, make the car's maintenance schedule as JSON, exactly in this shape and nothing else
(no comments, no markdown):

{"template": "make-model-generation-fuel", "version": 1,
 "title": {"en": "Make Model Generation (years), fuel", "uk": "the same in Ukrainian"},
 "addon": false,
 "match": {"make": "Make", "models": ["Model"], "years": [2013, 2020], "fuels": ["petrol"], "engines": ["1.4 TSI"]},
 "note": {"en": "...", "uk": "..."},
 "sources": [{"title": "Owner's manual, <section>, p. <page>"}],
 "items": [{"item": "engine-oil", "title": {"en": "Engine oil + filter", "uk": "Моторна олива + фільтр"},
            "every_km": 15000, "every_months": 12, "soon_km": 1000,
            "note": {"en": "...", "uk": "..."}, "sources": [0]}]}

Rules:
- One item per recurring job of the manual's maintenance schedule: engine oil and filter, air, cabin and fuel
  filters, spark plugs, timing belt or chain, drive belt, coolant, brake fluid, gearbox / differential / transfer
  case oils, power steering fluid, brake and suspension inspections, and anything else the manual schedules.
  10–20 items; leave out one-off checks and wear parts without an interval.
- "every_km" and/or "every_months" as whole numbers (convert miles to km and years to months). Every item needs at
  least one of them. If the manual has a normal and a severe-conditions schedule, use the severe one (short trips,
  dust, cold winters) and give the normal interval in "note".
- "soon_km" / "soon_days" only where the job needs more notice than 1000 km / 30 days (e.g. a timing belt: 5000).
- "item" ids: lowercase-with-hyphens; use these where they fit: engine-oil, air-filter, cabin-filter, fuel-filter,
  spark-plugs, timing-belt, timing-chain, drive-belt, coolant, brake-fluid, gearbox-oil, atf,
  front-differential-oil, rear-differential-oil, transfer-case-oil, power-steering-fluid, brake-inspection,
  suspension-inspection.
- "template": lowercase-with-hyphens from make, model, generation and fuel, e.g. "skoda-octavia-a7-petrol".
- "match": the make and models as written on the car, the model years the manual covers, fuels from
  petrol / diesel / lpg / electric / hybrid, and the engines it covers. Omit a key you cannot tell.
- "sources": the manual's sections and pages the intervals come from; each item's "sources" are indexes into that
  list. Copy the numbers from the manual; do not invent intervals the manual does not give.
- Titles and notes in English ("en") and Ukrainian ("uk"), with the terms a Ukrainian garage uses.
- Do not include personal data (owner name, VIN, plate, dealer stamps).
```

## Fields

| Field | Meaning |
|---|---|
| `template`, `version` | id of the template and its version; a higher version replaces an imported one with the same id |
| `title`, `note` | `{"en": …, "uk": …}`; shown in the chosen language |
| `addon` | `true` for extra equipment added to any matching car (e.g. an LPG system), else `false` |
| `match` | `make`, `models`, `years` `[from, to]`, `fuels`, `engines` — which cars it is suggested for |
| `sources` | `[{"title": …, "url": …}]` — manual pages or web pages the intervals come from |
| `items[]` | `item` id, `title`, `every_km` and/or `every_months`, optional `soon_km` / `soon_days`, `note`, `sources` |

The app rejects a paste that is not this JSON, an item without an id, title or interval, a number that is not a
whole positive number, and the same template id with the same or an older version than one already imported.
