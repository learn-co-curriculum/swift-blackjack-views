//  DealerSpec.swift

import Quick
import Nimble
@testable import swift_blackjack_views

class DealerSpec: QuickSpec {
    override func spec() {
        describe("Dealer") {
            
            var dealer = Dealer()
            
            beforeEach {
                dealer = Dealer()
            }
            
            describe("placeBet") {
                it("should return true if the house and player can afford a bet of 10") {
                    let bet : UInt = 10
                    
                    expect(dealer.placeBet(bet)).to(beTrue())
                }
                
                it("should set the dealer's bet property to 10 when the value of the bet parameter is 10") {
                    let bet : UInt = 10
                    dealer.placeBet(bet)
                    
                    expect(dealer.bet).to(equal(bet))
                }
                
                it("should set the dealer's bet property to 20 when the value of the bet parameter is 20") {
                    let bet : UInt = 20
                    dealer.placeBet(bet)
                    
                    expect(dealer.bet).to(equal(bet))
                }
                
                it("should return false if the bet exceeds the player's tokens") {
                    let bet = dealer.player.tokens + 1
                    
                    expect(dealer.placeBet(bet)).to(beFalse())
                }
                
                it("should return false if the bet exceeds the house's tokens") {
                    let bet = dealer.house.tokens + 1
                    
                    expect(dealer.placeBet(bet)).to(beFalse())
                }
            }
            
            describe("deal") {
                it("should set the house's and player's stayed bool to false") {
                    dealer.house.stayed = true
                    dealer.player.stayed = true
                    dealer.deal()
                    
                    expect(dealer.house.stayed).to(beFalse())
                    expect(dealer.player.stayed).to(beFalse())
                }
                
                it("should add two cards each to the house's and player's cards arrays") {
                    dealer.deal()
                    
                    expect(dealer.house.cards.count).to(equal(2))
                    expect(dealer.player.cards.count).to(equal(2))
                }
                
                it("should empty the cards in the house's and player's cards arrays before dealing new cards") {
                    dealer.deal()
                    dealer.deal()
                    
                    expect(dealer.house.cards.count).to(equal(2))
                    expect(dealer.player.cards.count).to(equal(2))
                }
                
                it("should shuffle the deck before dealing") {
                    dealer.deal()
                    
                    let card1 = dealer.deck.drawCard()
                    let card2 = dealer.deck.drawCard()
                    let card3 = dealer.deck.drawCard()
                    
                    if card1.cardLabel == "♣️K" && card2.cardLabel == "♣️Q" {
                        // this test has a 1 in 132,600 chance of randomly failing
                        expect(card3.cardLabel).toNot(match("♣️J"))
                    }
                    if card1.cardLabel == "♠️A" && card2.cardLabel == "♠️2" {
                        // this test has a 1 in 132,600 chance of randomly failing
                        expect(card3.cardLabel).toNot(match("♠️3"))
                    }
                }
            }
            
            let aceOfSpades : Card = Card(suit: "♠︎", rank: "A")
            let aceOfHearts : Card = Card(suit: "♥︎", rank: "A")
            let queenOfHearts : Card = Card(suit: "♥︎", rank: "Q")
            let tenOfDiamonds : Card = Card(suit: "♦︎", rank: "10")
            let twoOfClubs : Card = Card(suit: "♣︎", rank: "2")
            let sixOfClubs = Card(suit: "♣︎", rank: "6")
            let sevenOfClubs = Card(suit: "♣︎", rank: "7")

            describe("turn") {
                it("should not offer the house a card if the house has busted") {
                    dealer.house.cards.append(queenOfHearts)
                    dealer.house.cards.append(tenOfDiamonds)
                    dealer.house.cards.append(twoOfClubs)
                    dealer.turn(dealer.house)
                    
                    expect(dealer.house.busted).to(beTrue())
                    expect(dealer.house.cards.count).to(equal(3))
                }
                
                it("should not offer the house a card if the house has stayed") {
                    dealer.house.stayed = true
                    dealer.turn(dealer.house)
                    
                    expect(dealer.house.cards.count).to(equal(0))
                }
                
                it("should not offer the house a card if the house has a blackjack") {
                    dealer.house.cards.append(queenOfHearts)
                    dealer.house.cards.append(aceOfSpades)
                    dealer.turn(dealer.house)
                    
                    expect(dealer.house.blackjack).to(beTrue())
                    expect(dealer.house.cards.count).to(equal(2))
                }
                
                it("should not give the house a card if the house must stay") {
                    dealer.house.cards.append(tenOfDiamonds)
                    dealer.house.cards.append(sevenOfClubs)
                    dealer.turn(dealer.house)
                    
                    expect(dealer.house.cards.count).to(equal(2))
                }
                
                it("should give the house a card if the house must hit") {
                    dealer.house.cards.append(tenOfDiamonds)
                    dealer.house.cards.append(sixOfClubs)
                    dealer.turn(dealer.house)
                    
                    expect(dealer.house.cards.count).to(equal(3))
                }
            }
            
            describe("winner") {
                /* advanced
                it("should return 'push' if the house and player both have blackjacks") {
                    dealer.house.cards.append(aceOfSpades)
                    dealer.house.cards.append(tenOfDiamonds)
                    dealer.player.cards.append(aceOfHearts)
                    dealer.player.cards.append(queenOfHearts)
                    
                    expect(dealer.winner()).to(match("push"))
                } 
                */
                
                it("should return 'player' if the player has blackjack but the house does not") {
                    dealer.player.cards.append(aceOfHearts)
                    dealer.player.cards.append(queenOfHearts)
                    
                    expect(dealer.winner()).to(match("player"))
                }

                it("should return 'house' if the house has blackjack but the player does not") {
                    dealer.house.cards.append(aceOfSpades)
                    dealer.house.cards.append(tenOfDiamonds)
                    
                    expect(dealer.winner()).to(match("house"))
                }

                
                it("should return 'house' if the player busted") {
                    dealer.player.cards.append(tenOfDiamonds)
                    dealer.player.cards.append(queenOfHearts)
                    dealer.player.cards.append(twoOfClubs)
                    
                    expect(dealer.winner()).to(match("house"))
                }

                it("should return 'player' if the house busted") {
                    dealer.house.cards.append(tenOfDiamonds)
                    dealer.house.cards.append(queenOfHearts)
                    dealer.house.cards.append(twoOfClubs)
                    
                    expect(dealer.winner()).to(match("player"))
                }

                it("should return 'player' if the player holds five cards without busting") {
                    dealer.player.cards.append(aceOfSpades)
                    dealer.player.cards.append(aceOfHearts)
                    dealer.player.cards.append(twoOfClubs)
                    dealer.player.cards.append(sixOfClubs)
                    dealer.player.cards.append(tenOfDiamonds)
                    
                    expect(dealer.winner()).to(match("player"))
                }

                it("should return 'player' if the house and player have stayed and player's score exceeds the house's score") {
                    dealer.player.cards.append(tenOfDiamonds)
                    dealer.player.cards.append(sixOfClubs)
                    dealer.player.cards.append(twoOfClubs)
                    dealer.player.stayed = true
                    dealer.house.cards.append(queenOfHearts)
                    dealer.house.cards.append(sevenOfClubs)
                    dealer.house.stayed = true
                    
                    expect(dealer.winner()).to(match("player"))
                }

                it("should return 'house' if the house and player have stayed and player's score does not exceed the house's score") {
                    dealer.player.cards.append(tenOfDiamonds)
                    dealer.player.cards.append(sixOfClubs)
                    dealer.player.cards.append(twoOfClubs)
                    dealer.player.stayed = true
                    dealer.house.cards.append(queenOfHearts)
                    dealer.house.cards.append(sevenOfClubs)
                    dealer.house.cards.append(aceOfHearts)
                    dealer.house.stayed = true
                    
                    expect(dealer.winner()).to(match("house"))
                }
                
                it("should return 'no' if there is not a winner") {
                    dealer.player.cards.append(tenOfDiamonds)
                    dealer.player.cards.append(sixOfClubs)
                    dealer.house.cards.append(queenOfHearts)
                    dealer.house.cards.append(twoOfClubs)
                    
                    expect(dealer.winner()).to(match("no"))
                }
            }
            
            let playerTokensStarting = dealer.player.tokens
            let houseTokensStarting = dealer.house.tokens

            describe("award") {
                /* advanced
                it("should not award the bet if the game is a push") {
                    dealer.house.cards.append(aceOfSpades)
                    dealer.house.cards.append(tenOfDiamonds)
                    dealer.player.cards.append(aceOfHearts)
                    dealer.player.cards.append(queenOfHearts)
                    
                    let bet: UInt = 20
                    dealer.bet = bet
                    dealer.award()
                    
                    expect(dealer.player.tokens).to(equal(playerTokensStarting))
                    expect(dealer.house.tokens).to(equal(houseTokensStarting))
                }
                
                it("should return a string message saying that the game is a push when the game is a push") {
                    dealer.house.cards.append(aceOfSpades)
                    dealer.house.cards.append(tenOfDiamonds)
                    dealer.player.cards.append(aceOfHearts)
                    dealer.player.cards.append(queenOfHearts)

                    let message = dealer.award()
                    
                    expect(message.lowercaseString).to(contain("push"))
                } 
                */
                
                it("should award the bet to the player's tokens when the player wins") {
                    dealer.player.cards.append(aceOfHearts)
                    dealer.player.cards.append(queenOfHearts)
                    
                    let bet: UInt = 20
                    dealer.bet = bet
                    dealer.award()
                    
                    expect(dealer.player.tokens).to(equal(playerTokensStarting + bet))
                    expect(dealer.house.tokens).to(equal(houseTokensStarting - bet))
                }
                
                it("should return a string message saying the player won when the player wins") {
                    dealer.player.cards.append(aceOfHearts)
                    dealer.player.cards.append(queenOfHearts)
                    
                    let message = dealer.award()
                    
                    expect(message.lowercaseString).to(contain("player"))
                    expect(message.lowercaseString).to(contain("wins"))
                }
                
                it("should award the bet to the house's tokens when the house wins") {
                    dealer.house.cards.append(aceOfSpades)
                    dealer.house.cards.append(tenOfDiamonds)

                    let bet: UInt = 20
                    dealer.bet = bet
                    dealer.award()

                    expect(dealer.house.tokens).to(equal(houseTokensStarting + bet))
                    expect(dealer.player.tokens).to(equal(playerTokensStarting - bet))
                }
                
                it("should return a string message saying the house won when the house wins") {
                    dealer.house.cards.append(aceOfSpades)
                    dealer.house.cards.append(tenOfDiamonds)
                    
                    let message = dealer.award()
                    
                    expect(message.lowercaseString).to(contain("house"))
                    expect(message.lowercaseString).to(contain("wins"))
                }
                
                it("should not award the bet if the game is not over") {
                    dealer.player.cards.append(tenOfDiamonds)
                    dealer.player.cards.append(sixOfClubs)
                    dealer.house.cards.append(queenOfHearts)
                    dealer.house.cards.append(twoOfClubs)
                    
                    let bet: UInt = 20
                    dealer.bet = bet
                    dealer.award()
                    
                    expect(dealer.player.tokens).to(equal(playerTokensStarting))
                    expect(dealer.house.tokens).to(equal(houseTokensStarting))
                }
                
                it("should return a string message saying there is no winner when there is not a winner") {
                    dealer.player.cards.append(tenOfDiamonds)
                    dealer.player.cards.append(sixOfClubs)
                    dealer.house.cards.append(queenOfHearts)
                    dealer.house.cards.append(twoOfClubs)
                    
                    let message = dealer.award()
                    
                    expect(message.lowercaseString).to(contain("no"))
                    expect(message.lowercaseString).to(contain("winner"))
                }
            }
        }
    }
}

