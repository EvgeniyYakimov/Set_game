//
//  PlayingCard.swift
//  Set
//
//  Created by Евгений on 10.11.2020.
//

import Foundation

struct PlayingCard  : Equatable {
    
    static func == (lCard : PlayingCard, rCard: PlayingCard) -> Bool {
        return ((lCard.cardColor == rCard.cardColor)  && (lCard.cardCount == rCard.cardCount) &&
                    (lCard.cardFigure == rCard.cardFigure) && (lCard.cardFill == rCard.cardFill))
    }
    
    
    var cardCount: Propertys
    var cardFigure: Propertys
    var cardFill: Propertys
    var cardColor: Propertys
    
    
    enum Propertys: Int {
    
        case count1 = 1
        case count2
        case count3
        
        static var all: [Propertys] = [count1,count2,count3]
        
         var ind : Int {
            return self.rawValue - 1
        }
    
        
    }
    
    
}
