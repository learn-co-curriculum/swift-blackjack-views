//  DeckSpec.swift

import Quick
import Nimble
@testable import swift_blackjack_views

class DeckSpec: QuickSpec {
    override func spec() {
        describe("Deck") {
            
            var deck : Deck = Deck()
            
            beforeEach {
                deck = Deck()
            }
            
            describe("initializer") {
                it("should set up the deck with 52 undealt cards") {
                    expect(deck.remainingCards.count).to(equal(52))
                    expect(deck.dealtCards).to(beEmpty())
                }
            }
            
            describe("drawCard") {
                it("should return the King of Clubs from a fresh deck") {
                    let card = deck.drawCard()
                    
                    expect(card.cardLabel).to(match("♣️K"))
                }
            }
            
            describe("shuffle") {
                it("should change the order of the cards") {
                    deck.shuffle()
                    let card1 = deck.drawCard()
                    let card2 = deck.drawCard()
                    let card3 = deck.drawCard()
                    
                    if card1.cardLabel == "♣️K" && card2.cardLabel == "♣️Q" {
                        // this test has a 1 in 132,600 chance of randomly failing
                        expect(card3.cardLabel).notTo(match("♣️J"))
                    }
                }
            }
        }
    }
}

