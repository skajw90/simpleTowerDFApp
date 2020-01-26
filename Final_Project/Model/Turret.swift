//
//  Turrets.swift
//  Final_Project
//
//  Created by Jiwon Nam on 4/27/19.
//  Copyright © 2019 Jiwon Nam. All rights reserved.
//

import UIKit

struct Turret {
    var name: String = ""
    var attackPower = 1
    var attackSpeed = 1
    var attackRange: CGFloat = 200
    var lockOnTarget: Bool = false
    var lockAimTo: EnemyClass?
    var price: Int = 0
    var angle: CGFloat = 0
    var bullets: [BulletClass] = []
}
