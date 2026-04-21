//
//  FirebaseManager.swift
//  MyFirstCloud
//

import FirebaseFirestore

/// Hanterar alla anrop mot Firestore. Fyll i enligt README (async/await).
final class FirebaseManager {
    private let db = Firestore.firestore()

    // TODO: Lägg till en `private let db`-property som pekar på Firestore.
    // Rekommendation: `private let db = Firestore.firestore()` — se README ("Var ska db ligga?").

    /// Hämtar alla dokument i kollektionen `notes` och gör om dem till `CloudNote`.
    func fetchNotes() async -> [CloudNote] {
        // TODO: Hämta dokument asynkront från kollektionen "notes" (try await + getDocuments).
        // TODO: Bygg en [CloudNote] från resultatet (t.ex. data(as: CloudNote.self) per dokument).
        do {
            let snapshot = try await db.collection("notes").getDocuments()
            return snapshot.documents.compactMap { document in
                    try? document.data(as: CloudNote.self)
            }
        } catch {
            print("Failed to fetch notes: \(error)")
            return []
        }
    }

    /// Sparar en ny anteckning som ett nytt dokument i kollektionen `notes`.
    func saveNote(text: String) async {
        do {
            try await db.collection("notes").addDocument(data: [
                "text": text
            ])
        } catch {
            print("Failed to save note: \(error)")
        }
        // TODO: Lägg till ett nytt dokument asynkront med addDocument — data: ["text": text].
        // Använd samma `db`-property som i fetchNotes (ingen ny `let db` i varje funktion).
    }
}
