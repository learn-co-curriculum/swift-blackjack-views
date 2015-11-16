//  PlayerSpec.swift

import Quick
import Nimble
@testable import swift_blackjack_views

class PlayerSpec: QuickSpec {
    override func spec() {
        describe("Player") {
            
            var player = Player(name: "Player")
            
            let aceOfSpades : Card = Card(suit: "♠︎", rank: "A")
            let aceOfHearts : Card = Card(suit: "♥︎", rank: "A")
            let queenOfHearts : Card = Card(suit: "♥︎", rank: "Q")
            let tenOfDiamonds : Card = Card(suit: "♦︎", rank: "10")
            let twoOfClubs : Card = Card(suit: "♣︎", rank: "2")

            beforeEach {
                player = Player(name: "Player")
            }
            
            describe("initializer") {
                it("sets the name property") {
                    expect(player.name).to(match("Player"))
                }
            }
            
            
            describe("description") {
                it("returns a readout of the Player instance") {
                    let description = player.description
                    
                    expect(description.lowercaseString).to(contain("player"))
                    expect(description.lowercaseString).to(contain("cards"))
                    expect(description.lowercaseString).to(contain("handscore"))
                    expect(description.lowercaseString).to(contain("blackjack"))
                    expect(description.lowercaseString).to(contain("busted"))
                    expect(description.lowercaseString).to(contain("stayed"))
                    expect(description.lowercaseString).to(contain("tokens"))
                }
            }
            
            describe("cards property array") {
                it("can accept a Card object") {
                    player.cards.append(aceOfSpades)
                    
                    expect(player.cards.count).to(equal(1))
                }
            }
            
            describe("handscore property") {
                it("returns 0 when the cards array is empty") {
                    expect(player.handscore).to(equal(0))
                }
                
                it("returns 20 with a queen and a ten in the cards array") {
                    player.cards.append(queenOfHearts)
                    player.cards.append(tenOfDiamonds)
                    
                    expect(player.handscore).to(equal(20))
                }
                
                it("returns 21 with a queen and an ace in the cards array") {
                    player.cards.append(queenOfHearts)
                    player.cards.append(aceOfSpades)
                    
                    expect(player.handscore).to(equal(21))
                }
                
                it("returns 21 with a queen, a ten, and an ace in the cards array") {
                    player.cards.append(queenOfHearts)
                    player.cards.append(tenOfDiamonds)
                    player.cards.append(aceOfSpades)

                    expect(player.handscore).to(equal(21))
                }
                
                it("returns 12 with a queen and two aces in the cards array") {
                    player.cards.append(queenOfHearts)
                    player.cards.append(aceOfSpades)
                    player.cards.append(aceOfHearts)
                    
                    expect(player.handscore).to(equal(12))
                }
                
                it("returns 22 with a queen, a ten, and a two in the cards array") {
                    player.cards.append(queenOfHearts)
                    player.cards.append(tenOfDiamonds)
                    player.cards.append(twoOfClubs)

                    expect(player.handscore).to(equal(22))
                }
            }

            describe("blackjack property") {
                it("returns false when the cards array is empty") {
                    expect(player.blackjack).to(beFalse())
                }
                
                it("returns false with a queen and a ten in the cards array") {
                    player.cards.append(queenOfHearts)
                    player.cards.append(tenOfDiamonds)
                    
                    expect(player.blackjack).to(beFalse())
                }
                
                it("returns true with a queen and an ace in the cards array") {
                    player.cards.append(queenOfHearts)
                    player.cards.append(aceOfSpades)
                    
                    expect(player.blackjack).to(beTrue())
                }
                
                it("returns false with a queen, a ten, and an ace in the cards array") {
                    player.cards.append(queenOfHearts)
                    player.cards.append(tenOfDiamonds)
                    player.cards.append(aceOfSpades)
                    
                    expect(player.blackjack).to(beFalse())
                }
                
                it("returns false with a queen, a ten, and a two in the cards array") {
                    player.cards.append(queenOfHearts)
                    player.cards.append(tenOfDiamonds)
                    player.cards.append(twoOfClubs)
                    
                    expect(player.blackjack).to(beFalse())
                }
            }

            describe("busted property") {
                it("returns false when the cards array is empty") {
                    expect(player.busted).to(beFalse())
                }
                
                it("returns false with a queen and a ten in the cards array") {
                    player.cards.append(queenOfHearts)
                    player.cards.append(tenOfDiamonds)
                    
                    expect(player.busted).to(beFalse())
                }
                
                it("returns false with a queen and an ace in the cards array") {
                    player.cards.append(queenOfHearts)
                    player.cards.append(aceOfSpades)
                    
                    expect(player.busted).to(beFalse())
                }
                
                it("returns false with a queen, a ten, and an ace in the cards array") {
                    player.cards.append(queenOfHearts)
                    player.cards.append(tenOfDiamonds)
                    player.cards.append(aceOfSpades)
                    
                    expect(player.busted).to(beFalse())
                }
                
                it("returns false with a queen and two aces in the cards array") {
                    player.cards.append(queenOfHearts)
                    player.cards.append(aceOfSpades)
                    player.cards.append(aceOfHearts)
                    
                    expect(player.busted).to(beFalse())
                }
                
                it("returns true with a queen, a ten, and a two in the cards array") {
                    player.cards.append(queenOfHearts)
                    player.cards.append(tenOfDiamonds)
                    player.cards.append(twoOfClubs)
                    
                    expect(player.busted).to(beTrue())
                }
            }
            
            describe("stayed property") {
                it("is initialized to false") {
                    expect(player.stayed).to(beFalse())
                }
            }

            describe("mayHit property") {
                it("returns true when the cards array is empty") {
                    expect(player.mayHit).to(beTrue())
                }
                
                it("returns true with a queen and a ten in the cards array") {
                    player.cards.append(queenOfHearts)
                    player.cards.append(tenOfDiamonds)
                    
                    expect(player.mayHit).to(beTrue())
                }
                
                it("returns false with a queen and an ace in the cards array") {
                    player.cards.append(queenOfHearts)
                    player.cards.append(aceOfSpades)
                    
                    expect(player.mayHit).to(beFalse())
                }
                
                it("returns true with a queen and two aces in the cards array") {
                    player.cards.append(queenOfHearts)
                    player.cards.append(aceOfSpades)
                    player.cards.append(aceOfHearts)
                    
                    expect(player.mayHit).to(beTrue())
                }
                
                it("returns false with a queen, a ten, and a two in the cards array") {
                    player.cards.append(queenOfHearts)
                    player.cards.append(tenOfDiamonds)
                    player.cards.append(twoOfClubs)
                    
                    expect(player.mayHit).to(beFalse())
                }
            }
            
            describe("tokens property") {
                it("is initialized to 100") {
                    expect(player.tokens).to(equal(100))
                }
            }

            describe("canPlaceBet") {
                it("returns true if the tokens is equal to or greater than the bet") {
                    expect(player.canPlaceBet(10)).to(beTrue())
                    expect(player.canPlaceBet(100)).to(beTrue())
                }
                
                it("returns false if the tokens is less than the bet") {
                    expect(player.canPlaceBet(101)).to(beFalse())
                }
            }
            
            describe("didWin") {
                it("should add 10 to the tokens when the bet is 10") {
                    let tokens = player.tokens
                    let bet: UInt = 10
                    player.didWin(bet)
                    
                    expect(player.tokens).to(equal(tokens + bet))
                }
                
                it("should add 20 to the tokens when the bet is 20") {
                    let tokens = player.tokens
                    let bet: UInt = 20
                    player.didWin(bet)
                    
                    expect(player.tokens).to(equal(tokens + bet))
                }
            }
            
            describe("didLose") {
                it("should subtract 10 from the tokens when the bet is 10") {
                    let tokens = player.tokens
                    let bet: UInt = 10
                    player.didLose(bet)
                    
                    expect(player.tokens).to(equal(tokens - bet))
                }
                
                it("should subract 20 from the tokens when the bet is 20") {
                    let tokens = player.tokens
                    let bet: UInt = 20
                    player.didLose(bet)
                    
                    expect(player.tokens).to(equal(tokens - bet))
                }
            }
            
            /*
            describe("didPush") {
                it("does not affect the tokens") {
                    let tokens = player.tokens
                    player.didPush()
                    
                    expect(player.tokens).to(equal(tokens))
                }
            } */
        }
    }
}

