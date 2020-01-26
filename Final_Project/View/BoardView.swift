//
//  BoardView.swift
//  Final_Project
//
//  Created by Jiwon Nam on 4/19/19.
//  Copyright © 2019 Jiwon Nam. All rights reserved.
//

import UIKit

class BoardView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawGridLines()
    }
    
    func drawGridLines() {
        let context = UIGraphicsGetCurrentContext()!
        for y in 0 ..< 11 {
            context.move(to: CGPoint(x: 0, y: CGFloat(y) * bounds.height * 0.1))
            context.addLine(to: CGPoint(x: bounds.width, y: CGFloat(y) * bounds.height * 0.1))
        }
        for x in 0 ..< 21 {
            context.move(to: CGPoint(x: CGFloat(x) * bounds.width * 0.05, y: 0))
            context.addLine(to: CGPoint(x: CGFloat(x) * bounds.width * 0.05, y: bounds.height))
        }
        context.setLineDash(phase: 0, lengths: [5])
        context.setStrokeColor(UIColor.white.cgColor)
        context.drawPath(using: .stroke)
    }
}
