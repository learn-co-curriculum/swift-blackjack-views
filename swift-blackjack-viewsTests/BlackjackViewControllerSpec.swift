//
//  BlackjackViewControllerSpec.swift
//  swift-blackjack-views
//
//  Created by Mark Murray on 10/20/15.
//  Copyright © 2015 Flatiron School. All rights reserved.
//

import KIF
import Quick
import Nimble
@testable import swift_blackjack_views

class BlackjackViewControllerSpec: QuickSpec {
    override func spec() {
        let tester = self.tester()
        
        var blackjackVC = BlackjackViewController()
        
        beforeEach { () -> () in
            let main = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = main.instantiateViewControllerWithIdentifier("blackjackVC")
            
            blackjackVC = vc as! BlackjackViewController
            
            UIApplication.sharedApplication().keyWindow?.rootViewController = blackjackVC
        }
    
        describe("initial view") {
            it("should have a UIView called view") {
                tester.waitForViewWithAccessibilityLabel("view")
            }
            
            it("should hide all of the house's card views") {
                tester.waitForAbsenceOfViewWithAccessibilityLabel("houseCard1")
                tester.waitForAbsenceOfViewWithAccessibilityLabel("houseCard2")
                tester.waitForAbsenceOfViewWithAccessibilityLabel("houseCard3")
                tester.waitForAbsenceOfViewWithAccessibilityLabel("houseCard4")
                tester.waitForAbsenceOfViewWithAccessibilityLabel("houseCard5")
            }
        
            
            it("should hide all of the player's card views") {
                tester.waitForAbsenceOfViewWithAccessibilityLabel("playerCard1")
                tester.waitForAbsenceOfViewWithAccessibilityLabel("playerCard2")
                tester.waitForAbsenceOfViewWithAccessibilityLabel("playerCard3")
                tester.waitForAbsenceOfViewWithAccessibilityLabel("playerCard4")
                tester.waitForAbsenceOfViewWithAccessibilityLabel("playerCard5")
            }
            
            it("should hide the winner, houseScore, busted, and blackjack labels") {
                tester.waitForAbsenceOfViewWithAccessibilityLabel("winner")
                tester.waitForAbsenceOfViewWithAccessibilityLabel("houseScore")
                tester.waitForAbsenceOfViewWithAccessibilityLabel("houseBusted")
                tester.waitForAbsenceOfViewWithAccessibilityLabel("houseBlackjack")
                tester.waitForAbsenceOfViewWithAccessibilityLabel("playerBusted")
                tester.waitForAbsenceOfViewWithAccessibilityLabel("playerBlackjack")
                }
        }
        
        describe("deal button") {
            it("should unhide at least the first two card views for the house and the player") {
                tester.tapViewWithAccessibilityLabel("deal")
                
                tester.waitForViewWithAccessibilityLabel("houseCard1")
                tester.waitForViewWithAccessibilityLabel("houseCard2")
                tester.waitForViewWithAccessibilityLabel("playerCard1")
                tester.waitForViewWithAccessibilityLabel("playerCard2")
            }
            
            it("should show the card labels in the card views") {
                tester.tapViewWithAccessibilityLabel("deal")
                
                let cardHouse2 = blackjackVC.dealer.house.cards[1];
                let cardPlayer1 = blackjackVC.dealer.player.cards[0];
                let cardPlayer2 = blackjackVC.dealer.player.cards[1];
                
                tester.waitForViewWithAccessibilityLabel("houseCard1")
                let houseCard2 = tester.waitForViewWithAccessibilityLabel("houseCard2") as! UILabel
                let playerCard1 = tester.waitForViewWithAccessibilityLabel("playerCard1") as! UILabel
                let playerCard2 = tester.waitForViewWithAccessibilityLabel("playerCard2") as! UILabel
                
                // the house's first card label should ideally be kept hidden
                expect(houseCard2.text).to(equal(cardHouse2.cardLabel))
                expect(playerCard1.text).to(equal(cardPlayer1.cardLabel))
                expect(playerCard2.text).to(equal(cardPlayer2.cardLabel))
            }
            
            it("should update the player's score label to show the current score") {
                tester.tapViewWithAccessibilityLabel("deal")
                
                let playerScore = tester.waitForViewWithAccessibilityLabel("playerScore") as! UILabel
                
                expect(playerScore.text).to(endWith("\(blackjackVC.dealer.player.handscore)"))
            }
            
            it("should enable the hit button, or reenable the deal button if the player may not hit") {
                tester.tapViewWithAccessibilityLabel("deal")
                
                let hit = tester.waitForViewWithAccessibilityLabel("hit") as! UIButton
                
                if hit.enabled {
                    tester.tapViewWithAccessibilityLabel("hit")
                } else {
                    tester.tapViewWithAccessibilityLabel("deal")
                }
            }
            
            it("should enable the stay button, or reenable the deal button if the player may not hit") {
                tester.tapViewWithAccessibilityLabel("deal")
                
                let stay = tester.waitForViewWithAccessibilityLabel("stay") as! UIButton
                
                if stay.enabled {
                    tester.tapViewWithAccessibilityLabel("stay")
                } else {
                    tester.tapViewWithAccessibilityLabel("deal")
                }
            }
            
            it("should disable the betTextField") {
                tester.tapViewWithAccessibilityLabel("deal")
                
                let betTextField = tester.waitForViewWithAccessibilityLabel("betTextField") as! UITextField
                
                expect(betTextField.enabled).to(beFalse())
            }
        }
    
        describe("hit") {
            it("should show a third card in the player's card views") {
                tester.tapViewWithAccessibilityLabel("deal")
                tester.tapViewWithAccessibilityLabel("hit")
                
                tester.waitForViewWithAccessibilityLabel("playerCard3")
            }
            
            it("should update the player's score label with the new score") {
                tester.tapViewWithAccessibilityLabel("deal")
                
                let hit = tester.waitForViewWithAccessibilityLabel("hit") as! UIButton
                
                if hit.enabled {
                    tester.tapViewWithAccessibilityLabel("hit")
                }
                
                let playerScore = tester.waitForViewWithAccessibilityLabel("playerScore") as! UILabel
                
                expect(playerScore.text).to(endWith("\(blackjackVC.dealer.player.handscore)"))
                }
            }

        describe("stay") {
            it("should disable the hit button if the deal did not produce a winner") {
                tester.tapViewWithAccessibilityLabel("deal")
                
                let stay = tester.waitForViewWithAccessibilityLabel("stay") as! UIButton
                
                if stay.enabled {
                    tester.tapViewWithAccessibilityLabel("stay")
                }
                
                let hit = tester.waitForViewWithAccessibilityLabel("hit") as! UIButton
                
                expect(hit.enabled).to(beFalse());
            }
            
            it("should disable itself if the deal did not produce a winner") {
                tester.tapViewWithAccessibilityLabel("deal")
                
                let stay = tester.waitForViewWithAccessibilityLabel("stay") as! UIButton
                
                if stay.enabled {
                    tester.tapViewWithAccessibilityLabel("stay")
                }
                
                expect(stay.enabled).to(beFalse())
            }
            
            it("should reenable the deal button if the deal did not produce a winner, if it did, deal should be reenabled") {
                tester.tapViewWithAccessibilityLabel("deal")
                
                let stay = tester.waitForViewWithAccessibilityLabel("stay") as! UIButton
                
                
                if stay.enabled {
                    tester.tapViewWithAccessibilityLabel("stay")
                }

                tester.tapViewWithAccessibilityLabel("deal")
            }
            
            it("should show the player's stayed label") {
                tester.tapViewWithAccessibilityLabel("deal")
                
                let stay = tester.waitForViewWithAccessibilityLabel("stay") as! UIButton
                
                if stay.enabled {
                    tester.tapViewWithAccessibilityLabel("stay")
                    tester.waitForViewWithAccessibilityLabel("playerStayed")
                }
            }
            
            it("should display the winner") {
                tester.tapViewWithAccessibilityLabel("deal")
                
                let stay = tester.waitForViewWithAccessibilityLabel("stay") as! UIButton
                
                
                if stay.enabled {
                    tester.tapViewWithAccessibilityLabel("stay")
                }
                
                tester.waitForViewWithAccessibilityLabel("winner")
            }
            
            it("should display the house's score") {
                tester.tapViewWithAccessibilityLabel("deal")
                
                let stay = tester.waitForViewWithAccessibilityLabel("stay") as! UIButton
                
                
                if stay.enabled {
                    tester.tapViewWithAccessibilityLabel("stay")
                }
                
                let houseScore = tester.waitForViewWithAccessibilityLabel("houseScore") as! UILabel
                
                expect(houseScore.text).to(endWith("\(blackjackVC.dealer.house.handscore)"))
            }
        }
    }
}

