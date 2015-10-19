//  Dealer.swift

import Foundation

class Dealer {
    let deck = Deck()
    let house = House(name: "House")
    let player = House(name: "Player")
    var bet: UInt = 0
    
    func placeBet(bet: UInt) -> Bool {
        if house.canPlaceBet(bet) && player.canPlaceBet(bet) {
            self.bet = bet
            return true
        } else {
            self.bet = 0
            return false
        }
    }
        
    func deal() {
        deck.shuffle()
        player.cards.removeAll()
        house.cards.removeAll()
        player.stayed = false
        house.stayed = false
        
        for var i = 0; i < 2; i++ {
            player.cards.append(deck.drawCard())
            house.cards.append(deck.drawCard())
        }
    }
    
    func turn(house: House) {
        if house.mayHit {
            print("\(house.name)'s turn:")
            if house.mustHit {
                house.cards.append(deck.drawCard())
                print("\(house.name) hits!")
                print(house)
            } else {
                house.stayed = true
                print("\(house.name) stays!")
            }
        }
    }
    
    func winner() -> String {
        /* advanced
        if player.blackjack && house.blackjack {
            return "push"
        } */
        if player.blackjack && !house.blackjack {
            return "player"
        }
        if !player.blackjack && house.blackjack {
            return "house"
        }
        if player.busted {
            return "house"
        }
        if house.busted {
            return "player"
        }
        if player.cards.count == 5 && !player.busted {
            return "player"
        }
        if house.stayed && player.stayed {
            if player.handscore > house.handscore {
                return "player"
            } else {
                return "house"
            }
        }
        return "no"
    }
    
    func award() -> String {
        let winner = self.winner()
        switch winner {
            /* advanced
            case "push":
                house.didPush()
                player.didPush()
                return "Push!"
            */
            case "house":
                house.didWin(bet)
                player.didLose(bet)
                return "House wins \(bet)!"
            case "player":
                house.didLose(bet)
                player.didWin(bet)
                return "Player wins \(bet)!"
            case "no":
                return "There is not a winner yet."
            default:
                return "ERROR award: \(winner)"
        }
    }
}

