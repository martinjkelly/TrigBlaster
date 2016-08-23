//
//  GameScene.swift
//  TrigBlaster
//
//  Created by Martin Kelly on 23/08/2016.
//  Copyright (c) 2016 Scriptable Ltd. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene {

    // MARK: CoreMotion
    var accelerometerX: UIAccelerationValue = 0
    var accelerometerY: UIAccelerationValue = 0
    let motionManager = CMMotionManager()
    
    // MARK: Sprites
    let playerSprite = SKSpriteNode(imageNamed: "Player")
    
    var playerAcceleration = CGVector(dx: 0, dy: 0)
    var playerVelocity = CGVector(dx: 0, dy: 0)
    
    let MaxPlayerAcceleration: CGFloat = 400
    let MaxPlayerSpeed: CGFloat = 200
    var lastUpdateTime: CFTimeInterval = 0
    
    override func didMoveToView(view: SKView) {
    
        size = view.bounds.size
        backgroundColor = SKColor(red: 94.0/255, green: 63.0/255, blue: 107.0/255, alpha: 1)
        
        playerSprite.position = CGPoint(x: size.width - 50, y: 60)
        addChild(playerSprite)
        
        startMonitoringAcceleration()
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        // to compute velocities we need delta time to multiply by points per second
        // SpriteKit returns the currentTime, delta is computed as last called time - currentTime
        let deltaTime = max(1.0/30, currentTime - lastUpdateTime)
        lastUpdateTime = currentTime
        
        updatePlayerAccelerationFromMotionManager()
        updatePlayer(deltaTime)
    }
    
    func updatePlayer(dt: CFTimeInterval) {
        
        // 1
        playerVelocity.dx = playerVelocity.dx + playerAcceleration.dx * CGFloat(dt)
        playerVelocity.dy = playerVelocity.dy + playerAcceleration.dy * CGFloat(dt)
        
        // 2
        playerVelocity.dx = max(-MaxPlayerSpeed, min(MaxPlayerSpeed, playerVelocity.dx))
        playerVelocity.dy = max(-MaxPlayerSpeed, min(MaxPlayerSpeed, playerVelocity.dy))
        
        // 3
        var newX = playerSprite.position.x + playerVelocity.dx * CGFloat(dt)
        var newY = playerSprite.position.y + playerVelocity.dy * CGFloat(dt)
        
        // 4
        newX = min(size.width, max(0, newX));
        newY = min(size.height, max(0, newY));
        
        playerSprite.position = CGPoint(x: newX, y: newY)
    }
    
    func startMonitoringAcceleration() {
        
        if motionManager.accelerometerAvailable {
            motionManager.startAccelerometerUpdates()
            print("accelerometer updates on")
        }
    }
    
    func stopMonitoringAcceleration() {
        
        if motionManager.accelerometerAvailable && motionManager.accelerometerActive {
            motionManager.stopAccelerometerUpdates()
            print("accelerometer updates off")
        }
    }
    
    func updatePlayerAccelerationFromMotionManager() {
        
        if let acceleration = motionManager.accelerometerData?.acceleration {
            
            let FilterFactor = 0.75
            
            print("PREVIOUS VALUE", accelerometerX, accelerometerY)
            print("UNFILTERED", acceleration.x, acceleration.y)
            
            accelerometerX = acceleration.x * FilterFactor + accelerometerX * (1 - FilterFactor)
            accelerometerY = acceleration.y * FilterFactor + accelerometerY * (1 - FilterFactor)
            
            print("NEW VALUE", accelerometerX, accelerometerY)
            
            playerAcceleration.dx = CGFloat(accelerometerY) * -MaxPlayerAcceleration
            playerAcceleration.dy = CGFloat(accelerometerX) * MaxPlayerAcceleration
        }
    }
    
    deinit {
        stopMonitoringAcceleration()
    }
    
}
