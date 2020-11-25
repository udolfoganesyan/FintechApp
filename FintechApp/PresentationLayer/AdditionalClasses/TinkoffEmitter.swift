//
//  TinkoffEmitter.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 25.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

final class TinkoffEmitter {
    
    static var shared = TinkoffEmitter()
    
    private let starParticle = TinkoffParticle()
    
    private lazy var particleEmitter: CAEmitterLayer = {
        let emitter = CAEmitterLayer()
        emitter.emitterShape = .point
        emitter.renderMode = .unordered
        emitter.emitterCells = [starParticle]
        return emitter
    }()
    
    private init() { }
    
    func setup(view: UIView, position: CGPoint) {
        view.layer.addSublayer(particleEmitter)
        particleEmitter.emitterPosition = position
    }
    
    func start() {
        particleEmitter.birthRate = 5
    }
    
    func stop() {
        particleEmitter.birthRate = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.particleEmitter.removeFromSuperlayer()
        }
    }
}

final class TinkoffParticle: CAEmitterCell {
    
    public override init() {
        super.init()
        self.birthRate = 2
        self.lifetime = 1.0
        self.velocity = 120
        self.velocityRange = 50
        self.emissionLongitude = 90
        self.emissionRange = .pi
        self.spinRange = 5
        self.scale = 0.08
        self.scaleRange = 0.02
        self.alphaSpeed = -1
        self.contents = UIImage(named: "tinkoffParticle")?.cgImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let app = UIApplication.shared.delegate as? AppDelegate,
           let window = app.window {
            if let touch = event?.touches(for: window)?.first {
                let position = touch.location(in: self)
                TinkoffEmitter.shared.setup(view: self, position: position)
                TinkoffEmitter.shared.start()
            }
        }
        super.touchesBegan(touches, with: event)
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let app = UIApplication.shared.delegate as? AppDelegate,
           let window = app.window {
            if let touch = event?.touches(for: window)?.first {
                let position = touch.location(in: self)
                TinkoffEmitter.shared.setup(view: self, position: position)
            }
        }
        super.touchesMoved(touches, with: event)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        TinkoffEmitter.shared.stop()
        super.touchesEnded(touches, with: event)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        TinkoffEmitter.shared.stop()
        super.touchesCancelled(touches, with: event)
    }
}

extension UIButton {
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let app = UIApplication.shared.delegate as? AppDelegate,
           let window = app.window {
            if let touch = event?.touches(for: window)?.first {
                let position = touch.location(in: self)
                TinkoffEmitter.shared.setup(view: self, position: position)
                TinkoffEmitter.shared.start()
            }
        }
        super.touchesBegan(touches, with: event)
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let app = UIApplication.shared.delegate as? AppDelegate,
           let window = app.window {
            if let touch = event?.touches(for: window)?.first {
                let position = touch.location(in: self)
                TinkoffEmitter.shared.setup(view: self, position: position)
            }
        }
        super.touchesMoved(touches, with: event)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        TinkoffEmitter.shared.stop()
        super.touchesEnded(touches, with: event)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        TinkoffEmitter.shared.stop()
        super.touchesCancelled(touches, with: event)
    }
}
