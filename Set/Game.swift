//
//  Game.swift
//  Set
//
//  Created by Евгений on 10.11.2020.
//

import Foundation

struct Game {
    
    var cards = [PlayingCard]()
    var cardsTemp = [PlayingCard]()
    var playDesk = [PlayingCard]()
    var selectedCards = [PlayingCard]()
    
    var isGameOver : Bool {
        return (cardsTemp.count == 0 && getAllSetsOnBoard().count == 0) ?  true: false
    }
    
    let maxCardsOnBoard = 24
    
    mutating func newGame(count: Int)  {
        cards.removeAll()
        cardsTemp.removeAll()
        
        for p_count in PlayingCard.Propertys.all {
            for p_figure in PlayingCard.Propertys.all {
                for p_fill in PlayingCard.Propertys.all {
                    for p_color in PlayingCard.Propertys.all {
                        let pCard = PlayingCard(cardCount: p_count, cardFigure: p_figure, cardFill: p_fill, cardColor: p_color)
                        cards.append(pCard)
                    }
                }
                
            }
        }
        cardsTemp = cards
        playDesk.removeAll()
        getDesk(count: count)
        selectedCards.removeAll()
    }
    
    
    func isSetFor(threeCards: [PlayingCard]) -> Bool {
        
        let theOne = ((threeCards[0].cardColor == threeCards[1].cardColor) && (threeCards[1].cardColor == threeCards[2].cardColor) && (threeCards[0].cardColor == threeCards[2].cardColor) ) || ((threeCards[0].cardColor != threeCards[1].cardColor) && (threeCards[1].cardColor != threeCards[2].cardColor) && (threeCards[0].cardColor != threeCards[2].cardColor) ) ? true : false
        
        let theTwo = ((threeCards[0].cardFigure == threeCards[1].cardFigure) && (threeCards[1].cardFigure == threeCards[2].cardFigure) && (threeCards[0].cardFigure == threeCards[2].cardFigure)) || ((threeCards[0].cardFigure != threeCards[1].cardFigure) && (threeCards[1].cardFigure != threeCards[2].cardFigure) && (threeCards[0].cardFigure != threeCards[2].cardFigure)) ? true : false
        
        let theThree = ((threeCards[0].cardCount == threeCards[1].cardCount) && (threeCards[1].cardCount == threeCards[2].cardCount) && (threeCards[0].cardCount == threeCards[2].cardCount)) || ((threeCards[0].cardCount != threeCards[1].cardCount) && (threeCards[1].cardCount != threeCards[2].cardCount) && (threeCards[0].cardCount != threeCards[2].cardCount)) ? true : false
        
        let theFore = ((threeCards[0].cardFill == threeCards[1].cardFill) && (threeCards[1].cardFill == threeCards[2].cardFill) && (threeCards[0].cardFill == threeCards[2].cardFill)) || ((threeCards[0].cardFill != threeCards[1].cardFill) && (threeCards[1].cardFill != threeCards[2].cardFill) && (threeCards[0].cardFill != threeCards[2].cardFill)) ? true : false
        
        if (theOne == false) || (theTwo == false)  || (theThree == false) || (theFore == false) {
            return false
        }
        
        return true
    }
    
    private func getAllSetsOnBoard() -> [[Int]] {
        var masAllSets = [[Int]]()
        for i in 0..<playDesk.count {
            for j in (i+1)..<playDesk.count {
                for k in(j+1)..<playDesk.count {
                    let cards = [playDesk[i],playDesk[j],playDesk[k]]
                    if isSetFor(threeCards: cards) {
                        masAllSets.append([i,j,k])
                        print("i = \(i), j = \(j), k = \(k)")
                    }
                }
            }
        }
        return masAllSets
    }
    
    func getSelrctrdIndexes() -> [Int] {
        
        var mas = [Int]()
        for cardS in selectedCards {
            if playDesk.contains(cardS) {
                if let index = playDesk.firstIndex(of: cardS) {
                    mas.append(index)
                }
            }
        }
        return mas
    }
    
    
    mutating func touchCard(index: Int)  {
        
        if !playDesk.indices.contains(index) {return}
        if getSelrctrdIndexes().contains(index) {
            if selectedCards.count < 3 {
                let cardElement = playDesk[index]
                if let indexSC = selectedCards.firstIndex(of: cardElement) {
                    selectedCards.remove(at: indexSC)
                }
            }
        } else {
            
           // if selectedCards.count < 3 {
                selectedCards.append(playDesk[index])
            //} else {
            if selectedCards.count == 3 {
                if isSetFor(threeCards: selectedCards) {
                    
              //      let cardTemp = playDesk[index]
                    for cardS in selectedCards {
                        if playDesk.contains(cardS) {
                            if let index = playDesk.firstIndex(of: cardS) {
                                playDesk.remove(at: index)
                            }
                        }
                    }
                    
                    if playDesk.count <= (maxCardsOnBoard / 2) { getDesk(count: 3)}
                    selectedCards.removeAll()
                   // selectedCards.append(cardTemp)
                } else {
                    let cardTemp = playDesk[index]
                    selectedCards.removeAll()
                    selectedCards.append(cardTemp)
                }
            }
        }
    }
    
    
    mutating func getDesk(count: Int) {
        for _ in 0...count - 1 {
            if cardsTemp.count > 0, playDesk.count < maxCardsOnBoard {
                playDesk.append(cardsTemp.remove(at:cardsTemp.count.arc4_random))
            }
        }
        
    }
    
}

extension Int {
    var arc4_random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

