//
//  CardModel.swift
//  MemoryMatchingGame
//
//  Created by Tran Thien Hao on 8/26/20.
//  Copyright © 2020 Tran Thien Hao. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards(_ maxPairs: Int) -> [Card] {
        var n = maxPairs;
        if(maxPairs > 13){
            n = 13
        }

        var cardList = [Card]()
        for _ in 1...n {
            var cardNumber = Int.random(in: 1...13)
            var imageName = "card\(cardNumber)"
            while cardList.contains(where: { $0.imageName == imageName }) {
                cardNumber = Int.random(in: 1...13)
                imageName = "card\(cardNumber)"
            }
            let firstCard = Card(imageName: imageName)
            let secondCard = Card(imageName: imageName)
            cardList += [firstCard, secondCard]
        }

        cardList.shuffle()
        return cardList
    }
    
}
