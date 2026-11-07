# Tiny Apps — sito web (www.tinyapps.it)

## Scopo
Sito vetrina di **Tiny Apps**, un piccolo studio indie che crea giochi semplici per divertimento.
Il tono è caldo e un po' professionale, da piccolo game studio: non lo facciamo per arricchirci,
ma donazioni su itch.io e acquisti in-app sono graditi.

Contenuti:
- **Giochi principali** (box grandi, in evidenza): Scribble Racers e Off Course, con link a itch.io
  (`https://tinyapps.itch.io/scribble-racers`, `https://tinyapps.itch.io/off-course`) e badge Google Play
  disabilitato "Coming soon" finché non sono pubblicati sullo store.
- **Altri giochi** (box piccoli, giocabili nel browser): Unwordle (`unwordle.tinyapps.it`) e F-Road (`f-road.tinyapps.it`).
  Niente link a GitHub.
- **Contatti** (`/contact.html`).
- **Informative privacy** per il Google Play Store: `/offcourse/privacy/` e `/scribble-racers/privacy/`.
  **Non vanno linkate dal sito**: servono solo come URL da inserire nella Play Console.

## Regole fisse
- Publisher name da usare in **tutte** le pagine e i testi: **"Tiny Apps"** (con maiuscole e spazio).
  `tinyapps` minuscolo solo nei domini/URL (tinyapps.it, tinyapps.itch.io).
- Email di contatto, ovunque serva: **my@tinyapps.it** (sempre questa, nessun'altra).
- Sito bilingue IT/EN: ogni testo visibile va aggiunto in entrambe le lingue nell'oggetto `window.T`
  della pagina (vedi sotto). Le informative privacy invece contengono entrambe le versioni nella stessa pagina.

## Struttura
Sito statico puro, nessun build step e nessuna dipendenza.
- `index.html` — homepage (chi siamo, supporto, giochi).
- `contact.html` — pagina contatti.
- `offcourse/privacy/index.html`, `scribble-racers/privacy/index.html` — informative privacy (usano `/style.css` con path assoluto).
- `style.css` — stile condiviso da tutte le pagine.
- `site.js` — i18n condivisa: ogni pagina definisce `window.T = { it: {...}, en: {...} }` e poi include `site.js`.
  Gli elementi usano `data-i18n="chiave"` (testo) o `data-i18n-html="chiave"` (HTML). La lingua scelta è salvata in `localStorage`.
- `img/` — immagini dei giochi in webp (prese dalle pagine itch.io e convertite con `cwebp`).
- `tmp/` — appunti/bozze locali, in `.gitignore`, non deployati.

## Deploy
- Azure Static Web App `swa-tinyapps` (resource group `rg-tinyapps`), dominio custom `www.tinyapps.it`.
- `.github/workflows/deploy-site.yml`: ogni push su `main` (esclusa `infra/**`) pubblica la root del repo.
- `.github/workflows/deploy-infra.yml` + `infra/` (Bicep): infrastruttura, vedi `infra/README.md`.

## Verifica locale
Le pagine privacy usano path assoluti, quindi serve un server HTTP:
`python3 -m http.server 8000` e apri `http://localhost:8000`.
