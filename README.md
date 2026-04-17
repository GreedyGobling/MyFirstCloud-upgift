# MyFirstCloud

**SwiftUI · Cloud Firestore · Firebase**

Pedagogiskt startprojekt: du kopplar en enkel anteckningslista till molnet. Förkunskaper: `@State`, `List` och navigation. Här jobbar du med **async/await** (modernt Swift), **nätverksanrop mot Firestore** och **Firebase** — utan gamla callback-mönster.

---

## Innehåll

0. **Steg 0** — ladda ner och öppna projektet  
1. **Inlämningsuppgift** — vad du ska leverera  
2. **Del A** — Firebase-projekt i konsolen  
3. **Del B** — iOS-app och `GoogleService-Info.plist`  
4. **Del C** — Firebase SDK via Swift Package Manager  
5. **Del D** — Cloud Firestore och Test Mode  
6. **Async/await** — så här tänker du i labben  
7. **Kod** — `FirebaseManager` och TODO:er  
8. **Felsökning** — vanliga fel och lösningar  
9. **Git** — version och inlämning  

---

## 📥 Steg 0 — Kom igång

**Mål:** Ha projektet på din dator och öppna det i Xcode på rätt sätt.

### Alternativ A: `git clone` (rekommenderas om du använder Git)

1. Kopiera repo-URL:en från GitHub (grön knapp **Code** → HTTPS, t.ex. `https://github.com/konto/MyFirstCloud.git`).
2. Öppna **Terminal** och gå till mappen där du vill ha projektet, t.ex.  
   `cd ~/Developer`
3. Kör (byt ut URL mot er kurs/lärares repo):  
   `git clone https://github.com/konto/MyFirstCloud.git`
4. Gå in i mappen:  
   `cd MyFirstCloud`

**Kontroll:** Du ska se filen `MyFirstCloud.xcodeproj` i projektets rotmapp (bredvid mappen `MyFirstCloud` med källkoden).

### Alternativ B: Ladda ner som ZIP

1. På GitHub: **Code** → **Download ZIP**.
2. Dubbelklicka på zip-filen i Finder så att en mapp packas upp.
3. Flytta mappen dit du brukar spara projekt (t.ex. `Developer`).

**Kontroll:** Samma som ovan — `MyFirstCloud.xcodeproj` ska ligga i rotmappen.

### Öppna i Xcode

1. Dubbelklicka på **`MyFirstCloud.xcodeproj`** (inte en slumpmässig undermapp).  
   Du ska **inte** öppna enstaka `.swift`-filer först — Xcode behöver projektfilen för att bygga appen.
2. Vänta tills Xcode indexerat projektet (statusraden längst upp).
3. Välj simulator (t.ex. **iPhone 16**) och tryck **Run** (▶). Innan Firebase är konfigurerat kan bygget eller körningen varna eller krascha — det är förväntat tills du följer stegen nedan.

> **Tips:** Om du ser två nivåer av mappar efter ZIP (`MyFirstCloud-main/MyFirstCloud.xcodeproj`), öppna `.xcodeproj` i den **inre** mappen som faktiskt innehåller Xcode-projektet.

---

## Inlämningsuppgift

Gör i denna ordning:

1. **Konfigurera Firebase** enligt Del A–D (projekt, iOS-app, `GoogleService-Info.plist`, SDK, Firestore, regler).
2. **Implementera** logiken i `FirebaseManager.swift` enligt avsnittet *Kod att fylla i* (async-funktionerna `fetchNotes` och `saveNote`).
3. **Verifiera** att appen kör: du ska kunna skriva text, spara och se den i listan.
4. **Registrera ditt namn** i databasen så att läraren kan koppla inlämningen till dig (t.ex. ett dokument i `notes` med text som `Namn: Förnamn Efternamn`, om inget annat anges i kursen).
5. **Publicera** genom att pusha till **GitHub** och lämna in enligt kursens rutin.

> **Testläge är tillfälligt öppet**  
> Firestore *Test Mode* tillåter läs/skriv utan inloggning under en begränsad tid. Använd **endast i utbildning**. I produktion krävs autentisering och strikta säkerhetsregler.

---

## Del A — Firebase-projekt

**Mål:** Ett tomt Firebase-projekt som du sedan kopplar till din iOS-app.

| Steg | Gör så här |
|------|------------|
| 1 | Öppna [Firebase Console](https://console.firebase.google.com/) och logga in. |
| 2 | Välj **Add project** / **Lägg till projekt**. |
| 3 | Ange ett **projektnamn** (t.ex. `MyFirstCloud-DittNamn`). |
| 4 | **Google Analytics** kan du stänga av för detta labb om du vill förenkla; det krävs inte för Firestore-grunderna. |
| 5 | Bekräfta med **Create project** / **Skapa projekt** och vänta tills guiden är klar. |

**Kontroll:** Du ser projektets översikt (**Project Overview**).

---

## Del B — iOS-app och `GoogleService-Info.plist`

**Mål:** Registrera appen i Firebase och lägga konfigurationsfilen i Xcode.

### Registrera iOS-appen

| Steg | Gör så här |
|------|------------|
| 1 | På projektets startsida: **Add app** eller ikonen **iOS+**. |
| 2 | Välj plattform **iOS**. |
| 3 | **Bundle ID** måste vara **identisk** med Xcode: projekt **MyFirstCloud** → target **MyFirstCloud** → **General** → kopiera **Bundle Identifier** (t.ex. `com.dittnamn.MyFirstCloud`) och klistra in i Firebase. |
| 4 | **App nickname** och **App Store ID** kan lämnas tomma. |
| 5 | Välj **Register app** / **Registrera app**. |

### Lägg till konfigurationsfilen

| Steg | Gör så här |
|------|------------|
| 1 | Ladda ner **`GoogleService-Info.plist`** från guiden. |
| 2 | I Finder: dra filen in i Xcode-gruppen **MyFirstCloud** (bredvid `ContentView.swift`). |
| 3 | Kryssa i **Copy items if needed** och att filen ingår i target **MyFirstCloud** (se *Felsökning* om något går fel). |
| 4 | Gå igenom resten av Firebase-guiden (CocoaPods-steg kan du hoppa över om du använder SPM i Del C). |

**Kontroll:** `GoogleService-Info.plist` syns i projektnavigatorn och är kopplad till target. Utan den filen startar inte Firebase korrekt.

---

## Del C — Firebase SDK (Swift Package Manager)

**Mål:** Länka **FirebaseCore** och **FirebaseFirestore** till appen.

Detta repo kan redan ha paketen ifyllda. Om du sätter upp projektet från scratch:

| Steg | Gör så här |
|------|------------|
| 1 | Öppna `MyFirstCloud.xcodeproj`. |
| 2 | **File** → **Add Package Dependencies…** (eller **Add Packages…**). |
| 3 | Klistra in URL: `https://github.com/firebase/firebase-ios-sdk` |
| 4 | Regel: t.ex. **Up to Next Major Version**, lägsta `11.0.0` eller nyare. |
| 5 | Välj **Add Package**. |
| 6 | Markera produkterna **FirebaseCore** och **FirebaseFirestore** och lägg dem till target **MyFirstCloud**. |

**Kontroll:** Projektet bygger och `import FirebaseCore` / `import FirebaseFirestore` ger inga fel.

---

## Del D — Cloud Firestore och Test Mode

**Mål:** En Firestore-databas med öppna regler under labben.

| Steg | Gör så här |
|------|------------|
| 1 | I Firebase Console: **Build** → **Firestore Database**. |
| 2 | **Create database** / **Skapa databas**. |
| 3 | Välj **Start in test mode** / **Starta i testläge**. |
| 4 | Välj **region** (nära dig); vissa val går inte att ändra senare. |
| 5 | Öppna fliken **Rules** / **Regler** och kontrollera att du har testläges-regler med ett utgångsdatum. |

Exempel på hur reglerna kan se ut (exakt datum och formulering kan skilja sig):

```text
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.time < timestamp.date(YYYY, MM, DD);
    }
  }
}
```

**Vad det innebär:** alla kan läsa och skriva tills datumet passerats. Använd bara för övning.

**Data i appen:** koden använder kollektionen **`notes`**. Dokument ska kunna avkodas till fältet **`text`** (sträng). När `fetchNotes` och `saveNote` är färdiga skapas och läses dokument automatiskt.

---

## Async/await i korthet

I den här labben använder du **asynkrona funktioner** — de marker med `async` och anropas med `await` där resultatet behövs:

- `func fetchNotes() async -> [CloudNote]` hämtar data utan att låsa UI-tråden.
- `func saveNote(text: String) async` skickar data till molnet på samma sätt.

Firestore:s Swift-API:er för att läsa/skriva i molnet är **async** (under huven väntar de på nätverket). Du ska **inte** bygga om samma logik med gamla completion handlers eller “puckar” här — håll dig till `async`/`await` som i mallen och i tabellen nedan.

I SwiftUI startar du asynkron kod från t.ex. en knapp med `Task { await ... }` eller från vyn med `.task { await ... }` (det finns redan i projektet).

---

## Kod att fylla i

### Var ska `db` ligga?

Använd **en** referens till Firestore som en **`private`-property** i `FirebaseManager`, t.ex.:

`private let db = Firestore.firestore()`

**Varför?**

- Alla funktioner i samma klass använder **samma** databasinstans.
- Du slipper skriva `let db = ...` om och om igen i varje funktion (mindre risk för misstag och otydlig scope).
- Det matchar hur du brukar strukturera tjänster i appar.

Lägg propertyn **överst i klassen** (efter öppningsklammern), innan `fetchNotes` och `saveNote`.

### Pedagogisk TODO-tabell

Öppna **`FirebaseManager.swift`**. Dina funktioner ska redan vara deklarerade som `async`. Fyll i kropparna utifrån målen nedan — **ledtrådarna** är till för att du ska hitta rätt API, inte som facit-rader att kopiera rakt av.

| Mål | Ledtråd |
|-----|---------|
| Hålla **en** delad Firestore-referens i klassen | Deklarera `private let db` och tilldela med `Firestore.firestore()`. |
| **Hämta** alla dokument i kollektionen `notes` asynkront | Använd `db.collection("notes")` och metoden som hämtar flera dokument på en gång. API:et är async — använd `try await` (och hantera fel med `try?` eller `do/catch` om du vill). |
| Gör om snapshot till **`[CloudNote]`** | Iterera över dokumenten du fick tillbaka. För varje dokument: avkoda till `CloudNote` med Firestore:s Codable-stöd (t.ex. `data(as: CloudNote.self)`). Filtrera bort misslyckade avkodningar om det behövs. |
| **Spara** en ny rad som eget dokument med fältet `text` | Använd `addDocument` (eller motsvarande) på samma `notes`-kollektion. Skicka in data som en dictionary med nyckeln `"text"`. Anropa asynkront med `await`. |

**Verifiering:** Bygg och kör. Öppna **Firestore → Data** i Firebase Console och kontrollera att dokument dyker upp när du sparar från appen.

---

## Felsökning

| Symtom | Vad du kan göra |
|--------|-----------------|
| **Missing eller hittar inte `GoogleService-Info.plist`** / Firebase klagar vid start | Kontrollera att filen **finns i projektet** (projektnavigatorn) och att den **ligger i rätt mål**: markera filen → **File Inspector** (höger panel) → **Target Membership** → bocka i **MyFirstCloud**. Utan bocken packas filen inte in i appen. Ladda ner filen igen från Firebase om du tappat bort den. |
| **`GoogleService-Info.plist` syns men Firebase fungerar inte** | Dubbelkolla **Bundle ID** i Xcode mot den du registrerade i Firebase. De måste vara **identiska**. |
| Byggfel på `import Firebase…` | Öppna projektet via **`.xcodeproj`**. Kontrollera under **Package Dependencies** att `firebase-ios-sdk` finns och att **FirebaseCore** + **FirebaseFirestore** är länkade till target **MyFirstCloud** (Del C). |
| **“Cannot find … in scope” för `db`** | Du har troligen glömt propertyn `private let db = …` i klassen, eller stavat fel. Se avsnittet *Var ska `db` ligga?* ovan. |
| Listan är tom / inget sparas | Har du implementerat **både** hämtning och sparning? Använder du `await` när du anropar Firestore? Heter kollektionen **`notes`**? |
| *Permission denied* i logg eller konsol | Testläges-regler? Har utgångsdatumet i Firestore-reglerna passerats? |
| Simulatorn hänger eller inget händer | Se till att du anropar `async`-funktioner med `await` från en `Task { }` eller en annan `async`-kontext (projektets `ContentView` gör detta redan åt dig). |

---

## Git och GitHub

1. Initiera repo lokalt om det saknas: `git init`
2. Använd kursens **`.gitignore`** (t.ex. `xcuserdata/`, byggmappar) om det rekommenderas.
3. **`GoogleService-Info.plist`:** innehåller projektidentifierare. Vissa kurser vill att du committar filen för enkel rättning; andra förbjuder det i publika repo. **Följ lärarens beslut.**

Du klarar det — ta ett steg i taget och återkom till *Felsökning* om något strular.
