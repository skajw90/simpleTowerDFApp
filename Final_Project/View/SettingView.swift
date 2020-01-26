//
//  SettingView.swift
//  Final_Project
//
//  Created by Jiwon Nam on 4/1/19.
//  Copyright © 2019 Jiwon Nam. All rights reserved.
//

import UIKit

protocol SettingViewDelegate {
    func closeItemView()
}

class SettingView: UIView {
    var delegate: SettingViewDelegate?
    
    lazy var content: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    } ()
    
    lazy var exitBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .focused)
        button.setTitle("X", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonHandler), for: UIControl.Event.touchDown)
        addSubview(button)
        return button
    } ()
    
    @objc func buttonHandler(sender: Any) {
        delegate!.closeItemView()
    }
}
