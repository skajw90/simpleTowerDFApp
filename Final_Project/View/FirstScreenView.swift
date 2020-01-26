//
//  FirstScreenView.swift
//  Final_Project
//
//  Created by Jiwon Nam on 4/1/19.
//  Copyright © 2019 Jiwon Nam. All rights reserved.
//

import UIKit

class FirstScreenView: UIView {
    
    lazy var firstScreenView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        self.addSubview(view)
        return view
    } ()
    
    lazy var gameLabel: UILabel = {
        let label = UILabel()
        label.text = "JIWON'S GAME"
        label.textColor = .white
        label.makeOutLine(oulineColor: .black, foregroundColor: .white)
        label.font = label.font.withSize(50)
        label.font = UIFont.italicSystemFont(ofSize: 50)
        label.textAlignment = .center
        self.addSubview(label)
        return label
    } ()
    
    lazy var touchScreenLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(25)
        label.text = "Touch to start Game"
        label.makeOutLine(oulineColor: .black, foregroundColor: .white)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        self.addSubview(label)
        return label
    } ()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        firstScreenView.frame = bounds
        let image = UIImage(named: "background")
        let imageView = UIImageView(image: image)
        imageView.frame = firstScreenView.frame
        firstScreenView.addSubview(imageView)
        var rect = bounds
        (gameLabel.frame, rect) = rect.divided(atDistance: frame.height * 0.7, from: .minYEdge)
        touchScreenLabel.frame = rect
        bringSubviewToFront(touchScreenLabel)
    }
}

extension UILabel{
    
    func makeOutLine(oulineColor: UIColor, foregroundColor: UIColor) {
        let strokeTextAttributes = [
            NSAttributedString.Key.strokeColor : oulineColor,
            NSAttributedString.Key.foregroundColor : foregroundColor,
            NSAttributedString.Key.strokeWidth : -4.0,
            NSAttributedString.Key.font : self.font ?? 10
            ] as [NSAttributedString.Key : Any]
        self.attributedText = NSMutableAttributedString(string: self.text ?? "", attributes: strokeTextAttributes)
    }
    
}
