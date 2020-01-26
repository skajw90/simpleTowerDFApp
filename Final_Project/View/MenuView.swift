//
//  MenuView.swift
//  Final_Project
//
//  Created by Jiwon Nam on 4/1/19.
//  Copyright © 2019 Jiwon Nam. All rights reserved.
//

import UIKit

protocol MenuViewDelegate {
    func popupView(selected: Int)
}

class MenuView: UIView {
    var delegate: MenuViewDelegate?
    
    lazy var itemViewBtn: ItemViewBtn = {
        let btn = ItemViewBtn()
        btn.tag = 0
        btn.setTitle("Item", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(btnHandler), for: UIControl.Event.touchDown)
        btn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(btn)
        return btn
    } ()
    
    lazy var rocketInfoBtn: RocketInfoBtn = {
        let btn = RocketInfoBtn()
        btn.tag = 1
        btn.setTitle("Rocket", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(btnHandler), for: UIControl.Event.touchDown)
        btn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(btn)
        return btn
    } ()
    
    lazy var shopViewBtn: ShopViewBtn = {
        let btn = ShopViewBtn()
        btn.tag = 2
        btn.setTitle("Shop", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(btnHandler), for: UIControl.Event.touchDown)
        btn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(btn)
        return btn
    } ()
    
    lazy var settingViewBtn: SettingViewBtn = {
        let btn = SettingViewBtn()
        btn.tag = 3
        btn.setTitle("Setting", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(btnHandler), for: UIControl.Event.touchDown)
        btn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(btn)
        return btn
    } ()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            itemViewBtn.heightAnchor.constraint(equalTo: self.heightAnchor),
            itemViewBtn.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25),
            itemViewBtn.leftAnchor.constraint(equalTo: self.leftAnchor),
            
            rocketInfoBtn.heightAnchor.constraint(equalTo: self.heightAnchor),
            rocketInfoBtn.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25),
            rocketInfoBtn.leftAnchor.constraint(equalTo: itemViewBtn.rightAnchor),
            
            shopViewBtn.heightAnchor.constraint(equalTo: self.heightAnchor),
            shopViewBtn.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25),
            shopViewBtn.leftAnchor.constraint(equalTo: rocketInfoBtn.rightAnchor),
            
            settingViewBtn.heightAnchor.constraint(equalTo: self.heightAnchor),
            settingViewBtn.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25),
            settingViewBtn.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }
    
    @objc func btnHandler(sender: Any) {
        let btn = sender as! UIButton
        switch btn.tag {
        case 0:
            print("itemView clicked")
        case 1:
            print("rocketInfoView clicked")
        case 2:
            print("shopView clicked")
        case 3:
            print("settingView clicked")
        default:
            break
        }
        delegate!.popupView(selected: btn.tag)
    }
}

// TODO: need to change ellipse CGRect
class ItemViewBtn: UIButton {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()!
        context.addEllipse(in: rect)
        context.setStrokeColor(UIColor.black.cgColor)
        context.drawPath(using: .stroke)
    }
}

class RocketInfoBtn: UIButton {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()!
        context.addEllipse(in: rect)
        context.setStrokeColor(UIColor.black.cgColor)
        context.drawPath(using: .stroke)
    }
}

class ShopViewBtn: UIButton {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()!
        context.addEllipse(in: rect)
        context.setStrokeColor(UIColor.black.cgColor)
        context.drawPath(using: .stroke)
    }
}

class SettingViewBtn: UIButton {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()!
        context.addEllipse(in: rect)
        context.setStrokeColor(UIColor.black.cgColor)
        context.drawPath(using: .stroke)
    }
}
