//
//  File.swift
//  MemoryMatchingGame
//
//  Created by Tran Thien Hao on 8/27/20.
//  Copyright © 2020 Tran Thien Hao. All rights reserved.
//

import Foundation

class Card {
    var imageName: String = ""
    var isMatched: Bool = false
    var isFlipped: Bool = false
    
    init(imageName: String){
        self.imageName = imageName
    }
    
    func isMatchingWith(_ card: Card?) -> Bool {
        return self.imageName == card?.imageName
    }
}
