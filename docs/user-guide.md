# User guide

Odo & Wrench keeps the maintenance diary of your cars and shows what is due next. Everything stays on your phone:
no account, no server. This guide describes version 0.2 (2026-11-23).

> **Your data lives only in the app.** Uninstalling the app deletes it — export a backup now and then (Settings →
> **Export backup**). Update the app by installing the new APK over the old one (`adb install -r …` or opening the
> APK) — that keeps the data.

## Install

1. Get `app-release.apk` (releases page, or `bb release` — see the [developer guide](developer-guide.md)).
2. Copy it to the phone and open it; Android asks once to allow installs from that app (Files, browser).
   With USB debugging on: `adb install -r app-release.apk`.
3. The app appears in the launcher as **Odo & Wrench**.

## Garage — your cars

The start screen lists the cars with plate, last mileage and the most urgent job (coloured: red overdue, orange soon,
green ok, grey unknown). The **gear** icon opens the Settings. Tap **+** to add a car:

- **Photo of the VIN or the registration certificate** (camera or gallery): the phone finds the 17-character VIN in
  the photo and fills it in, with what can be read from it — the make always, the model and year for Japanese and
  North American cars and for Ford Europe (e.g. a Transit). Several candidates are shown as chips; tap the right one.
  Check every field: the photo only suggests.
- **Name** (any), **VIN** (17 characters, letters I, O, Q are not allowed), **number plate** (spaces and Cyrillic
  look-alike letters are fine: `ка 5678 ві` is stored as `KA5678BI`), make, model, year, engine.
- **Fuel** petrol or diesel, and **LPG** if the car has a gas system — LPG is never in the VIN, so tick it here.

A VIN or a plate can belong to one car only. The VIN can also be typed.

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

## Schedule — from a template

When the app has a schedule template for the car, the Car screen shows it above the schedule: *Suggested schedule:
N jobs — tap to review*. Templates so far: Subaru Forester SH (2008–2013, petrol EJ20/EJ25), Ford Transit Mk7
(2006–2014, 2.2/2.4 TDCi) and the **LPG system** add-on (gas filters every 8 000 km, reducer, injectors, diagnostics,
tank) for any car with LPG.

The template screen lists each job with its interval and a note on where the number comes from; the sources are at
the bottom. Untick what your car does not need (e.g. the automatic-gearbox oil on a manual car) → **Add N jobs to the
schedule**. Jobs the car already has stay as they are. New jobs start as *unknown*: tap each and enter when it was
last done. Intervals were researched from public sources and are a starting point — change any of them (tap the job).

For other cars, use **Paste template** in the Schedule section. Copy the prompt and give it to an AI chat with
the relevant pages of the owner's manual. Paste the resulting JSON, then review the sources and intervals before
adding any jobs. The template is saved on your phone, appears for matching cars, and is included in backups.
See the [template format and prompt](template-format.md).

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

Car → **gauge** → **Photo of the odometer** → **Camera** or **Gallery** (a photo taken earlier works too). The phone reads the number (on the device, no internet needed) and fills
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
  **category** (service, repair, tyres, other), **garage**, **receipt photo** (camera or gallery).

An entry must contain at least one job, one line of other work, one fixed issue or receipt lines; a cost needs a
category.

### Garage receipt: paste instead of typing

A garage receipt (наряд-замовлення) lists **parts** and **labour**, each line with quantity, unit, price and sum.
To get it into the diary without typing:

1. Log work → **Paste receipt** → **Copy prompt** (the prompt goes to the clipboard).
2. In any AI chat (Claude, ChatGPT, Gemini …) paste the prompt and attach the receipt photo; copy the JSON answer.
3. Back in the app: paste it into the field → **Use**. The receipt appears as a card with its lines and total.
4. Tick the scheduled jobs it covered (e.g. *Transmission oil*) and the issues it fixed, check the category
   (*repair* is preset), optionally add the receipt photo → **Save**.

The app checks the arithmetic: every sum must be quantity × price and the total must be the sum of all lines — a
mismatch is reported (usually a transcription mistake: compare with the paper). The format and the prompt are in
[receipt-format.md](receipt-format.md). In the **Diary** such an entry says how many lines it has; tap it to see them.
**Costs** shows each year also split into parts, labour and other.

**Diary** (clock icon) lists the entries, newest first. **Long-press** an entry logged by mistake to void it with a
reason; jobs fall back to their previous due point and issues it fixed are open again. **Costs** (card icon in the
diary) shows the money per year and category.

## To fix — defects for the mechanic

Car → **To fix** → **⊕**: describe what is broken (*Left turn signal*), optionally with a photo (camera or gallery). The list stays until
a diary entry fixes the issue, or you withdraw it (**long-press** → reason, e.g. *fixed it myself*).

- **Share** opens Android's share sheet (Viber, Telegram, SMS …) with a ready message:
  ```
  Subaru Forester (AA1234BB) — to fix:
  1. Left turn signal
  2. Handbrake too weak
  ```
- **Copy** puts the same text into the clipboard.

## Settings

Garage → **gear**.

- **Language** — English or Українська. Screens and notifications switch at once; what you typed (notes, names)
  stays as written.
- **Reminders** — on/off, the **time** and the **days** of the reminder, how early a job counts as *soon* (km and
  days, used where the job has no own warning window) and after how many days without a reading the app asks for an
  odometer photo. **Save reminder settings**; Android asks once whether the app may show notifications — allow it.
- At the chosen time the app checks every car and sends one notification per job when it becomes *soon* and again
  when it becomes *overdue* (not every day). Logging the job starts its next cycle. A car without a reading for the
  set number of days gets "take an odometer photo". Android may deliver the check some minutes late to save battery.
- **Check reminders now** — runs the same check at once (to try it out).

### Backup

- **Export backup** — makes a zip with all your data (events.jsonl) and photos and opens the share sheet: save it to
  Files or Google Drive, or send it to yourself.
- **Restore from backup** — pick such a zip; after you confirm, it **replaces** all data on this phone (use it on a
  new phone, or to undo a mistake with an older backup).

## Not yet in this version

- Templates for other cars (for now: Forester SH, Transit Mk7, LPG add-on); online VIN lookup.
- Automatic backups (export is manual).
