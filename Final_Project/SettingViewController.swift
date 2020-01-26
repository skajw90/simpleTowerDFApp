//
//  SettingViewController.swift
//  Final_Project
//
//  Created by Jiwon Nam on 4/11/19.
//  Copyright © 2019 Jiwon Nam. All rights reserved.
//

import UIKit

protocol SettingViewControllerDelegate {
    
}

class SettingViewController: UIViewController, SettingViewDelegate {
    var delegate: SettingViewControllerDelegate?
    
    var settingView: SettingView {
        return view as! SettingView
    }
    
    override func loadView() {
        view = SettingView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startItemView()
    }
    
    func startItemView() {
        view.frame = parent!.view.bounds
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        NSLayoutConstraint.activate([
                settingView.content.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                settingView.content.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
                settingView.content.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                settingView.content.widthAnchor.constraint(equalTo: view.widthAnchor),
                settingView.exitBtn.rightAnchor.constraint(equalTo: view.rightAnchor),
                settingView.exitBtn.topAnchor.constraint(equalTo: view.topAnchor),
                settingView.exitBtn.bottomAnchor.constraint(equalTo: settingView.content.topAnchor),
                settingView.exitBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.05)
            ])
        settingView.delegate = self
    }
    
    func closeItemView() {
        print("close itemView")
        self.remove()
    }
}
