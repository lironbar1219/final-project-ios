

import Foundation


class LocalStorage {
    private static let gamerName = "gamerName"
    
    static func saveGamerName(_ name: String?) {
        UserDefaults.standard.set(name, forKey: gamerName)
    }
    
    static func getGamerName() -> String? {
        return UserDefaults.standard.string(forKey: gamerName)
    }
    
    static func clearGamerName() {
        UserDefaults.standard.removeObject(forKey: gamerName)
    }
    
    static func setFirebaseAuthenticationValue(key:String) {
        return UserDefaults.standard.set(key, forKey: AppConstants.firebase_authentication)
    }
    
    static func getFirebaseAuthenticationValue() ->String?{
        return UserDefaults.standard.string(forKey: AppConstants.firebase_authentication)
    }
}
