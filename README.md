# MyFirstCloud

**SwiftUI · Cloud Firestore · Firebase**

Pedagogiskt startprojekt: du kopplar en enkel anteckningslista till molnet. Förkunskaper: `@State`, `List` och navigation. Här introduceras **async/await**, **nätverksanrop** och **Firebase** stegvis.

---

## Innehåll

1. **Inlämningsuppgift** — vad du ska leverera  
2. **Del A** — Firebase-projekt i konsolen  
3. **Del B** — iOS-app och `GoogleService-Info.plist`  
4. **Del C** — Firebase SDK via Swift Package Manager  
5. **Del D** — Cloud Firestore och Test Mode  
6. **Kod att fylla i** — TODO i `FirebaseManager.swift`  
7. **Felsökning** — vanliga problem  
8. **Git och GitHub** — version och inlämning  

---

## Inlämningsuppgift

Gör i denna ordning:

1. **Konfigurera Firebase** enligt avsnitten A–D nedan (projekt, iOS-app, `GoogleService-Info.plist`, SDK, Firestore, regler).
2. **Implementera** alla TODO-rader i `FirebaseManager.swift` så att anteckningar hämtas och sparas mot kollektionen `notes`.
3. **Verifiera** att appen kör i simulator eller på enhet: du ska kunna skriva text, spara och se den i listan.
4. **Registrera ditt namn** i databasen så att läraren kan koppla inlämningen till dig (t.ex. ett dokument i `notes` med text som `Namn: Förnamn Efternamn`, om inget annat anges i kursen).
5. **Publicera koden** genom att pusha till **GitHub** och lämna in enligt kursens rutin.

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
| 3 | Kryssa i **Copy items if needed** och att filen ingår i target **MyFirstCloud**. |
| 4 | Gå igenom resten av Firebase-guiden (CocoaPods-steg kan du hoppa över om du använder SPM i avsnitt C). |

**Kontroll:** `GoogleService-Info.plist` syns i projektnavigatorn och är kopplad till target. Utan den filen kan Firebase inte starta korrekt.

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

**Data i appen:** koden använder kollektionen **`notes`**. Dokument ska kunna avkodas till fältet **`text`** (sträng). När `fetchNotes` och `saveNote` är implementerade skapas och läses dokument automatiskt.

---

## Kod att fylla i

Öppna **`FirebaseManager.swift`** och slutför logiken:

| TODO | Uppgift |
|------|---------|
| **1** | `let db = Firestore.firestore()` |
| **2** | `let snapshot = try? await db.collection("notes").getDocuments()` |
| Efter 2 | Bygg returvärdet `[CloudNote]` från `snapshot` (t.ex. gå igenom `snapshot.documents` och använd `data(as: CloudNote.self)`). |
| **3** (i `saveNote`) | Innan du anropar `db` måste `db` finnas (samma som i TODO 1). Sedan: `try? await db.collection("notes").addDocument(data: ["text": text])` |

**Tips:** Efter ändringar, kör appen och öppna **Firestore → Data** i konsolen för att se att dokument dyker upp.

---

## Felsökning

| Symtom | Åtgärd |
|--------|--------|
| Fel vid `import Firebase…` | Kontrollera att SPM-paketet är tillagt och att **FirebaseCore** och **FirebaseFirestore** är kopplade till rätt target. |
| Krasch vid start | Finns `GoogleService-Info.plist` i projektet och i target? Stämmer **Bundle ID** med Firebase? |
| Listan är tom / inget sparas | Är både hämtning och sparning implementerade? Heter kollektionen `notes`? |
| *Permission denied* i logg eller konsol | Är reglerna fortfarande i testläge? Har utgångsdatumet i reglerna passerats? |

---

## Git och GitHub

1. Initiera repo lokalt om det saknas: `git init`
2. Använd kursens **`.gitignore`** (t.ex. `xcuserdata/`, byggmappar) om det rekommenderas.
3. **`GoogleService-Info.plist`:** innehåller projektidentifierare. Vissa kurser vill att du committar filen för enkel rättning; andra förbjuder det i publika repo. **Följ lärarens beslut.**

Lycka till.
