//
//  EnemyClass.swift
//  Final_Project
//
//  Created by Jiwon Nam on 4/27/19.
//  Copyright © 2019 Jiwon Nam. All rights reserved.
//

import UIKit

class EnemyClass {
    var enemy: Enemy
    var enemyImage: UIImageView
    var yStart: CGFloat
    
    init(enemy: Enemy, enemyImage: UIImageView, yStart: CGFloat) {
        self.enemy = enemy
        self.enemyImage = enemyImage
        self.yStart = yStart
    }
    
    func autoMove(to: CGPoint) {
        // move straight temporary
        
        enemyImage.center.x += to.x
        enemyImage.center.y += to.y
    }
    
    func getCenterPoint() -> CGPoint {
        return CGPoint(x: enemyImage.center.x, y: yStart + enemyImage.center.y)
    }
    // TODO: set collision, set move direction
    
}
