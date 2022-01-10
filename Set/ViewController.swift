//
//  ViewController.swift
//  Set
//
//  Created by Евгений on 10.11.2020.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var game = Game()
    let masFigures = ["▲","●","◼︎"]
    let masWidh = [5,-5,-5]
    let masColor = [UIColor.red,UIColor.green, UIColor.purple]
    var masSelectedIndexs = [Int]()
    
    @IBOutlet weak var endGameLabel: UILabel!
    @IBOutlet weak var newGameBtn: UIButton!
    
    var timer = Timer()
    private var counterTimer : Int = 0
    
    @IBOutlet weak var addCardsBtn: UIButton!
    
    var selectThreeCards : Int {
        return masSelectedIndexs.count
    }
    
    @IBOutlet var cardButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtons()
        game.newGame(count:  cardButtons.count / 2)
        updateFromModel()
    }
    
    func setButtons()  {
        
        newGameBtn.layer.borderWidth = 1.5
        newGameBtn.layer.borderColor = UIColor.white.cgColor
        newGameBtn.layer.cornerRadius = 8
        newGameBtn.layer.borderColor = UIColor.green.cgColor
        
        addCardsBtn.layer.borderWidth = 1.5
        addCardsBtn.layer.borderColor = UIColor.white.cgColor
        addCardsBtn.layer.cornerRadius = 8
        addCardsBtn.layer.borderColor = UIColor.green.cgColor
        
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        
        game.newGame(count: cardButtons.count / 2)
        counterTimer = 0
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        updateFromModel()
    }
    
    @objc func update() {
        counterTimer = counterTimer + 1
        endGameLabel.textColor =  #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        endGameLabel.text = "Игра началась: \(counterTimer)"
        
    }
    
    @IBAction func checkCard(_ sender: UIButton) {
        
        if counterTimer == 0 {return}
        
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            
            game.touchCard(index: cardNumber)
            masSelectedIndexs =  game.getSelrctrdIndexes()
            updateFromModel()
            
            if game.isGameOver {
                endGameLabel.textColor = .red
                endGameLabel.text = "Игра закончена. Время: \(counterTimer) "
                timer.invalidate()
                return
            }
            
        } else {
            print("Nooo")
        }
    }
    
    @IBAction func addNewCards(_ sender: UIButton) {
        if counterTimer == 0 {return}
        game.getDesk(count: 3)
        updateFromModel()
    }
    
    private func updateFromModel()  {
        
        for indCard in cardButtons.indices {
            if game.playDesk.indices.contains(indCard) {
                let btn = cardButtons[indCard]
                let strAttr = getAttrStringWith(count: game.playDesk[indCard].cardCount.ind, figure: game.playDesk[indCard].cardFigure.ind, color: game.playDesk[indCard].cardColor.ind, fill: game.playDesk[indCard].cardFill.ind)
                btn.setAttributedTitle(strAttr, for: .normal)
                btn.backgroundColor = .white
                btn.layer.borderWidth = 0.9
                btn.layer.borderColor = UIColor.blue.cgColor
                btn.layer.cornerRadius = 8
                
                if masSelectedIndexs.contains(indCard) {
                    if selectThreeCards == 3, game.isSetFor(threeCards: game.selectedCards)  {
                        btn.layer.borderColor = UIColor.red.cgColor
                        btn.backgroundColor = #colorLiteral(red: 0.5967712402, green: 0.7988023162, blue: 0.9892227054, alpha: 1)
                    } else {
                        btn.layer.borderColor = UIColor.red.cgColor
                        btn.layer.borderWidth = 4
                    }
                }
                
            } else {
                
                cardButtons[indCard].setAttributedTitle(nil, for: .normal)
                cardButtons[indCard].backgroundColor   = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                cardButtons[indCard].layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                
            }
        }
    }
    
    private func getAttrStringWith(count: Int, figure: Int, color: Int, fill: Int) -> NSMutableAttributedString {
        
        var attrString = ""
        
        switch (count) {
        case 0:
            attrString = "\(masFigures[figure])"
        case 1:
            attrString = "\(masFigures[figure]) \(masFigures[figure])"
        case 2:
            attrString = "\(masFigures[figure]) \(masFigures[figure]) \(masFigures[figure])"
        default:
            attrString = ""
        }
        
        switch fill {
        case 0:
            let attrSt : [NSAttributedString.Key: Any] = [
                .strokeColor : masColor[color],
                .strokeWidth: masWidh[fill],
                .foregroundColor: masColor[color].withAlphaComponent(100)
            ]
            return NSMutableAttributedString(string: attrString, attributes: attrSt)
        case 1:
            let attrSt : [NSAttributedString.Key: Any] = [
                .strokeColor : masColor[color],
                .strokeWidth: masWidh[fill],
                .foregroundColor: masColor[color].withAlphaComponent(100)
                
            ]
            return NSMutableAttributedString(string: attrString, attributes: attrSt)
        case 2:
            
            let attrSt : [NSAttributedString.Key: Any] = [
                .strokeColor : masColor[color],
                .strokeWidth: masWidh[fill],
                .foregroundColor: masColor[color].withAlphaComponent(0.15)
                
            ]
            return NSMutableAttributedString(string: attrString, attributes: attrSt)
        default:
            let attrSt : [NSAttributedString.Key: Any] = [
                .strokeColor : masColor[color],
                
            ]
            return NSMutableAttributedString(string: attrString, attributes: attrSt)
        }
        
    }
    
}


