//
//  ViewController.swift
//  TicTacToe
//
//  Created by Johnavan Thomas on 2019-03-20.
//  Copyright © 2019 Johnavan Thomas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet var drawView: DrawView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        drawView.viewController = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func gameOverPopup(winner: String) {
        var message: String
        if (winner == gameVar.e) { message = gameVar.draw }
        else { message = "\(winner) Wins!" }
        
        let alertController = UIAlertController(title: gameVar.gameOver, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: gameVar.dismiss, style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func invalidBoardPopup() {
        let alertController = UIAlertController(title: gameVar.error, message: gameVar.invalidBoard, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: gameVar.dismiss, style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
