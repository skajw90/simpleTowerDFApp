//
//  StageInfoView.swift
//  Final_Project
//
//  Created by Jiwon Nam on 4/18/19.
//  Copyright © 2019 Jiwon Nam. All rights reserved.
//

import UIKit

protocol StageInfoViewDelegate {
    func startGame()
    func goBackToLobby()
}

class StageInfoView: UIView {
    var delegate: StageInfoViewDelegate?
    lazy var wrap: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    } ()
    lazy var topView: MapView = {
        let view = MapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    } ()
    
    lazy var bottom: BottomView = {
        let btn = BottomView()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = #colorLiteral(red: 0.3754182437, green: 0.6216373465, blue: 1, alpha: 1)
        btn.setTitle("start", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(startGame), for: UIControl.Event.touchDown)
        addSubview(btn)
        return btn
    } ()
    
    @objc func startGame(sender: Any) {
        print("start game!")
        delegate!.startGame()
    }
    
    var touchPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let touch: UITouch = touches.first!
        touchPoint = touch.location(in: self)
        
        let diffX = self.bounds.maxX / 2 - wrap.bounds.maxX / 2
        let diffY = self.bounds.maxY / 2 - wrap.bounds.maxY / 2
        if touchPoint.x < wrap.bounds.minX + diffX || touchPoint.x > wrap.bounds.maxX + diffX || touchPoint.y < wrap.bounds.minY + diffY || touchPoint.y > wrap.bounds.maxY + diffY {
            delegate!.goBackToLobby()
        }
        else { return }
    }
}

class BottomView: UIButton {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
}
