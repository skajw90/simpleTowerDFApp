//
//  Turrets.swift
//  Final_Project
//
//  Created by Jiwon Nam on 4/27/19.
//  Copyright © 2019 Jiwon Nam. All rights reserved.
//

import UIKit

protocol TurretClassDataSource {
    func getEnemies() -> [EnemyClass]
}

class TurretClass {
    var turret: Turret
    var turretImageView: TurretView
    var turretAngleSpeed: CGFloat
    var dataSource: TurretClassDataSource?
    
    init(turret: Turret, turretImageView: TurretView, turretAngleSpeed: CGFloat) {
        self.turret = turret
        self.turretImageView = turretImageView
        self.turretAngleSpeed = turretAngleSpeed
    }
    
    func autoTargeting() {
        let from = turretImageView.center
        var distance = CGFloat.infinity
        var targetCenter = CGPoint(x: from.x, y: 0)
        if turret.lockOnTarget && !turret.lockAimTo!.enemy.isDistroyed {
            targetCenter = turret.lockAimTo!.getCenterPoint()
            distance = (pow(from.x - targetCenter.x, 2) + pow(from.y - targetCenter.y, 2)).squareRoot()
        }
        else {
            let enemies = dataSource!.getEnemies()
            if enemies.count == 0 { return }
            for i in 0 ..< enemies.count {
                if enemies[i].enemy.isDistroyed {
                    continue
                }
                let curDistance = (pow(from.x - enemies[i].getCenterPoint().x, 2) + pow(from.y - enemies[i].getCenterPoint().y, 2)).squareRoot()
                    if distance > curDistance {
                        targetCenter = enemies[i].getCenterPoint()
                        distance = curDistance
                        turret.lockAimTo = enemies[i]
                    }
            }
        }
        if distance > turret.attackRange {
            turret.lockOnTarget = false
            return
        }
        let targetAngle = calcuateAngle(from: from, to: targetCenter, distance: distance)
        setTurretAngle(angleSpeed: CGFloat(turretAngleSpeed), targetAngle: targetAngle)
        turret.lockOnTarget = true
        
    }
    
    /// function for calculating angle with given parameter
    ///
    /// - Parameters:
    ///   - from: center of start point
    ///   - to: center of end point
    ///   - distance: distance between from and to
    /// - Returns: calculated angle
    func calcuateAngle(from: CGPoint, to: CGPoint, distance: CGFloat) -> CGFloat {
        let fromX = from.x
        let fromY = from.y
        let toX = to.x
        let toY = to.y
        var angle: CGFloat = 0
        if fromX >= toX {
            if fromY >= toY {
                angle = acos((fromY - toY) / distance)
                angle = 2 * CGFloat.pi - angle
            }
            else {
                angle = acos((toY - fromY) / distance)
                angle += CGFloat.pi
            }
        }
        else {
            if fromY >= toY {
                angle = acos((fromY - toY) / distance)
            }
            else {
                angle = acos((toY - fromY) / distance)
                angle = CGFloat.pi - angle
            }
        }
        return angle
    }
    
    /// set turret angle with given parameters
    ///
    /// - Parameters:
    ///   - angleSpeed: rotating speed of angle
    ///   - targetAngle: angle of target and turret
    ///   - turretAt: index of selected turret
    ///   - currentAngle: current turret angle
    func setTurretAngle(angleSpeed: CGFloat, targetAngle: CGFloat) {
        let currentAngle = CGFloat(turret.angle)
        var speed: CGFloat = (currentAngle - targetAngle)
        if speed < 0 { speed = -speed }
        // if same phase
        if speed > angleSpeed {
            speed = angleSpeed
        }
        if getPhaseNum(angle: currentAngle) == getPhaseNum(angle: targetAngle) {
            if currentAngle >= targetAngle {
                turret.angle -= speed
                turretImageView.turret.transform = turretImageView.turret.transform.rotated(by: -speed)
            }
            else {
                turret.angle += speed
                turretImageView.turret.transform = turretImageView.turret.transform.rotated(by: speed)
            }
        }
        else if (getPhaseNum(angle: currentAngle) == 1 && getPhaseNum(angle: targetAngle) == 4) || (getPhaseNum(angle: currentAngle) - getPhaseNum(angle: targetAngle) == 1) {
            turret.angle -= speed
            turretImageView.turret.transform = turretImageView.turret.transform.rotated(by: -speed)
        }
        else if (getPhaseNum(angle: currentAngle) == 4 && getPhaseNum(angle: targetAngle) == 1) || (getPhaseNum(angle: currentAngle) - getPhaseNum(angle: targetAngle) == -1) {
            turret.angle += speed
            turretImageView.turret.transform = turretImageView.turret.transform.rotated(by: speed)
        }
        else {
            if currentAngle >= CGFloat.pi {
                if targetAngle > currentAngle - CGFloat.pi {
                    turret.angle += speed
                    turretImageView.turret.transform = turretImageView.turret.transform.rotated(by: speed)
                }
                else {
                    turret.angle -= speed
                    turretImageView.turret.transform = turretImageView.turret.transform.rotated(by: -speed)
                }
            }
            else {
                if targetAngle > currentAngle + CGFloat.pi {
                    turret.angle -= speed
                    turretImageView.turret.transform = turretImageView.turret.transform.rotated(by: -speed)
                }
                else {
                    turret.angle += speed
                    turretImageView.turret.transform = turretImageView.turret.transform.rotated(by: speed)
                }
            }
        }
        
        if turret.angle < 0 { turret.angle += 2 * CGFloat.pi }
        if turret.angle > (CGFloat.pi * 2) {turret.angle -= CGFloat.pi * 2 }
    }
    
    /// helper function to calculate set angle
    ///
    /// - Parameter angle: angle of input
    /// - Returns: phase number
    func getPhaseNum(angle: CGFloat) -> Int {
        if angle >= 0 && angle <= CGFloat.pi / 2 { return 1 }
        if angle >= CGFloat.pi / 2 && angle <= CGFloat.pi { return 2 }
        if angle >= CGFloat.pi && angle <= CGFloat.pi * 3 / 2 { return 3 }
        return 4
    }
}
