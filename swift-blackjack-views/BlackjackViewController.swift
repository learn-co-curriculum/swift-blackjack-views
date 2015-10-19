//
//  BlackjackViewController.swift
//  swift-blackjack-views
//
//  Created by Mark Murray on 10/19/15.
//  Copyright © 2015 Flatiron School. All rights reserved.
//

import UIKit

class BlackjackViewController: UIViewController {
    @IBOutlet weak var winner: UILabel!
    @IBOutlet weak var tokens: UILabel!
    @IBOutlet weak var betTextField: UITextField!
    
    @IBOutlet weak var houseStayed: UILabel!
    @IBOutlet weak var houseScore: UILabel!
    @IBOutlet weak var houseCard1: UILabel!
    @IBOutlet weak var houseCard2: UILabel!
    @IBOutlet weak var houseCard3: UILabel!
    @IBOutlet weak var houseCard4: UILabel!
    @IBOutlet weak var houseCard5: UILabel!
    @IBOutlet weak var houseBlackjack: UILabel!
    @IBOutlet weak var houseBusted: UILabel!

    @IBOutlet weak var playerStayed: UILabel!
    @IBOutlet weak var playerScore: UILabel!
    @IBOutlet weak var playerCard1: UILabel!
    @IBOutlet weak var playerCard2: UILabel!
    @IBOutlet weak var playerCard3: UILabel!
    @IBOutlet weak var playerCard4: UILabel!
    @IBOutlet weak var playerCard5: UILabel!
    @IBOutlet weak var playerBlackjack: UILabel!
    @IBOutlet weak var playerBusted: UILabel!
    
    @IBOutlet weak var deal: UIButton!
    @IBOutlet weak var hit: UIButton!
    @IBOutlet weak var stay: UIButton!
    
    var houseCardViews: [UILabel] = []
    var playerCardViews: [UILabel] = []
    
    var dealer = Dealer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        houseCardViews = [houseCard1, houseCard2, houseCard3, houseCard4, houseCard5]
        playerCardViews = [playerCard1, playerCard2, playerCard3, playerCard4, playerCard5]
        
        self.updateViews()
        self.houseCard1.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateViews() {
        self.showHouseCards()
        self.showPlayerCards()
    }
    
    private func showHouseCards() {
        for var i = 0; i < houseCardViews.count; i++ {
            let houseCardView = houseCardViews[i]
            
            if i == 0 {
                houseCardView.text = "❂"
            } else if i < self.dealer.house.cards.count {
                let card = self.dealer.house.cards[i]
                houseCardView.text = card.cardLabel
            } else {
                houseCardView.text = ""
            }
            
            if houseCardView.text?.characters.count > 0 {
                houseCardView.hidden = false
            } else {
                houseCardView.hidden = true
            }
        }
    }
    
    private func showPlayerCards() {
        
    }

    @IBAction func dealTapped(sender: UIButton) {
    }
    
    @IBAction func hitTapped(sender: UIButton) {
    }
    
    @IBAction func stayTapped(sender: UIButton) {
    }
}

