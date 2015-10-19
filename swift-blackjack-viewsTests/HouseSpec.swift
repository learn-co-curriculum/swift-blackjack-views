//  HouseSpec.swift

import Quick
import Nimble
@testable import swift_blackjack_views

class HouseSpec: QuickSpec {
    override func spec() {
        describe("House") {
            
            var house = House(name: "House")
            
            let queenOfHearts = Card(suit: "♥︎", rank: "Q")
            let sixOfClubs = Card(suit: "♣︎", rank: "6")
            let sevenOfClubs = Card(suit: "♣︎", rank: "7")
            
            beforeEach({ () -> () in
                house = House(name: "House")
            })
            
            describe("initializer") {
                it("takes an argument for the name property") {
                    expect(house.name).to(match("House"))
                }
                
                it("overrides the super class's default value for tokens") {
                    expect(house.tokens).to(equal(1000))
                }
            }
            
            describe("mustHit") {
                it("should return true if the handscore is 16") {
                    house.cards.append(queenOfHearts)
                    house.cards.append(sixOfClubs)
                    
                    expect(house.handscore).to(equal(16))
                    expect(house.mustHit).to(beTrue())
                }
                
                it("should return false if the handscore is 17") {
                    house.cards.append(queenOfHearts)
                    house.cards.append(sevenOfClubs)
                    
                    expect(house.handscore).to(equal(17))
                    expect(house.mustHit).to(beFalse())
                }
            }
        }
    }
}

