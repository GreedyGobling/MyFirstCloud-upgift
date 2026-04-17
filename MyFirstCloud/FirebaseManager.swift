//
//  FirebaseManager.swift
//  MyFirstCloud
//

import FirebaseFirestore

/// Hanterar alla anrop mot Firestore. Fyll i enligt README (async/await).
final class FirebaseManager {

    // TODO: Lägg till en `private let db`-property som pekar på Firestore.
    // Rekommendation: `private let db = Firestore.firestore()` — se README ("Var ska db ligga?").

    /// Hämtar alla dokument i kollektionen `notes` och gör om dem till `CloudNote`.
    func fetchNotes() async -> [CloudNote] {
        // TODO: Hämta dokument asynkront från kollektionen "notes" (try await + getDocuments).
        // TODO: Bygg en [CloudNote] från resultatet (t.ex. data(as: CloudNote.self) per dokument).

        return []
    }

    /// Sparar en ny anteckning som ett nytt dokument i kollektionen `notes`.
    func saveNote(text: String) async {
        // TODO: Lägg till ett nytt dokument asynkront med addDocument — data: ["text": text].
        // Använd samma `db`-property som i fetchNotes (ingen ny `let db` i varje funktion).
    }
}
