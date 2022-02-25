//
//  GameViewController.swift
//  xox-game
//
//  Created by Ertuğrul Koca on 24.02.2022.
//

import UIKit

class GameViewController: UIViewController {
    @IBOutlet weak var playerScoreLbl: UILabel!
    @IBOutlet weak var computerScoreLbl: UILabel!
    @IBOutlet weak var box0: UIImageView!
    @IBOutlet weak var box1: UIImageView!
    @IBOutlet weak var box2: UIImageView!
    @IBOutlet weak var box3: UIImageView!
    @IBOutlet weak var box4: UIImageView!
    @IBOutlet weak var box5: UIImageView!
    @IBOutlet weak var box6: UIImageView!
    @IBOutlet weak var box7: UIImageView!
    @IBOutlet weak var box8: UIImageView!
    
    var isFinish:Bool = false
    var playerScore:Int = 0
    var computerScore:Int = 0
    var lastValue:String = "o"
    var playerChoice:[Int] = []
    var computerChoice:[Int] = []
    var emptyBox:[Int] = [0,1,2,3,4,5,6,7,8]
    var correctLines:[[Int]] = [[0,1,2],[3,4,5],[6, 7, 8],[0, 3, 6],[1, 4, 7],[2, 5, 8],[0, 4, 8],[2, 4, 6]]
    var boxes:[UIImageView]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        boxes = [box0,box1,box2,box3,box4,box5,box6,box7,box8]
        box0.tag = 0
        box1.tag = 1
        box2.tag = 2
        box3.tag = 3
        box4.tag = 4
        box5.tag = 5
        box6.tag = 6
        box7.tag = 7
        box8.tag = 8
        createTap(imageView: box0)
        createTap(imageView: box1)
        createTap(imageView: box2)
        createTap(imageView: box3)
        createTap(imageView: box4)
        createTap(imageView: box5)
        createTap(imageView: box6)
        createTap(imageView: box7)
        createTap(imageView: box8)
        
    }
    
    func createTap(imageView:UIImageView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(boxClicked(_:)))
        tap.name = String(imageView.tag)
            imageView.addGestureRecognizer(tap)
            imageView.isUserInteractionEnabled = true
        //imageView.image = UIImage(named: boxes[imageView.tag])
    }
    
    @objc func boxClicked(_ sender: UITapGestureRecognizer) {
        print("box: \(sender.name!) clicked")
        let index:Int = Int(sender.name!)!
        if emptyBox.contains(index) {
            playerPlays(selectedBox:boxes![index],index: index)
            if !isPlayerWon() {
                if playerChoice.count + computerChoice.count == 9 {
                    print("beraberlik")
                    //alert()
                    resetGame()
                    alert(text: "NO WINNER")
                }else{
                    //await Task.sleep(UInt64(1 * Double(NSEC_PER_SEC)))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                        self.computerPlays()
                        if self.isComputerWon() {
                            print("cmp kazandı")
                            self.resetGame()
                            self.alert(text: "COMPUTER WIN")
                        }
                    }
                }
            }
            else{
                print("kazandın!")
                resetGame()
                alert(text: "YOU WIN")
            }
        }
        
    }
    
    func playerPlays(selectedBox: UIImageView,index:Int) {
        playerChoice.append(index)
        emptyBox = emptyBox.filter { $0 != index }
        if selectedBox.image == nil {
            if lastValue == "x" {
                selectedBox.image = #imageLiteral(resourceName: "o.png")
                lastValue = "o"
            }
            else{
                selectedBox.image = #imageLiteral(resourceName: "x.png")
                lastValue = "x"
            }
        }

    }
    
    func computerPlays() {
        
        if !emptyBox.isEmpty {
            let cmpRandomIndex:Int = emptyBox[Int.random(in: 0..<emptyBox.count)]
            let selectedBox: UIImageView = boxes![cmpRandomIndex]
            computerChoice.append(cmpRandomIndex)
            emptyBox = emptyBox.filter { $0 != cmpRandomIndex }
            if selectedBox.image == nil {
                if lastValue == "x" {
                    selectedBox.image = #imageLiteral(resourceName: "o.png")
                    lastValue = "o"
                    print(cmpRandomIndex)
                
                }
                else{
                    selectedBox.image = #imageLiteral(resourceName: "x.png")
                    lastValue = "x"
                }
            }
        }
    }
    
    func isPlayerWon() -> Bool {
        for item in correctLines {
            if playerChoice.contains(item[0]) &&  playerChoice.contains(item[1]) && playerChoice.contains(item[2]){
                playerScore += 1
                //playerScoreLbl.text = String((Int(playerScoreLbl.text ?? "0") ?? 0) + 1)
                playerScoreLbl.text = String(playerScore)
                
                return true
            }
        }
        return false
    }
    
    func isComputerWon() -> Bool {
        for item in correctLines {
            if computerChoice.contains(item[0]) &&  computerChoice.contains(item[1]) && computerChoice.contains(item[2]){
                computerScore += 1
                //computerScoreLbl.text = String((Int(computerScoreLbl.text ?? "0") ?? 0) + 1)
                computerScoreLbl.text = String(computerScore)
                
                return true
            }
        }
        return false
    }
    
    func resetGame() {
        for item in boxes! {
            item.image = nil
        }
        lastValue = "o"
        playerChoice = []
        computerChoice = []
        emptyBox = [0,1,2,3,4,5,6,7,8]
    }
    
    func alert(text:String)  {
        var title:String?,message:String?
        if text == "YOU WIN" {
            title = "YOU WIN"
            message = "Lets Play Again"
        }
        else if text == "COMPUTER WIN"{
            title = "COMPUTER WIN"
            message = "Lets Play Again"
        }
        else{
            title = "NO WINNER"
            message = "Lets Play Again"
        }
        let alert = UIAlertController(title: title!, message: message!, preferredStyle: UIAlertController.Style.alert)

                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                // show the alert
                self.present(alert, animated: true, completion: nil)
    }
}









