//
//  FirstScreenViewController.swift
//  Final_Project
//
//  Created by Jiwon Nam on 4/1/19.
//  Copyright © 2019 Jiwon Nam. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, LobbyViewControllerDelegate {
    
    var timer = Timer()
    var user: User?
    var touchPoint: CGPoint = CGPoint(x: 0, y: 0)
    var fadeIn: Bool = false
    //var lobbyViewController: LobbyViewController = LobbyViewController()
    var gameStart: Bool = false
    var firstScreenView: FirstScreenView {
        return view as! FirstScreenView
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        saveStageInfo()
        saveTurrets()
        loadUser()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadUser() {
        print("load")
        let documentsDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        if let jsonData = try? Data(contentsOf: documentsDirectory.appendingPathComponent("userInfo.json")) {
            user = try! JSONDecoder().decode(User.self, from: jsonData)
        }
        else {
            user = User(numOfClearStage: 0, level: 0, name: "Newbie", coin: 0)
        }
    }
    
    func setUser(user: User) {
        self.user = user
    }
    
    func saveStageInfo() {
        var stageInfo: [Stage] = []
       
        var map:[[Int]] = [[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,0,0],[0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,0,0],[0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,0,0],[1,1,1,1,0,0,1,1,0,0,1,1,0,0,1,1,1,1,1,1],[1,1,1,1,0,0,1,1,0,0,1,1,0,0,1,1,1,1,1,1],[0,0,0,0,0,0,1,1,0,0,1,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]]
        var enemy: [Int] = [0,0,0,0,0,0,0,0,0,1]
            
        var stage = Stage(stage: 1, map: map, enemy: enemy)
        stageInfo.append(stage)
        
        map = [[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]]
        enemy = [0,1,0,0,0,1,0,0,0,1]
        
        stage = Stage(stage: 2, map: map, enemy: enemy)
        stageInfo.append(stage)
        
        map = [[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,0,0],[0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,0,0],[0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,0,0],[1,1,1,1,0,0,1,1,0,0,1,1,0,0,1,1,1,1,1,1],[1,1,1,1,0,0,1,1,0,0,1,1,0,0,1,1,1,1,1,1],[0,0,0,0,0,0,1,1,0,0,1,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]]
        enemy = [0,1,0,1,0,1,0,1,0,1]
        
        stage = Stage(stage: 3, map: map, enemy: enemy)
        stageInfo.append(stage)
        
        let documentsDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        try! stageInfo.save(to: documentsDirectory.appendingPathComponent("StageInfo.json"))
    }
    
    override func loadView() {
        view = FirstScreenView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in self.flashingLabel()})
        timer.fire()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStart {
            return
        }
        super.touchesEnded(touches, with: event)
        timer.invalidate()
        startLobbyViewController()
    }
    
    func startLobbyViewController() {
        gameStart = true
        let lobbyViewController = LobbyViewController()
        lobbyViewController.delegate = self
        present(lobbyViewController, animated: false)
    }
    
    func flashingLabel() {
        if fadeIn {
            firstScreenView.touchScreenLabel.fadeIn()
            fadeIn = false
        }
        else {
            firstScreenView.touchScreenLabel.fadeOut()
            fadeIn = true
        }
    }
    
    func saveTurrets() {
        var simpleTurrets:[SimpleTurret] = []
        var simpleTurret = SimpleTurret(name: "turret1", attackPower: 1, attackSpeed: 10, attackRange: 0.2, price: 10)
        simpleTurrets.append(simpleTurret)
        simpleTurret = SimpleTurret(name: "turret2", attackPower: 1, attackSpeed: 5, attackRange: 0.5, price: 20)
        simpleTurrets.append(simpleTurret)
        simpleTurret = SimpleTurret(name: "turret3", attackPower: 2, attackSpeed: 10, attackRange: 0.4, price: 30)
        simpleTurrets.append(simpleTurret)
        simpleTurret = SimpleTurret(name: "turret4", attackPower: 3, attackSpeed: 10, attackRange: 0.35, price: 50)
        simpleTurrets.append(simpleTurret)
        
        print("save all turrets")
        let documentsDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        try! simpleTurrets.save(to: documentsDirectory.appendingPathComponent("turretInfo.json"))
    }
    
    func saveUserInfo() {
        print("save")
        let documentsDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        try! user!.save(to: documentsDirectory.appendingPathComponent("userInfo.json"))
    }
}

extension UILabel {
    func fadeIn() {
        UILabel.animate(withDuration: 1, delay: 0, options: AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
    
    func fadeOut() {
        UILabel.animate(withDuration: 1, delay: 0, options: AnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
}
