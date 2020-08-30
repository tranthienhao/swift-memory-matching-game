//
//  ViewController.swift
//  MemoryMatchingGame
//
//  Created by Tran Thien Hao on 8/24/20.
//  Copyright © 2020 Tran Thien Hao. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var cardCollectionView: UICollectionView!
    @IBOutlet weak var timerLabel: UILabel!

    let model = CardModel()
    var cardList = [Card]()
    var lastSelectedIndexPath: IndexPath?
    var timer: Timer?
    var timeToPlay: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cardCollectionView.dataSource = self
        cardCollectionView.delegate = self
        
        setup()
    }
    
    func setup(timeToPlay: Double = 20000) {
        cardList = model.getCards(6)
        self.timeToPlay = timeToPlay
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(onTimerChange), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        cardCollectionView.reloadData()
    }
    
    // MARK: - timer methods
    @objc func onTimerChange() {
        timeToPlay -= 1.0
        let timeToSeconds: Double = timeToPlay / 1000.0
        timerLabel.text = String(format: "Time remaining: %.2f", timeToSeconds)
        if timeToPlay == 0 {
            timerLabel.textColor = UIColor.red
            checkForGameEnd()
            timer?.invalidate()
        }
    }
    
    // MARK: - cardCollectionView delegate  method
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardList.count
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cardCollectionView.dequeueReusableCell(withReuseIdentifier:
                  "CardCell", for: indexPath) as! CardCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cardCell = cell as? CardCollectionViewCell
        cardCell?.configureCell(card: cardList[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        if (cell?.card?.isFlipped ?? false) {return}
        cell?.flipUp()
        cell?.card?.isFlipped = true
        
        if lastSelectedIndexPath != nil {
            compareCardInTwoCell(indexPath, lastSelectedIndexPath!)
            lastSelectedIndexPath = nil
        } else {
            lastSelectedIndexPath = indexPath
        }
    }
    
    func compareCardInTwoCell(_ firstCellIndex: IndexPath, _ lastCellIndex: IndexPath) {
        let firstCell = cardCollectionView.cellForItem(at: firstCellIndex) as? CardCollectionViewCell
        let lastCell = cardCollectionView.cellForItem(at: lastCellIndex) as? CardCollectionViewCell
        let firstCard = cardList[firstCellIndex.row]
        let lastCard = cardList[lastCellIndex.row]
        
        if firstCard.isMatchingWith(lastCard) {
            firstCard.isMatched = true
            lastCard.isMatched = true
            firstCell?.remove()
            lastCell?.remove()
            checkForGameEnd()
        } else {
            firstCard.isFlipped = false
            lastCard.isFlipped = false
            firstCell?.flipDown()
            lastCell?.flipDown()
        }
    }
    
    func checkForGameEnd() {
        var hasWon = true
        for card in cardList {
            if card.isMatched == false {
                hasWon = false
            }
        }
        
        let retryAction = UIAlertAction(title: "Retry", style: .default, handler: {(alert: UIAlertAction!) in self.setup()})
        
        if hasWon == true {
            let alertActions = [UIAlertAction(title: "OK", style: .default, handler: nil), retryAction]
            showAlert(title: "Congraturations!", message: "You have won the game!", alertActions: alertActions)
            timer?.invalidate()
        } else if timeToPlay <= 0 {
            showAlert(title: "Time's Up", message: "Sorry, better luck next time!", alertActions: [retryAction])
        }
    }
    
    func showAlert(title: String, message: String, alertActions: [UIAlertAction] = []){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if(alertActions.count > 0){
            for action in alertActions {
                alert.addAction(action)
            }
        }
        present(alert, animated: true, completion: nil)
    }
}

