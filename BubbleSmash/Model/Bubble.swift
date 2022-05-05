//
//  Bubble.swift
//  BubbleSmash
//
//  Created by Zach Clare on 26/4/2022.
//

import UIKit

class Bubble: UIButton {
    
    // value of the bubble
    var score: Int = 0
    
    init(area: CGRect) {
    
        super.init(frame: area)
        
        // used for probabilities
        let value: Int = Int.random(in: 1...100)
        
        // set the bubble's score and colour based on the probability
        if 0...40 ~= value {
            self.backgroundColor = .systemRed
            self.score = 1
        } else if 41...70 ~= value  {
            self.backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0.7, alpha: 1.0) // add a custom colour because the system pink sucks
            self.score = 2
        } else if 71...85 ~= value {
            self.backgroundColor = .systemGreen
            self.score = 5
        } else if 86...95 ~= value {
            self.backgroundColor = .systemBlue
            self.score = 8
        } else {
            self.backgroundColor = .black
            self.score = 10
        }
        
        // round the bubble
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // animation for the bubble spawning in
    func animation() {
        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
        springAnimation.duration = 0.6
        springAnimation.fromValue = 1
        springAnimation.toValue = 0.8
        springAnimation.repeatCount = 1
        springAnimation.initialVelocity = 0.5
        springAnimation.damping = 1
        
        layer.add(springAnimation, forKey: nil)
    }
    
    func flash() {
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        
        layer.add(flash, forKey: nil)
    }
    
}

