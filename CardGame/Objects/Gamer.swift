
struct Gamer {
    var fullName: String
    var gameScore: Int = 0
    var phoneNumber: String?
    var winnerStats: Winner?
    
    init(fullName: String) {
        self.fullName = fullName
    }
    
    init(fullName: String, phoneNumber: String) {
        self.fullName = fullName
        self.phoneNumber = phoneNumber
    }
    
    init(fullName: String, phoneNumber: String, winnerStats: Winner?) {
        self.fullName = fullName
        self.phoneNumber = phoneNumber
        self.winnerStats = winnerStats
    }
    
    init?(dictionary: [String: Any]) {
        guard let fullName = dictionary["fullName"] as? String,
              let phoneNumber = dictionary["phoneNumber"] as? String else {
            return nil
        }
        
        self.fullName = fullName
        self.phoneNumber = phoneNumber
        
        if let winnerDict = dictionary["winnerStats"] as? [String: Any] {
            self.winnerStats = Winner(
                numberOfWins: winnerDict["numberOfWins"] as? Int ?? 0,
                numberOfLoses: winnerDict["numberOfLoses"] as? Int ?? 0,
                sumOfWinPoints: winnerDict["sumOfWinPoints"] as? Int ?? 0
            )
        }
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "fullName": fullName,
            "phoneNumber": phoneNumber as Any
        ]
        
        if let winnerStats = winnerStats {
            dict["winnerStats"] = winnerStats.toDictionary()
        }
        
        return dict
    }
}

