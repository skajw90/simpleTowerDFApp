//
//  TurretView.swift
//  Final_Project
//
//  Created by Jiwon Nam on 4/25/19.
//  Copyright © 2019 Jiwon Nam. All rights reserved.
//

import UIKit

class TurretView: UIView {
    lazy var turret: UIImageView = {
        let imageView = UIImageView()
        addSubview(imageView)
        return imageView
    } ()
    
    lazy var turretBackground: TurretBackgroundView = {
        let view = TurretBackgroundView()
        addSubview(view)
        return view
    } ()
}

class TurretBackgroundView: UIView {
    lazy var cell1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        addSubview(view)
        return view
    } ()
    let cell2 = UIView()
    let cell3 = UIView()
    let cell4 = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        cell2.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cell2)
        cell3.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cell3)
        cell4.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cell4)
        
        NSLayoutConstraint.activate([
            cell1.topAnchor.constraint(equalTo: self.topAnchor),
            cell1.rightAnchor.constraint(equalTo: self.rightAnchor),
            cell1.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            cell1.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            cell2.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            cell2.rightAnchor.constraint(equalTo: self.rightAnchor),
            cell2.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            cell2.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            cell3.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            cell3.leftAnchor.constraint(equalTo: self.leftAnchor),
            cell3.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            cell3.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            cell4.topAnchor.constraint(equalTo: self.topAnchor),
            cell4.leftAnchor.constraint(equalTo: self.leftAnchor),
            cell4.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            cell4.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setRedFor(cellNum: Int) {
        if cellNum == 1 { cell1.backgroundColor = .red }
        else if cellNum == 2 { cell2.backgroundColor = .red }
        else if cellNum == 3 { cell3.backgroundColor = .red }
        else { cell4.backgroundColor = .red }
    }
    func setGreenFor(cellNum: Int) {
        if cellNum == 1 { cell1.backgroundColor = .green }
        else if cellNum == 2 { cell2.backgroundColor = .green }
        else if cellNum == 3 { cell3.backgroundColor = .green }
        else { cell4.backgroundColor = .green }
    }
    func allColorClear() {
        cell1.backgroundColor = .clear
        cell2.backgroundColor = .clear
        cell3.backgroundColor = .clear
        cell4.backgroundColor = .clear
    }
}
