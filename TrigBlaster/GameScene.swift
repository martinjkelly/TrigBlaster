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
    
    override func didMoveToView(view: SKView) {
    
        size = view.bounds.size
        backgroundColor = SKColor(red: 94.0/255, green: 63.0/255, blue: 107.0/255, alpha: 1)
        
        playerSprite.position = CGPoint(x: size.width - 50, y: 60)
        addChild(playerSprite)
        
        startMonitoringAcceleration()
    }
    
    override func update(currentTime: NSTimeInterval) {
        
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
            
            let filterFactor = 0.75
            
            accelerometerX = acceleration.x * filterFactor + accelerometerX * (1 - filterFactor)
            accelerometerY = acceleration.y * filterFactor + accelerometerY * (1 - filterFactor)
        }
    }
    
    deinit {
        stopMonitoringAcceleration()
    }
    
}
