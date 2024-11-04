

![Screenshot 2024-11-04 at 16 32 27](https://github.com/user-attachments/assets/d4bd1cc7-1ddb-41bd-b5f3-140898a270cc)


# Green Leaf 🌿
*Geschenk der Augenblicke*

Green Leaf ist eine App für Fotografie-Enthusiasten, die kostenlose, hochqualitative HD-Fotos erkunden und ihre eigenen Bilder mit einer Community teilen möchten.

**Für wen ist sie geeignet?**

Für alle, die sich für Fotografie interessieren und eine Plattform suchen, um inspirierende Bilder zu entdecken und eigene Kreationen zu präsentieren.

**Welches Problem löst sie?**

Green Leaf bietet eine einfache Möglichkeit, HD-Fotos zu finden und zu teilen, ohne dass man sich um Bildlizenzen sorgen muss.

**Was macht deine App anders/besser als andere Apps?** 

Die App kombiniert die besten Aspekte bekannter Foto-Plattformen und bietet eine kreative Community, die zum Mitmachen inspiriert.

---
**Screenshots**

![tm](https://github.com/user-attachments/assets/9223695a-36de-430e-8624-7491b62561b5)

---


![sheetview](https://github.com/user-attachments/assets/79c99fa3-6255-4ada-aeb9-6743f39b91f2)

---
![f4](https://github.com/user-attachments/assets/86e54290-a62d-450f-858e-ac7ec78a4e6f)
---
## Features

Hier sind alle Features, die Green Leaf App bietet:

- [x] **Home-Ansicht**: Durchstöbere atemberaubende Fotos, die direkt von der Unsplash API geladen werden. Markiere deine Lieblingsbilder mit einem „Like“ und entdecke täglich neue Inhalte.
- [x] **Explore-Ansicht mit Filteroption**: Die Explore-Ansicht wurde um eine Filterfunktion erweitert, mit der Nutzer schnell auf ihre eigenen hochgeladenen Fotos zugreifen können.
- [x] **Trend-Ansicht**: Entdecke die beliebtesten Fotos basierend auf Likes und filtere sie nach Kategorien wie `Tiere`, `Autos`, `Natur` und mehr.
- [x] **Erstellen-Ansicht**: Lade deine eigenen Fotos hoch, die in deinem Profil sowie in der allgemeinen Home-Ansicht angezeigt werden.
- [x] **Favorite-Ansicht**: Speichere die Bilder, die dir gefallen, und finde sie später in der Favoriten-Ansicht wieder.
- [x] **Profil-Ansicht**: Verwalte deine hochgeladenen Fotos und folge anderen Nutzern, um ihre Bilder in deiner Timeline zu sehen.
- [x] **Suche-Funktion**: Nutze die Suche, um schnell und einfach bestimmte Fotos oder Kategorien zu finden.
- [x] **Authentifizierung**: Sichere Anmeldung mit der Möglichkeit, ein neues Konto zu erstellen und die eigene Privatsphäre zu schützen.
- [ ] Die Gastmodus-Funktion ist in Entwicklung und wird bald mit spannenden neuen Features veröffentlicht
-----------
## Technischer Aufbau
Projektaufbau
Die App verwendet das MVVM-Architektur-Pattern in Kombination mit Repository- und Manager-Klassen, um eine klare Trennung zwischen Daten, Logik und UI zu gewährleisten. Dieser Aufbau erleichtert die Wartung und Erweiterung des Projekts. Die Struktur umfasst Ordner für ViewModels, Views, Models, sowie Repositories und Manager, um eine saubere Organisation und effiziente Datenverwaltung sicherzustellen.
-------
Datenspeicherung
Für die Datenspeicherung und Authentifizierung setzt die App auf Firebase Firestore. Die Benutzerfotos werden in Firebase Storage abgelegt, um eine geräteübergreifende Synchronisation und Datensicherung zu ermöglichen. Die Integration der Unsplash API erlaubt den Zugriff auf eine große Auswahl an hochwertigen Bildern, die in der App-Ansicht angezeigt werden.
----------
3rd-Party Frameworks
Firebase: Eingesetzt für Authentifizierung, Datenbank (Firestore), und Datenspeicherung (Storage).
Unsplash API: Für den Zugriff auf hochqualitative Fotos, die den Nutzern zur Verfügung stehen.
---
## Ausblick

In der Zukunft plane ich, Green Leaf weiterzuentwickeln und um spannende neue Funktionen zu erweitern, die das Benutzererlebnis verbessern und die Interaktivität erhöhen. Geplante Ergänzungen umfassen:
- [ ] Erweiterte Social Features: Kommentare und Interaktionen zwischen Nutzern.
- [ ] Statistiken: Anzeigen von Likes und Followern eines Nutzers.
- [ ] In-App-Käufe: Zugriff auf zusätzliche Fotofilter und Inhalte.
- [ ] Core Image Integration: Bildbearbeitungstools direkt in der App.


