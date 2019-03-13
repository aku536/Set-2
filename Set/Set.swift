//
//  Set.swift
//  Set
//
//  Created by Кирилл Афонин on 22/01/2019.
//  Copyright © 2019 krrl. All rights reserved.
//

import Foundation

struct Set {
    
    private(set) var allCards = [PlayingCard]()
    
    private(set) var selectedCards = [PlayingCard]() {
        didSet {
            //if selectedCards.count > 3 {selectedCards.removeSubrange(0...2)}
            if selectedCards.count > 2 {
                if isMatching(cards: selectedCards){
                    matchedCards += selectedCards
                    score += 5
                    //selectedCards.removeAll()
                } else {
                    score -= 3
                }
            }
        }
    }
    
    private(set) var matchedCards = [PlayingCard]() {
        didSet {
            for matchedCard in matchedCards {
                for card in dealtCards {
                    if card == matchedCard {
                        let index = dealtCards.index(of: card)
                        if takeCard() != nil && (dealtCards.count <= 12) {
                            dealtCards[index!] = takeCard()!
                        } else {
                            dealtCards.remove(at: index!)
                        }
                    }
                }
            }
        }
    }
    
    //cards on the deck
    private(set) var dealtCards = [PlayingCard]()
    
    private(set) var score = 0
    
    init() {
        for symbol in PlayingCard.Symbol.all {
            for quantity in PlayingCard.Quantity.all {
                for color in PlayingCard.Color.all {
                    for stroke in PlayingCard.Stroke.all {
                        allCards.append(PlayingCard(symbols: symbol, quantity: quantity, colors: color, strokes: stroke))
                    }
                }
            }
        }
        for _ in 0...11 {
            if let card = takeCard() {
                dealtCards.append(card)
            }
        }
    }
    
    //takes card from deck or returns nil
    private mutating func takeCard() -> PlayingCard? {
        if !allCards.isEmpty {
            return allCards.remove(at: Int.random(in: 0..<allCards.count))
        } else {
            return nil
        }
    }
    
    //add card to a selectedCards
    mutating func selectCard(at index: Int) {
        let card = dealtCards[index]
        if selectedCards.count > 2 { selectedCards.removeAll() }
        if selectedCards.contains(card) {
            selectedCards.remove(card)
        } else {
            selectedCards.append(card)
        }
    }
    
    //check matching according to the Set rules
    private func isMatching (cards: [PlayingCard]) -> Bool {
        let sum = [
            cards.reduce(0, {$0 + $1.symbols.rawValue}),
            cards.reduce(0, {$0 + $1.quantity.rawValue}),
            cards.reduce(0, {$0 + $1.colors.rawValue}),
            cards.reduce(0, {$0 + $1.strokes.rawValue})
        ]
        return sum.reduce(true, {$0 && ($1 % 3 == 0)})
    }
    
    mutating func deal3Cards() {
        for _ in 0...2 {
            if let card = takeCard() {
                dealtCards.append(card)
            }
        }
    }
    
    mutating func shuffle() {
        dealtCards.shuffle()
    }
}

//remove element from array. Need to check if the array contains the element
extension Array where Element: Equatable {
    mutating func remove(_ element: Element) {
        _ = index(of: element).flatMap { self.remove(at: $0) }
    }
}
