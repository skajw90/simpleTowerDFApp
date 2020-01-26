//
//  ViewController.swift
//  Final_Project
//
//  Created by Jiwon Nam on 4/1/19.
//  Copyright © 2019 Jiwon Nam. All rights reserved.
//

import UIKit

protocol LobbyViewControllerDelegate {
    func startLobbyViewController()
    func setUser(user: User)
}

class LobbyViewController: UIViewController, MenuViewDelegate, ContentsViewControllerDelegate, SettingViewControllerDelegate, GameViewControllerDelegate, StageViewDelegate, StageInfoViewControllerDelegate {

    var delegate: LobbyViewControllerDelegate?
    var user: User?
    var turrets: [TurretClass] = []
    var stageInfo: [Stage] = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        loadUser()
        readTurrets()
        readStageInfo()
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
    
    func readTurrets() {
        let documentsDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let jsonData = try! Data(contentsOf: documentsDirectory.appendingPathComponent("turretInfo.json"))
        let simpleTurrets = try! JSONDecoder().decode([SimpleTurret].self, from: jsonData)
        for i in 0 ..< simpleTurrets.count {
            let turret = Turret(name: simpleTurrets[i].name, attackPower: simpleTurrets[i].attackPower, attackSpeed: simpleTurrets[i].attackSpeed, attackRange: lobbyView.bounds.height * CGFloat(simpleTurrets[i].attackRange), lockOnTarget: false, lockAimTo: nil, price: simpleTurrets[i].price, angle: 0, bullets: [])
            var image: UIImage?
            if i == 0 {
                image = UIImage(named: "turret1")
            } else if i == 1 {
                image = UIImage(named: "turret2")
            } else if i == 2 {
                image = UIImage(named: "turret3")
            } else {
                image = UIImage(named: "turret4")
            }
            let imageView = TurretView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            imageView.turret = UIImageView(image: image)
            turrets.append(TurretClass(turret: turret, turretImageView: imageView, turretAngleSpeed: 0))
        }
    }
    
    func readStageInfo() {
        let documentsDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let jsonData = try! Data(contentsOf: documentsDirectory.appendingPathComponent("StageInfo.json"))
        stageInfo = try! JSONDecoder().decode([Stage].self, from: jsonData)
        print("done")
    }
    
    var lobbyView: LobbyView {
        return view as! LobbyView
    }
    
    override func loadView() {
        view = LobbyView()
        startLobbyView()
    }
    
    func startLobbyView() {
        print("start lobby view")
        NSLayoutConstraint.activate([
            // stage view layout
            lobbyView.stageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            lobbyView.stageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            lobbyView.stageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            lobbyView.stageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            // menu view layout
            lobbyView.menuView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2),
            lobbyView.menuView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.6),
            lobbyView.menuView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            lobbyView.menuView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            lobbyView.coinInfoView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            lobbyView.coinInfoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            lobbyView.coinInfoView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            lobbyView.coinInfoView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1),
            lobbyView.coinInfoView.unknownCoinLabel.leftAnchor.constraint(equalTo: lobbyView.coinInfoView.leftAnchor),
            lobbyView.coinInfoView.unknownCoinLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            lobbyView.coinInfoView.unknownCoinLabel.widthAnchor.constraint(equalTo: lobbyView.coinInfoView.widthAnchor, multiplier: 0.5),
            lobbyView.coinInfoView.unknownCoinLabel.heightAnchor.constraint(equalTo: lobbyView.coinInfoView.heightAnchor),
            lobbyView.coinInfoView.coinLabel.leftAnchor.constraint(equalTo: lobbyView.coinInfoView.unknownCoinLabel.rightAnchor),
            lobbyView.coinInfoView.coinLabel.heightAnchor.constraint(equalTo: lobbyView.coinInfoView.unknownCoinLabel.heightAnchor),
            lobbyView.coinInfoView.coinLabel.rightAnchor.constraint(equalTo: lobbyView.coinInfoView.rightAnchor),
            lobbyView.coinInfoView.coinLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
            
            
            ])
        lobbyView.menuView.delegate = self
        lobbyView.stageView.delegate = self
    }
    
    func popupView(selected: Int) {
        print("pop up!")
        var selectedController = UIViewController()
        selectedController = ContentsViewController()
        (selectedController as! ContentsViewController).delegate = self
        switch selected {
        case 0:
            print("itemView")
            // set data, and send datasource
        case 1:
            print("rocketView")
            // set data, and send datasource
        case 2:
            print("shopView")
            // set data, and send datasource
        case 3:
            print("settingView")
            selectedController = SettingViewController()
            (selectedController as! SettingViewController).delegate = self
        default:
            print("error")
        }
        add(selectedController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var curStage = Int(0)
    
    func showSelectedStageInfo(section: Int) {
        print("pop up stage info")
        curStage = section
        var stageInfoController = UIViewController()
        stageInfoController = StageInfoViewController()
        (stageInfoController as! StageInfoViewController).map = stageInfo[section].map
        (stageInfoController as! StageInfoViewController).delegate = self
        add(stageInfoController)
    }
    
    func startGame(_ stageInfoViewController: StageInfoViewController) {
        stageInfoViewController.remove()
        startGameController()
    }
    
    func startGameController() {
        print("start New Game stage: \(curStage)")
        let gameController = GameViewController()
        gameController.curStage = stageInfo[curStage]
        gameController.delegate = self
        present(gameController, animated: false)
    }
    
    func exitStageInfoView(_ stageInfoViewController: StageInfoViewController) {
        stageInfoViewController.remove()
        print("get back to lobby!")
    }
    
    func closeGame(_ gameViewController: GameViewController) {
        gameViewController.dismiss(animated: false)
    }
    
    func clearGame(_ gameViewController: GameViewController, earned: Int, stage: Int) {
        print("clearGame!")
        user!.coin += earned
        user!.numOfClearStage += 1
        delegate!.setUser(user: user!)
        gameViewController.dismiss(animated: true)
    }
    
    func failGame(_ gameViewController: GameViewController, earned: Int, stage: Int) {
        print("failGame!")
        
        gameViewController.dismiss(animated: true)
    }
    
    func getAllTurrets() -> [TurretClass] {
        return turrets
    }
    
    func getUserInfo() -> User {
        return user!
    }

}

extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
