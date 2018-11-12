//
//  ViewController.swift
//  Soda Shake
//
//  Created by JeremyXue on 2018/11/7.
//  Copyright © 2018 JeremyXue. All rights reserved.
//

import UIKit

enum GameMode {
    case singlePlayer
    case multiPlayer
}

class GameViewController: UIViewController {
    
    var players = [String]()
    var gamemode = GameMode.singlePlayer
    var targetPoint = Int(arc4random_uniform(50) + 51) {
        didSet {
            print(targetPoint)
            if targetPoint > 3 {
                if shakingTimer != nil {
                    shakingTimer?.invalidate()
                    shakingTimer = nil
                }
                
                if shakingTimer == nil {
                    var repeatCount = 1
                    shakingTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true, block: { (timer) in
                        repeatCount -= 1
                        if repeatCount < 0 {
                            if self.bubbleTimer != nil {
                                self.bubbleTimer?.invalidate()
                                self.bubbleTimer = nil
                                self.shakingTimer?.invalidate()
                                self.shakingTimer = nil
                            }
                        }
                    })
                }
                
                if bubbleTimer == nil {
                    bubbleTimer = bubbleEffectAnimation(timeInterval: 0)
                    bubbleTimer?.fire()
                }
            } else {
                gameOver()
            }
        }
    }
    lazy var defaultTimer = bubbleEffectAnimation(timeInterval: 0.1)
    var shakingTimer: Timer?
    var bubbleTimer: Timer?
    
    @IBOutlet weak var sodaButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton! {
        didSet {
            if gamemode == .singlePlayer {
                playButton.setTitle("Start", for: .normal)
            } else {
                playButton.setTitle("Next Player", for: .normal)
            }
        }
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        
    }
    
    @IBAction func exit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingParallaxEffect(sodaButton)
        defaultTimer.fire()
        playButton.isHidden = true
        
        if gamemode == .singlePlayer {
            targetPoint = 100
        } else {
            targetPoint = Int(arc4random_uniform(50) + 51)
        }
    }
    
    func sodaShakeAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = -Double.pi / 6
        animation.toValue = Double.pi / 6
        animation.duration = 0.2
        animation.autoreverses = true
        animation.repeatCount = 5
        sodaButton.layer.add(animation, forKey: "shakeAnimation")
    }
    
    func settingParallaxEffect(_ view: UIView) {
        let horizonValue = view.bounds.width
        let verticalValue = view.bounds.height
        
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -horizonValue
        horizontal.maximumRelativeValue = horizonValue
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -verticalValue
        vertical.maximumRelativeValue = verticalValue
        
        let motionGroup = UIMotionEffectGroup()
        motionGroup.motionEffects = [horizontal, vertical]
        view.addMotionEffect(motionGroup)
    }
    
    func makeBubble() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bubble")
        let randomXPosition = CGFloat(arc4random_uniform(UInt32(view.bounds.width)))
        let randomSize = CGFloat(arc4random_uniform(3) + 1) * 10
        imageView.frame = CGRect(x: randomXPosition, y: view.frame.maxY, width: randomSize, height: randomSize)
        imageView.alpha = 0.7
        imageView.tintColor = .white
        return imageView
    }
    
    func bubbleEffectAnimation(timeInterval: TimeInterval) -> Timer {
        let timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { (timer) in
            let bubbleImageView = self.makeBubble()
            self.view.addSubview(bubbleImageView)
            let randomDuration = Double(arc4random_uniform(5) + 1) * 0.4
            UIView.animate(withDuration: randomDuration, delay: 0, options: [.curveEaseIn], animations: {
                bubbleImageView.center.y -= self.view.bounds.height + bubbleImageView.bounds.height
            }, completion: { (_) in
                bubbleImageView.removeFromSuperview()
            })
        }
        
        return timer
    }
    
    func gameOver() {
        let timer = bubbleEffectAnimation(timeInterval: 0)
        timer.fire()
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = -Double.pi / 6
        animation.toValue = Double.pi / 6
        animation.duration = 0.1
        animation.autoreverses = true
        animation.repeatCount = .infinity
        sodaButton.layer.add(animation, forKey: "shakeAnimation")
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            sodaShakeAnimation()
            print("Shake began")
            targetPoint -= 3
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            sodaShakeAnimation()
            print("Shake ended")
            targetPoint -= 3
        }
    }
    
}


