//
//  turretInfoView.swift
//  Final_Project
//
//  Created by Jiwon Nam on 4/29/19.
//  Copyright © 2019 Jiwon Nam. All rights reserved.
//

import UIKit

class TurretInfoView: UIView {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        return imageView
    } ()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.makeOutLine(oulineColor: .blue, foregroundColor: .white)
        label.font = label.font.withSize(20)
        label.textAlignment = .center
        label.numberOfLines = 0;
        addSubview(label)
        return label
    } ()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        (imageView.frame, infoLabel.frame) = bounds.divided(atDistance: bounds.maxY / 2, from: .minYEdge)
    }
}
