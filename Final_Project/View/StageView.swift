//
//  StageView.swift
//  Final_Project
//
//  Created by Jiwon Nam on 4/1/19.
//  Copyright © 2019 Jiwon Nam. All rights reserved.
//

import UIKit

protocol StageViewDelegate {
    func showSelectedStageInfo(section: Int)
}

class StageView: UIView {
    var delegate: StageViewDelegate?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        for i in 0 ..< 3 {
            let button = UIButton()
            let label = UILabel()
            button.frame = CGRect(x: 0, y: 0, width: bounds.maxX / 10, height: bounds.maxX / 10)
            button.center = CGPoint(x: bounds.maxX * (CGFloat(i)) * 0.3 + bounds.maxX * 0.2, y: bounds.maxY * 0.4)
            label.frame = CGRect(x: 0, y: 0, width: button.bounds.width, height: button.bounds.height / 2)
            label.center = CGPoint(x: button.center.x * 1, y: button.center.y - bounds.maxX / 15)
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.text = "stage \(i + 1)"
            label.makeOutLine(oulineColor: .red, foregroundColor: .black)
            button.addTarget(self, action: #selector(showInfo), for: UIControl.Event.touchDown)
            button.tag = i
            let image = UIImage(named: "stage")
            button.setImage(image, for: .normal)
            addSubview(button)
            addSubview(label)
        }
    }
    
    @objc func showInfo(sender: Any) {
        let selected = sender as! UIButton
        delegate!.showSelectedStageInfo(section: selected.tag)
    }
}

