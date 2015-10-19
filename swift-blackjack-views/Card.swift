//  Card.swift

import Foundation

class Card {
    let suit : String
    let rank : String
    private(set) var cardLabel = ""
    private(set) var cardValue: UInt = 0
    
    var description: String { return cardLabel }
    
    init(suit: String, rank: String) {
        self.suit = suit
        self.rank = rank
        self.cardLabel = "\(suit)\(rank)"
        self.cardValue = determineCardValue(rank)
    }
    
    class func validSuits() -> [String] {
        return ["♠︎", "♥︎", "♦︎", "♣︎"]
    }
    
    class func validRanks() -> [String] {
        return ["A", "2", "3" ,"4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
    }

    private func determineCardValue(rank: String) -> UInt {
        switch rank {
        case "A":
            return 1
        case "2", "3", "4", "5", "6", "7", "8", "9", "10":
            return UInt(rank)!
        case "J", "Q", "K":
            return 10
        default:
            return 0
        }
    }
}

func descriptionForCardArray(cardArray: [Card]) -> String {
    var description = "\(cardArray.count)"
    var count = 0
    for card in cardArray {
        if count % 13 == 0 {
            description += "\n   "
        }
        description += " \(card.description)"
        count++
    }
    return description
}

