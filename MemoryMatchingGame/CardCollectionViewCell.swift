//
//  CardCollectionViewCell.swift
//  MemoryMatchingGame
//
//  Created by Tran Thien Hao on 8/27/20.
//  Copyright © 2020 Tran Thien Hao. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    var card: Card?
    
    func configureCell(card: Card){
        self.card = card
        frontImageView.image = UIImage(named: card.imageName)
        
        if card.isMatched == true {
            frontImageView.alpha = 0
            backImageView.alpha = 0
        } else {
            frontImageView.alpha = 1
            backImageView.alpha = 1
        }
        
        if card.isFlipped == true {
            flipUp(0)
        } else {
            flipDown(0, delayTime: 0)
        }
    }
    
    func flipUp(_ flippingSpeed: TimeInterval = 0.3){
        UIView.transition(from: backImageView, to: frontImageView, duration: flippingSpeed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        card?.isFlipped = true
    }
    
    func flipDown(_ flippingSpeed: TimeInterval = 0.3, delayTime: Double = 0.7){
        DispatchQueue.main.asyncAfter(deadline:  DispatchTime.now() + delayTime, execute: {
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: flippingSpeed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        })
        card?.isFlipped = false
    }
    
    func remove(){
        backImageView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)
    }
}
