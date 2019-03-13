//
//  ViewController.swift
//  Set
//
//  Created by Кирилл Афонин on 22/01/2019.
//  Copyright © 2019 krrl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var scoreLabel: UILabel! {
        didSet {
            scoreLabel.text = "Score: \(game.score)"
        }
    }
    @IBOutlet weak var dealButton: UIButton!
    @IBOutlet weak var deckView: DeckView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dealThreeMoreCards(_:)))
            swipe.direction = .down
            deckView.addGestureRecognizer(swipe)
            
            let rotate = UIRotationGestureRecognizer(target: self, action: #selector(reshuffle))
            deckView.addGestureRecognizer(rotate)
        }
    }
    
    private var game = Set()
    
    @IBAction func dealThreeMoreCards(_ sender: UIButton) {
        game.deal3Cards()
        updateViewFromModel()
    }
    
    @objc
    private func reshuffle(_ sender: UIGestureRecognizer) {
        switch sender.state {
        case .ended:
            game.shuffle()
            updateViewFromModel()
        default: break
        }
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game = Set()
        deckView.cardViews.removeAll()
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        if deckView.cardViews.count - game.dealtCards.count > 0 {
            let cardsInGame = deckView.cardViews[..<game.dealtCards.count]
            deckView.cardViews = Array(cardsInGame)
        }
        
        for index in game.dealtCards.indices {
            let card = game.dealtCards[index]
            if index > (deckView.cardViews.count - 1) {
                let cardView = SetCardView()
                updateCardView(cardView, for: card)
                addTapGestureRecognizer(for: cardView)
                deckView.cardViews.append(cardView)
            } else {
                let cardView = deckView.cardViews[index]
                updateCardView(cardView, for: card)
            }
        }
        scoreLabel.text = "Score: \(game.score)"
        dealButton.isEnabled = game.allCards.count > 0
    }
    
    private func updateCardView(_ cardView: SetCardView, for card: PlayingCard) {
        cardView.symbolInt = card.symbols.rawValue
        cardView.colorInt = card.colors.rawValue
        cardView.fillInt = card.strokes.rawValue
        cardView.count = card.quantity.rawValue
        cardView.isSelected = game.selectedCards.contains(card)
        
        if game.selectedCards.count > 2 {
            if game.matchedCards.contains(card) {
                cardView.isMatched = true
            } else if game.selectedCards.contains(card) {
                cardView.isMatched = false
            }
        } else {
            cardView.isMatched = nil
        }
    }
    
    private func addTapGestureRecognizer(for cardView: SetCardView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCard(recognizedBy:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        cardView.addGestureRecognizer(tap)
    }
    
    @objc private func tapCard(recognizedBy recognizer:UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let cardView = recognizer.view! as? SetCardView {
                game.selectCard(at: deckView.cardViews.index(of: cardView)!)
            }
        default: break
        }
        updateViewFromModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }
    
}
