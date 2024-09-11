import Foundation

struct Winner {
    var numberOfWins: Int
    var numberOfLoses: Int
    var sumOfWinPoints: Int
    
    init(numberOfWins: Int = 0, numberOfLoses: Int = 0, sumOfWinPoints: Int = 0) {
        self.numberOfWins = numberOfWins
        self.numberOfLoses = numberOfLoses
        self.sumOfWinPoints = sumOfWinPoints
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "numberOfWins": numberOfWins,
            "numberOfLoses": numberOfLoses,
            "sumOfWinPoints": sumOfWinPoints
        ]
    }
}
