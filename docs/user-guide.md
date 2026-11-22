# User guide

auto-maintenance keeps the maintenance diary of your cars and shows what is due next. Everything stays on your phone:
no account, no server. This guide describes version 0.1 (2026-11-22).

> **Your data lives only in the app.** Uninstalling the app deletes it, and there is no backup or export yet. Update
> the app by installing the new APK over the old one (`adb install -r …` or opening the APK) — that keeps the data.

## Install

1. Get `app-release.apk` (releases page, or `bb release` — see the [developer guide](developer-guide.md)).
2. Copy it to the phone and open it; Android asks once to allow installs from that app (Files, browser).
   With USB debugging on: `adb install -r app-release.apk`.
3. The app appears in the launcher as **cljd_auto_maintenance**.

## Garage — your cars

The start screen lists the cars with plate, last mileage and the most urgent job (coloured: red overdue, orange soon,
green ok, grey unknown). Tap **+** to add a car:

- **Name** (any), **VIN** (17 characters, letters I, O, Q are not allowed), **number plate** (spaces and Cyrillic
  look-alike letters are fine: `ка 5678 ві` is stored as `KA5678BI`), make, model, year, engine.
- **Fuel** petrol or diesel, and **LPG** if the car has a gas system — LPG is never in the VIN, so tick it here.

A VIN or a plate can belong to one car only. Reading the VIN from a photo comes later; type it for now.

## Car — what is due

Tap a car. From top to bottom:

- **Mileage line** — last km and date; tap it for the **Mileage** screen (all readings with their photos).
- **To fix** — open defects (see below).
- **Schedule** — every job with its status:

| Status | Meaning |
|---|---|
| **overdue** | the km limit or the date limit is reached |
| **soon** | within the warning window: 1 000 km or 30 days before (per job, see *Warn … km before*) |
| **ok** | not soon yet |
| **unknown** | never recorded as done — tap it and enter when it was last done |

The line under each job shows when it was last done, when it is due (km and date — whichever comes first counts), km
left and a predicted date from your average daily mileage over the last 90 days.

Top bar: **gauge** = odometer reading, **wrench** = log work, **clock** = diary.

## Schedule — adding a job

Car → **+** → name the job and give **every … km** and/or **every … months**. Optionally **warn … km before** (more
notice for big jobs, e.g. 5 000 km for a timing belt).

**Last done** (optional): the odometer km and date when the job was last done. This is how you start with a car that
already has a history. Example — the LPG system was installed about 2 000 km ago:

- Job *LPG filters*, every 8 000 km.
- Last done at *(today's km − 2 000)*, on *(installation date)*.
- The job is due at that km + 8 000, i.e. in about 6 000 km.

Do the same for engine oil, transmission oil, filters, timing belt, brake fluid, coolant — with the numbers from the
owner's manual and the dates/km from the service book.

**Tap a job** to change its intervals (the due point moves; the reason is optional), to record when it was last
done, or to **stop tracking** it (it leaves the list; its history stays in the diary).

## Odometer reading from a photo

Car → **gauge** → **Photo of the odometer**. The phone reads the number (on the device, no internet needed) and fills
the km field; other numbers it found are shown as chips — tap the right one if needed. Check the number and **Save**.
You can also type the km without a photo.

- A reading lower than the last one is refused — the odometer never goes back.
- A misread number already saved: Mileage screen → **long-press** the reading → correct it with a reason.
- Both the confirmed and the recognised number are kept, so you can see how often recognition was wrong.

Readings make predictions possible: one reading every couple of weeks is enough.

## Log work — the diary

Car → **wrench** (or Diary → **Log work**). One entry per visit or job:

- **Date** and **km** (today and the current km are filled in; change them to enter past work).
- **Scheduled jobs done** — tick them; their due points restart from this entry.
- **Issues fixed** — tick the defects this visit fixed; they leave the To-fix list.
- **Other work**, one item per line (e.g. *winter tyres on*), **note** (oil brand, litres), **cost** in UAH with a
  **category** (service, repair, tyres, other), **garage**, **receipt photo**.

An entry must contain at least one job, one line of other work or one fixed issue; a cost needs a category.

**Diary** (clock icon) lists the entries, newest first. **Long-press** an entry logged by mistake to void it with a
reason; jobs fall back to their previous due point and issues it fixed are open again. **Costs** (card icon in the
diary) shows the money per year and category.

## To fix — defects for the mechanic

Car → **To fix** → **⊕**: describe what is broken (*Left turn signal*), optionally with a photo. The list stays until
a diary entry fixes the issue, or you withdraw it (**long-press** → reason, e.g. *fixed it myself*).

- **Share** opens Android's share sheet (Viber, Telegram, SMS …) with a ready message:
  ```
  Subaru Forester (AA1234BB) — to fix:
  1. Left turn signal
  2. Handbrake too weak
  ```
- **Copy** puts the same text into the clipboard.

## Not yet in this version

- Reminder notifications (the settings for time, days and warning window exist in the model, the screen comes with
  the notifications).
- Ukrainian translation (English only for now).
- Reading the VIN from a photo, and schedule templates per car type (incl. an LPG add-on template).
- Backup / export of the data.
