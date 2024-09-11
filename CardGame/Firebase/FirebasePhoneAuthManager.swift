import Foundation
import FirebaseAuth

class FirebasePhoneAuthManager {

    static let shared = FirebasePhoneAuthManager()
    
    private init() {}
    
    /// Request verification code for the provided phone number.
    /// - Parameters:
    ///   - phoneNumber: The phone number to verify.
    ///   - completion: A completion handler with an optional error.
//    func requestVerificationCode(phoneNumber: String, completion: @escaping (Error?) -> Void) {
//        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
//            if let error = error {
//                completion(error)
//                return
//            }
//            if let verificationID = verificationID {
//                LocalStorage.setFirebaseAuthenticationValue(key: verificationID)
//                
//                completion(nil)
//            }
//        }
//    }
    
    
    func requestVerificationCode(phoneNumber: String, completion: @escaping (Error?) -> Void) {

        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error {
                completion(error)
                return
            }
            guard let verificationID = verificationID else {
                completion(NSError(domain: "FirebasePhoneAuthManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to obtain verification ID"]))
                return
            }
            LocalStorage.setFirebaseAuthenticationValue(key: verificationID)
            
            completion(nil)
        }
    }
    
    /// Sign in using the verification code.
    /// - Parameters:
    ///   - verificationCode: The verification code sent to the user's phone.
    ///   - completion: A completion handler with an optional error and an optional user object.
    func signInWithVerificationCode(verificationCode: String, completion: @escaping (User?, Error?) -> Void) {
        guard let verificationID = LocalStorage.getFirebaseAuthenticationValue() else {
            completion(nil, NSError(domain: "FirebasePhoneAuthManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "No verification ID found"]))
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )
        
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                completion(nil, error)
                return
            }
            if let user = authResult?.user {
                completion(user, nil)
            }
        }
    }
    
    /// Check if the user is already signed in.
    /// - Returns: The current authenticated user, if available.
    func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    /// Sign out the current authenticated user.
    /// - Throws: An error if sign out fails.
    func signOut() throws {
        try Auth.auth().signOut()
        
    }
}
