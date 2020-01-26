//
//  StageViewController.swift
//  Final_Project
//
//  Created by Jiwon Nam on 4/1/19.
//  Copyright © 2019 Jiwon Nam. All rights reserved.
//

import UIKit

protocol StageInfoViewControllerDelegate {
    func showSelectedStageInfo(section: Int)
    func startGame(_ stageInfoViewController: StageInfoViewController)
    func exitStageInfoView(_ stageInfoViewController: StageInfoViewController)
}

class StageInfoViewController: UIViewController, StageInfoViewDelegate, MapViewDelegate {
    var delegate: StageInfoViewControllerDelegate?
    var map: [[Int]] = []
    
    /// get tile image
    ///
    /// - Parameters:
    ///   - x: column
    ///   - y: row
    /// - Returns: UIImageView
    func getTile(x: Int, y: Int) -> UIImageView {
        var image: UIImage
        if map[y][x] == 1 { image = UIImage(named: "water")! }
        else { image = UIImage(named: "grass")! }
        let imageView = UIImageView(image: image)
        return imageView
    }
    
    func getTurretSize() -> CGPoint {
        let size = CGPoint(x: stageInfoView.topView.bounds.width / 10, y: stageInfoView.topView.bounds.width / 5)
        return size
    }
    
    var stageInfoView: StageInfoView {
        return view as! StageInfoView
    }
    
    override func loadView() {
        super.loadView()
        view = StageInfoView()
        setConstraint()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stageInfoView.topView.delegate = self
    }
    
    func setConstraint() {
        view.frame = parent!.view.bounds
        NSLayoutConstraint.activate([
            stageInfoView.wrap.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stageInfoView.wrap.centerYAnchor.constraint(equalTo: stageInfoView.centerYAnchor),
            stageInfoView.wrap.widthAnchor.constraint(equalTo: stageInfoView.widthAnchor, multiplier: 0.6),
            stageInfoView.wrap.heightAnchor.constraint(equalTo: stageInfoView.heightAnchor, multiplier: 0.6),
            stageInfoView.topView.topAnchor.constraint(equalTo: stageInfoView.wrap.topAnchor),
            stageInfoView.topView.widthAnchor.constraint(equalTo: stageInfoView.wrap.widthAnchor),
            stageInfoView.topView.leftAnchor.constraint(equalTo: stageInfoView.wrap.leftAnchor),
            stageInfoView.topView.heightAnchor.constraint(equalTo: stageInfoView.wrap.heightAnchor, multiplier: 0.8),
            stageInfoView.bottom.topAnchor.constraint(equalTo: stageInfoView.topView.bottomAnchor),
            stageInfoView.bottom.widthAnchor.constraint(equalTo: stageInfoView.wrap.widthAnchor),
            stageInfoView.bottom.leftAnchor.constraint(equalTo: stageInfoView.wrap.leftAnchor),
            stageInfoView.bottom.bottomAnchor.constraint(equalTo: stageInfoView.wrap.bottomAnchor)
            ])
        stageInfoView.delegate = self
    }
    
    func startGame() {
        delegate!.startGame(self)
    }
    
    func goBackToLobby() {
        delegate!.exitStageInfoView(self)
    }
}
