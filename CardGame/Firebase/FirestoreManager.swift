import Foundation
import FirebaseFirestore

class FirestoreManager {

    private let db = Firestore.firestore()
    private let usersCollection = "Users"
//    private let winnersCollection = "winners"
    
    // Singleton instance
    static let shared = FirestoreManager()
    
    private init() {}
    
    // Function to get user document by phone number
    func getUserByPhoneNumber(phoneNumber: String, completion: @escaping (Gamer?, Error?) -> Void) {
        db.collection(usersCollection).whereField("phoneNumber", isEqualTo: phoneNumber).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let document = querySnapshot?.documents.first else {
                completion(nil, nil) // No user found
                return
            }
            
            let data = document.data()
            let user = Gamer(dictionary: data)
            completion(user, nil)
        }
    }
    
    func getAllUsers(completion: @escaping ([Gamer]?, Error?) -> Void) {
        let db = Firestore.firestore()
        

        // Fetch all documents from the 'users' collection
        db.collection(usersCollection).getDocuments { (querySnapshot, error) in
            if let error = error {
                // If there's an error, return it in the completion handler
                completion(nil, error)
                return
            }
            
            // Initialize an empty array to hold the Gamer objects
            var users: [Gamer] = []
            
            // Iterate through the documents in the snapshot
            for document in querySnapshot!.documents {
                // Convert each document's data into a dictionary
                let data = document.data()
                
                // Try to create a Gamer object from the dictionary
                if let user = Gamer(dictionary: data) {
                    users.append(user)
                }
            }
            
            // Return the array of users
            completion(users, nil)
        }
    }
    
    // Function to create a new user in the Users collection
    func createUser(appUser: Gamer, completion: @escaping (Error?) -> Void) {
        let data = appUser.toDictionary()
        db.collection(usersCollection).document(appUser.phoneNumber!).setData(data) { error in
            completion(error)
        }
    }
    
    func updateFields(forDocumentId documentId: String, fieldsToUpdate: [String: Any]) {
        // Get a reference to the Firestore database
        let db = Firestore.firestore()
        
        // Reference to the specific document you want to update
        let documentRef = db.collection(usersCollection).document(documentId)
        
        // Update the specified fields
        documentRef.updateData(fieldsToUpdate) { error in
            if let error = error {
                // Handle the error here
                print("Error updating document: \(error.localizedDescription)")
            } else {
                // Document successfully updated
                print("Document successfully updated")
            }
        }
    }
}
