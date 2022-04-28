//
//  Bubble.swift
//  BubbleSmash
//
//  Created by Zach Clare on 26/4/2022.
//

import UIKit

class Bubble: UIButton {
    
    let xPosition = Int.random(in: 20...400)
    let yPosition = Int.random(in: 20...800)
    
    init(area: UIView) {
        print(area.frame.size)
        super.init(frame: area.frame)
        self.backgroundColor = .red
    }
    
//     override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        //self.frame = area.frame
//        self.backgroundColor = .red
//        self.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        self.layer.cornerRadius = 0.5 * self.bounds.size.width
//    }
//

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
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

