//  BlackjackViewController.swift

import UIKit

class BlackjackViewController: UIViewController, UITextFieldDelegate {
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
        self.betTextField.delegate = self
        houseCardViews = [houseCard1, houseCard2, houseCard3, houseCard4, houseCard5]
        playerCardViews = [playerCard1, playerCard2, playerCard3, playerCard4, playerCard5]
        
        self.updateViews()
        self.houseCard1.hidden = true
        self.deal.enabled = true
        self.hit.enabled = false
        self.stay.enabled = false
        
        self.tokens.text = "Tokens: \(self.dealer.player.tokens)"
        self.betTextField.text = "\(self.dealer.bet)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        let newBet = UInt(textField.text!)!
        let validBet = self.dealer.placeBet(newBet)
        if !validBet {
            self.winner.text = "Invalid bet!"
            self.winner.hidden = false
        }
        self.winner.hidden = true
        textField.text = "\(self.dealer.bet)"
    }
    
    // MARK: Update Views
    
    private func updateViews() {
        self.showHouseCards()
        self.showPlayerCards()
        self.showActiveStatusLabels()
        self.updatePlayerScoreLabel()
        
        if self.dealer.player.mayHit {
            self.winner.hidden = true
            self.houseScore.hidden = true
        }
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
        for var i = 0; i < playerCardViews.count; i++ {
            let playerCardView = playerCardViews[i]
            
            if i < self.dealer.player.cards.count {
                let card = self.dealer.player.cards[i]
                playerCardView.text = card.cardLabel
            } else {
                playerCardView.text = ""
            }
            
            if playerCardView.text?.characters.count > 0 {
                playerCardView.hidden = false
            } else {
                playerCardView.hidden = true
            }
        }
    }
    
    private func showActiveStatusLabels() {
        self.houseStayed.hidden = !self.dealer.house.stayed
        self.houseBusted.hidden = !self.dealer.house.busted
        self.playerStayed.hidden = !self.dealer.player.stayed
        self.playerBlackjack.hidden = !self.dealer.player.blackjack
        self.playerBusted.hidden = !self.dealer.player.busted
    }
    
    private func updatePlayerScoreLabel() {
        let score = self.dealer.player.handscore
        self.playerScore.text = "Score: \(score)"
    }
    
    // MARK: IBActions

    @IBAction func dealTapped(sender: UIButton) {
        self.betTextField.enabled = false
        self.deal.enabled = false
        self.hit.enabled = true
        self.stay.enabled = true
        
        self.dealer.deal()
        self.updateViews()
        
        if !self.dealer.player.mayHit {
            self.concludeRound()
        }
    }
    
    @IBAction func hitTapped(sender: UIButton) {
        let card = self.dealer.deck.drawCard()
        self.dealer.player.cards.append(card)
        
        if !self.dealer.player.mayHit || self.dealer.player.handscore == 21 {
            self.concludeRound()
        }
        
        if !self.dealer.player.busted {
            self.houseTurn()
        }
        self.updateViews()
    }
    
    @IBAction func stayTapped(sender: UIButton) {
        self.dealer.player.stayed = true
        self.updateViews()
        self.concludeRound()
    }
    
    // MARK: Turns
    
    private func houseTurn() {
        self.dealer.turn(self.dealer.house)
        if self.dealer.house.busted {
            self.concludeRound()
        }
    }
    
    // MARK: Conclude Round
    
    private func concludeRound() {
        self.betTextField.enabled = true
        self.deal.enabled = true
        self.hit.enabled = false
        self.stay.enabled = false
        
        if !self.dealer.player.busted {
            self.finishHouseTurns()
        }
        
        self.updateViews()
        self.displayHouseHand()
        self.displayHouseScore()
        self.displayAndAwardWinner()
    }
    
    private func finishHouseTurns() {
        for var i = self.dealer.house.cards.count; i < 5; i++ {
            if self.dealer.house.mayHit {
                self.houseTurn()
            }
        }
    }
    
    private func displayHouseHand() {
        let facedownHouseCard = self.dealer.house.cards[0]
        self.houseCard1.text = facedownHouseCard.cardLabel
    }
    
    private func displayHouseScore() {
        let score = self.dealer.house.handscore
        self.houseScore.text = "Score: \(score)"
        self.houseScore.hidden = false
        self.houseBlackjack.hidden = !self.dealer.house.blackjack
    }
    
    private func displayAndAwardWinner() {
        let message = self.dealer.award()
        self.winner.text = message
        self.winner.hidden = false
        let tokens = self.dealer.player.tokens
        self.tokens.text = "Tokens: \(tokens)"
    }
}

