//
//  LobbyView.swift
//  Final_Project
//
//  Created by Jiwon Nam on 4/1/19.
//  Copyright © 2019 Jiwon Nam. All rights reserved.
//

import UIKit

class LobbyView: UIView {
    lazy var menuView: MenuView = {
        let view = MenuView()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        return view
    } ()
    
    lazy var stageView: StageView = {
        let view = StageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        return view
    } ()
    
    lazy var coinInfoView: CoinInfoView = {
        let view = CoinInfoView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        return view
    } ()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let image = UIImage(named: "lobbyBackground")
        let imageView = UIImageView(image: image)
        imageView.frame = stageView.frame
        stageView.addSubview(imageView)
    }
}
