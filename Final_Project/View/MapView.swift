//
//  MapView.swift
//  Final_Project
//
//  Created by Jiwon Nam on 4/20/19.
//  Copyright © 2019 Jiwon Nam. All rights reserved.
//

import UIKit

protocol MapViewDelegate {
    func getTile(x: Int, y: Int) -> UIImageView
    func getTurretSize() -> CGPoint
}
// 20 x 10 map
class MapView: UIView {
    var delegate: MapViewDelegate?
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        for y in 0 ..< 10 {
            for x in 0 ..< 20 {
                let imageView = delegate!.getTile(x: x, y: y)
                imageView.frame = CGRect(x: CGFloat(x) * bounds.width * 0.05, y: CGFloat(y) * bounds.height * 0.1, width: delegate!.getTurretSize().x / 2, height: delegate!.getTurretSize().y / 2)
                
                addSubview(imageView)
            }
        }
    }
}
