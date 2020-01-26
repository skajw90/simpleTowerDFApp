//
//  GameView.swift
//  Final_Project
//
//  Created by Jiwon Nam on 4/1/19.
//  Copyright © 2019 Jiwon Nam. All rights reserved.
//

import UIKit

protocol GameViewDelegate {
    func exitGameView()
    func getTurretSize() -> CGPoint
    func setCurrentTurret(turret: Turret, view: TurretView)
    func getCurrentTurret() -> TurretView
    func removeCurrentTurret()
    func setCurrentInstallState(state: Bool)
    func checkValidArea(x: CGFloat, y: CGFloat) -> [Int]
}

class GameView: UIView {
    var delegate: GameViewDelegate?
    var draggingOriginalLocation: CGPoint = CGPoint(x: 0, y: 0)
    var isInstalling: Bool = false
    var curGesture: UIPanGestureRecognizer?
    
    /// stage label
    lazy var stageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    } ()
    
    /// turret list view
    lazy var turretListView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        addSubview(view)
        return view
    } ()
    
    // coin info view
    lazy var coinInfoView: CoinInfoView = {
        let coinInfoView = CoinInfoView()
        coinInfoView.backgroundColor = .lightGray
        coinInfoView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(coinInfoView)
        return coinInfoView
    } ()
    
    /// main view
    lazy var mainView: MapView = {
        let view = MapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    } ()
    
    /// board view
    lazy var boardView: BoardView = {
        let view = BoardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    /// exit button for game view
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
    
    /// turret type1
    lazy var turret_type1: UIImageView = {
        let image = UIImage(named: "turret1")
        let imageView = UIImageView(image: image)
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(createNewDrag))
        imageView.tag = 0
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(gesture)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        return imageView
    } ()

    /// turret type2
    lazy var turret_type2: UIImageView = {
        let image = UIImage(named: "turret2")
        let imageView = UIImageView(image: image)
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(createNewDrag))
        imageView.tag = 1
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(gesture)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        return imageView
    } ()
    
    /// turret type3
    lazy var turret_type3: UIImageView = {
        let image = UIImage(named: "turret3")
        let imageView = UIImageView(image: image)
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(createNewDrag))
        imageView.tag = 2
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(gesture)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        return imageView
    } ()

    
    /// turret type4
    lazy var turret_type4: UIImageView = {
        let image = UIImage(named: "turret4")
        let imageView = UIImageView(image: image)
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(createNewDrag))
        imageView.tag = 3
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(gesture)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        return imageView
    } ()
    
    /// Confirm button
    let confirmBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("V", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        return btn
    } ()
    
    
    /// Cancel button
    let cancelBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("X", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        return btn
    } ()
    
    /// First touch of gestureRecognizer in turret lists
    /// it will generate new turret, and handle the turret with another gesture
    ///
    /// - Parameter gestureRecognizer: UIPanGestureRecognizer
    @objc func createNewDrag(_ gestureRecognizer: UIPanGestureRecognizer) {
        delegate!.setCurrentInstallState(state: true)
        if isInstalling { return }
        if let curGesture = curGesture { if curGesture != gestureRecognizer { return }}
        else { curGesture = gestureRecognizer }
        let translation = gestureRecognizer.translation(in: self)
        let gridBound = delegate!.getTurretSize()
        if gestureRecognizer.state == .began {
            setTurretBeganMove(gridBound: gridBound)
        }
        let curTurret = delegate!.getCurrentTurret()
        setTurretMove(curTurret: curTurret, translation: translation, gridBound: gridBound)
        
        if gestureRecognizer.state == .ended {
            isInstalling = true
            // show confirm and cancel button
            let rocketGesture = UIPanGestureRecognizer(target: self, action: #selector(continueDragged))
            curTurret.isUserInteractionEnabled = true
            curTurret.addGestureRecognizer(rocketGesture)
            if !setTurretEndMove(curTurret: curTurret) { return }
        }
        gestureRecognizer.setTranslation(CGPoint.zero, in: self)
    }
    
    
    /// gestureReconizer handler to allow user dragging object within specific area
    /// not allow to install turret if selected area has object or path
    /// otherwise, allow to install turret
    ///
    /// - Parameter gestureRecognizer: gestureRecongnizer
    @objc func continueDragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: self)
        let gridBound = delegate!.getTurretSize()
        let curTurret = delegate!.getCurrentTurret()
        if gestureRecognizer.state == .began {
            confirmBtn.removeFromSuperview()
            cancelBtn.removeFromSuperview()
        }
        setTurretMove(curTurret: curTurret, translation: translation, gridBound: gridBound)
        if gestureRecognizer.state == .ended {
            if !setTurretEndMove(curTurret: curTurret) { return }
        }
        gestureRecognizer.setTranslation(CGPoint.zero, in: self)
    }
    
    /// Confirm installing turret
    ///
    /// - Parameter sender: button object
    @objc func confirmRocket(sender: Any) {
        let curTurret = delegate!.getCurrentTurret()
        curTurret.turretBackground.allColorClear()
        curTurret.alpha = 1
        curTurret.gestureRecognizers!.removeAll()
        boardView.removeFromSuperview()
        confirmBtn.removeFromSuperview()
        cancelBtn.removeFromSuperview()
        isInstalling = false
        curGesture = nil
        curTurret.turretBackground.removeFromSuperview()
        delegate!.setCurrentInstallState(state: false)
    }
    
    
    /// Dismiss installing Turret button Handler
    ///
    /// - Parameter sender: button object
    @objc func cancelInstallingTurret(sender: Any) {
        delegate!.removeCurrentTurret()
        // initialize again
        boardView.removeFromSuperview()
        confirmBtn.removeFromSuperview()
        cancelBtn.removeFromSuperview()
        isInstalling = false
        curGesture = nil
        delegate?.setCurrentInstallState(state: true)
    }
    
    
    /// Exit button handler
    ///
    /// - Parameter sender: button object
    @objc func buttonHandler(sender: Any) {
        delegate!.exitGameView()
    }
    
    
    /// Helper function to add image to current turret view
    ///
    /// - Parameters:
    ///   - tempView: current working TurretView
    ///   - tag: number of type of turret
    ///   - size: frame size of turret view
    func addImage(tempView: TurretView, tag: Int, size: CGPoint) {
        var image: UIImage
        switch tag {
        case 0:
            image = UIImage(named: "turret1")!
        case 1:
            image = UIImage(named: "turret2")!
        case 2:
            image = UIImage(named: "turret3")!
        case 3:
            image = UIImage(named: "turret4")!
        default:
            return
        }
        tempView.turret.frame = CGRect(x: 0, y: 0, width: size.x, height: size.y)
        tempView.turret.image = image
    }
    
    
    /// helper method to set turret with end move gesture
    ///
    /// - Parameter curTurret: current selected turret
    /// - Returns: return it is valid or not
    func setTurretEndMove(curTurret: TurretView) -> Bool {
        cancelBtn.center = CGPoint(x: curTurret.center.x + curTurret.bounds.maxX / 2, y:curTurret.center.y - curTurret.bounds.maxY / 2)
        confirmBtn.center = CGPoint(x: curTurret.center.x - curTurret.bounds.maxX / 2, y:curTurret.center.y - curTurret.bounds.maxY / 2)
        let valid = delegate!.checkValidArea(x: curTurret.center.x, y: curTurret.center.y)
        for i in 1 ..< 5 {
            if valid.contains(i) { curTurret.turretBackground.setGreenFor(cellNum: i) }
            else { curTurret.turretBackground.setRedFor(cellNum: i) }
        }
        if valid.count != 4 {
            addSubview(cancelBtn)
            cancelBtn.addTarget(self, action: #selector(cancelInstallingTurret), for: UIControl.Event.touchDown)
            return false
        }
        addSubview(cancelBtn)
        addSubview(confirmBtn)
        confirmBtn.addTarget(self, action: #selector(confirmRocket), for: UIControl.Event.touchDown)
        cancelBtn.addTarget(self, action: #selector(cancelInstallingTurret), for: UIControl.Event.touchDown)
        return true
    }
    
    
    /// helper method to set turret move in gesture
    ///
    /// - Parameters:
    ///   - curTurret: current selected turret
    ///   - translation: translation point within gesture
    ///   - gridBound: map grid line bound
    func setTurretMove(curTurret: TurretView, translation: CGPoint, gridBound: CGPoint) {
        draggingOriginalLocation.x = draggingOriginalLocation.x + translation.x
        draggingOriginalLocation.y = draggingOriginalLocation.y + translation.y
        delegate!.getCurrentTurret().alpha = 0.5
        let xbound = (gridBound.x / 2)
        let ybound = (gridBound.y / 2)
        var x = CGFloat(0)
        var y = CGFloat(stageLabel.bounds.height)
        let xCount = CGFloat(Int(draggingOriginalLocation.x / xbound))
        let yCount = CGFloat(Int((draggingOriginalLocation.y - y) / ybound))
        let diffX = draggingOriginalLocation.x - xbound * xCount
        let diffY = draggingOriginalLocation.y - y - ybound * yCount
        if diffX > xbound * 0.5 { x = (xCount + CGFloat(1)) * xbound }
        else { x = xCount * xbound }
        if diffY > ybound * 0.5 { y = y + (yCount + CGFloat(1)) * ybound }
        else { y = y + yCount * ybound }
        if x <= xbound { x = xbound }
        if x >= 19 * xbound { x = 19 * xbound }
        if y <= CGFloat(stageLabel.bounds.height) + ybound { y = CGFloat(stageLabel.bounds.height) + ybound }
        if y >= CGFloat(stageLabel.bounds.height) + 9 * ybound { y = CGFloat(stageLabel.bounds.height) + 9 * ybound }
        curTurret.center = CGPoint(x:x, y:y)
        let valid = delegate!.checkValidArea(x: x, y: y)
        for i in 1 ..< 5 {
            if valid.contains(i) { curTurret.turretBackground.setGreenFor(cellNum: i) }
            else { curTurret.turretBackground.setRedFor(cellNum: i) }
        }
    }
    
    /// helper method to create turret when touch gesture began
    ///
    /// - Parameter gridBound: map grid line bound
    func setTurretBeganMove(gridBound: CGPoint) {
        confirmBtn.removeFromSuperview()
        cancelBtn.removeFromSuperview()
        boardView.frame = CGRect(x: 0, y: 0, width: mainView.bounds.width, height: mainView.bounds.height)
        boardView.alpha = 0.2
        mainView.addSubview(boardView)
        let firstTouchPoint = curGesture!.location(in: self)
        let tempView = TurretView()
        tempView.frame = CGRect(x: 0, y: 0, width: gridBound.x, height: gridBound.y)
        tempView.center = firstTouchPoint
        draggingOriginalLocation = firstTouchPoint
        tempView.turretBackground.frame = CGRect(x: 0, y: 0, width: gridBound.x, height: gridBound.y)
        for i in 1 ..< 5 { tempView.turretBackground.setRedFor(cellNum: i) }
        addImage(tempView: tempView, tag: curGesture!.view!.tag, size: gridBound)
        // TODO: need to set right turret
        let turret = addTurret(tag: curGesture!.view!.tag)
        delegate!.setCurrentTurret(turret: turret, view: tempView)
    }
    
    func addTurret(tag: Int) -> Turret{
        var turret = Turret()
        switch tag {
        case 0:
            turret.attackPower = 1
            turret.attackRange = self.bounds.height * 0.2
            turret.attackSpeed = 10
        case 1:
            turret.attackPower = 1
            turret.attackRange = self.bounds.height * 0.5
            turret.attackSpeed = 5
        case 2:
            turret.attackPower = 2
            turret.attackRange = self.bounds.height * 0.4
            turret.attackSpeed = 6
        case 3:
            turret.attackPower = 3
            turret.attackRange = self.bounds.height * 0.35
            turret.attackSpeed = 3
        default:
            return Turret()
        }
        return turret
    }
}
