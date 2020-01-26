//
//  BulletClass.swift
//  Final_Project
//
//  Created by Jiwon Nam on 4/29/19.
//  Copyright © 2019 Jiwon Nam. All rights reserved.
//

import UIKit

class BulletClass {
    var bullet: Bullet
    var bulletImage: UIImageView
    
    init(bullet: Bullet, bulletImage: UIImageView) {
        self.bullet = bullet
        self.bulletImage = bulletImage
    }
}
