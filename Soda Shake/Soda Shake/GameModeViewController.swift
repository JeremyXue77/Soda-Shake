//
//  GameModeViewController.swift
//  Soda Shake
//
//  Created by JeremyXue on 2018/11/10.
//  Copyright © 2018 JeremyXue. All rights reserved.
//

import UIKit

class GameModeViewController: UIViewController {
    
    var firstLoad = true
    
    var helloLanguages = ["Hello", "你好","Bonjour","여보세요","こんにちは","Hola"]
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var sodaButton: UIButton!
    
    @IBAction func spinSoda(_ sender: UIButton) {
        let randomIndex = Int(arc4random_uniform(UInt32(helloLanguages.count)))
        UIView.animate(withDuration: 0.4, animations: {
            sender.transform = CGAffineTransform(rotationAngle: .pi)
            sender.transform = CGAffineTransform.identity
        }) { (_) in
            UIView.animate(withDuration: 0.4, animations: {
                self.messageLabel.alpha = 1
                self.messageLabel.text = "\(self.helloLanguages[randomIndex])！"
            }, completion: { (_) in
                UIView.animate(withDuration: 0.4, animations: {
                    self.messageLabel.alpha = 0
                })
            })
        }
    }
    
    @IBAction func startSingleGame(_ sender: Any) {
        performSegue(withIdentifier: "goToGame", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.alpha = 0
        messageLabel.transform = CGAffineTransform(rotationAngle: .pi / 10)
        sodaButton.transform = CGAffineTransform(translationX: -view.bounds.width, y: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if firstLoad {
            UIView.animate(withDuration: 1.6) {
                self.sodaButton.transform = .identity
                self.sodaButton.transform = CGAffineTransform(rotationAngle: .pi)
                self.sodaButton.transform = .identity
            }
            firstLoad = false
        }
    }
}
