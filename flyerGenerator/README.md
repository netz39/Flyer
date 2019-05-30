Python-script für Netz39 e.V. Flyer und Poster
===============================================

* liest den ical-feed von netz39.de/events
* befüllt ein jinja2 template, basierend auf ../LatexTemplate
* generiert .pdfs für Flyer und Poster
* verschiebt pdfs in 'out'-Ordner
* löscht .aux, .log etc.

Standardwerte:
* ab 1. des aktuellen Monats
* für die nächsten 2 Monate