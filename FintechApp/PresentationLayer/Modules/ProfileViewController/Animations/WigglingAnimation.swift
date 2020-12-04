//
//  WigglingAnimation.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 22.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

final class WigglingAnimation: CAAnimationGroup {
    
    override init() {
        super.init()
        
        let angle: CGFloat = 18 * .pi / 180
        
        let rotate = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotate.values = [-angle, 0, angle]
        rotate.autoreverses = true
        rotate.duration = 0.15
        rotate.keyTimes = [0, 0.5, 1]
        rotate.repeatCount = Float.infinity
        
        let jump = CAKeyframeAnimation(keyPath: "transform.translation.y")
        jump.values = [0, 5.0, 0.0, -5.0]
        jump.autoreverses = true
        jump.duration = 0.15
        jump.keyTimes = [0, 0.4, 0.8, 1.0]
        jump.repeatCount = Float.infinity
        
        let move = CAKeyframeAnimation(keyPath: "transform.translation.x")
        move.values = [0, 5.0, 0.0, -5.0]
        move.autoreverses = true
        move.duration = 0.15
        move.keyTimes = [0, 0.4, 0.8, 1.0]
        move.repeatCount = Float.infinity
        
        self.duration = 0.3
        self.repeatCount = .infinity
        self.autoreverses = true
        self.animations = [rotate, jump, move]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
