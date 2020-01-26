//
//  GameController.swift
//  Final_Project
//
//  Created by Jiwon Nam on 4/1/19.
//  Copyright © 2019 Jiwon Nam. All rights reserved.
//

import UIKit

protocol GameViewControllerDelegate {
    func getAllTurrets() -> [TurretClass]
    func getUserInfo() -> User
    func closeGame(_ gameViewController: GameViewController)
    func clearGame(_ gameViewController: GameViewController, earned: Int, stage: Int)
    func failGame(_ gameViewController: GameViewController, earned: Int, stage: Int)
}

class GameViewController: UIViewController, GameViewDelegate, MapViewDelegate, TurretClassDataSource {
    
    var turrets: [TurretClass] = []
    var enemies: [EnemyClass] = []
    var curStage: Stage?
    var missingEnemy = 0
    var destroyedEnemyCount = 0
    var startTimer = Timer()
    var spawnTimer = Timer()
    var gameTimer = Timer()
    let spawnRate = 1
    var spawnedEnemyCount = 0

    var delegate: GameViewControllerDelegate?
    var fps: Int = 60
    var cellSize: CGPoint?
    var count = 0
    var isBuildingTurret: Bool = true
    let turretAngleSpeed = CGFloat(0.05)
    var gameTimeCount = 0
    
    var gameView: GameView {
        return view as! GameView
    }
    
    override func loadView() {
        view = GameView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startGameView()
        startTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(gameStart), userInfo: nil, repeats: true)
        gameTimer = Timer.scheduledTimer(timeInterval: (1.0 / Double(fps)), target: self, selector: #selector(moveAll), userInfo: nil, repeats: true)
        startTimer.fire()
        gameTimer.fire()
    }
    
    func getEnemies() -> [EnemyClass] {
        return enemies
    }
    
    /// Set all constraint of objects in gameView
    func startGameView() {
        NSLayoutConstraint.activate([
            gameView.stageLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            gameView.stageLabel.topAnchor.constraint(equalTo: view.topAnchor),
            gameView.stageLabel.bottomAnchor.constraint(equalTo: gameView.mainView.topAnchor),
            gameView.stageLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            gameView.turretListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            gameView.turretListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            gameView.turretListView.topAnchor.constraint(equalTo: gameView.mainView.bottomAnchor),
            gameView.turretListView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gameView.mainView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            gameView.mainView.topAnchor.constraint(equalTo: gameView.exitBtn.bottomAnchor),
            gameView.mainView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            gameView.mainView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            gameView.exitBtn.rightAnchor.constraint(equalTo: view.rightAnchor),
            gameView.exitBtn.topAnchor.constraint(equalTo: view.topAnchor),
            gameView.exitBtn.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            gameView.exitBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.05),
            gameView.coinInfoView.leftAnchor.constraint(equalTo: gameView.stageLabel.rightAnchor),
            gameView.coinInfoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gameView.coinInfoView.rightAnchor.constraint(equalTo: gameView.exitBtn.leftAnchor),
            gameView.coinInfoView.heightAnchor.constraint(equalTo: gameView.stageLabel.heightAnchor),
            gameView.coinInfoView.unknownCoinLabel.leftAnchor.constraint(equalTo: gameView.coinInfoView.leftAnchor),
            gameView.coinInfoView.unknownCoinLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gameView.coinInfoView.unknownCoinLabel.widthAnchor.constraint(equalTo: gameView.coinInfoView.widthAnchor, multiplier: 0.5),
            gameView.coinInfoView.unknownCoinLabel.heightAnchor.constraint(equalTo: gameView.coinInfoView.heightAnchor),
            gameView.coinInfoView.coinLabel.leftAnchor.constraint(equalTo: gameView.coinInfoView.unknownCoinLabel.rightAnchor),
            gameView.coinInfoView.coinLabel.heightAnchor.constraint(equalTo: gameView.coinInfoView.unknownCoinLabel.heightAnchor),
            gameView.coinInfoView.coinLabel.rightAnchor.constraint(equalTo: gameView.coinInfoView.rightAnchor),
            gameView.coinInfoView.coinLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gameView.turret_type1.heightAnchor.constraint(equalTo: gameView.turretListView.heightAnchor),
            gameView.turret_type1.widthAnchor.constraint(equalTo: gameView.turretListView.widthAnchor, multiplier: 0.25),
            gameView.turret_type1.leftAnchor.constraint(equalTo: gameView.turretListView.leftAnchor),
            gameView.turret_type1.bottomAnchor.constraint(equalTo: gameView.turretListView.bottomAnchor),

            gameView.turret_type2.heightAnchor.constraint(equalTo: gameView.turretListView.heightAnchor),
            gameView.turret_type2.widthAnchor.constraint(equalTo: gameView.turretListView.widthAnchor, multiplier: 0.25),
            gameView.turret_type2.leftAnchor.constraint(equalTo: gameView.turret_type1.rightAnchor),
            gameView.turret_type2.bottomAnchor.constraint(equalTo: gameView.turretListView.bottomAnchor),

            gameView.turret_type3.heightAnchor.constraint(equalTo: gameView.turretListView.heightAnchor),
            gameView.turret_type3.widthAnchor.constraint(equalTo: gameView.turretListView.widthAnchor, multiplier: 0.25),
            gameView.turret_type3.leftAnchor.constraint(equalTo: gameView.turret_type2.rightAnchor),
            gameView.turret_type3.bottomAnchor.constraint(equalTo: gameView.turretListView.bottomAnchor),

            gameView.turret_type4.heightAnchor.constraint(equalTo: gameView.turretListView.heightAnchor),
            gameView.turret_type4.widthAnchor.constraint(equalTo: gameView.turretListView.widthAnchor, multiplier: 0.25),
            gameView.turret_type4.rightAnchor.constraint(equalTo: gameView.turretListView.rightAnchor),
            gameView.turret_type4.bottomAnchor.constraint(equalTo: gameView.turretListView.bottomAnchor)

            ])
        gameView.stageLabel.text = "Stage \(curStage!.stage + 1)"
        gameView.delegate = self
        gameView.mainView.delegate = self
    }
    
    
    /// Get current installing Turret
    ///
    /// - Returns: TurretView
    func getCurrentTurret() -> TurretView {
        //return installedTurrets.last!.1
        return turrets.last!.turretImageView
    }
    
    /// Set current installing Turret
    /// draw this turret
    ///
    /// - Parameter view: get current view info from gameView
    func setCurrentTurret(turret: Turret, view: TurretView) {
        turrets.append(TurretClass(turret: turret, turretImageView: view, turretAngleSpeed: turretAngleSpeed))
        gameView.addSubview(turrets.last!.turretImageView)
    }
    
    /// remove current installing Turret
    func removeCurrentTurret() {
        turrets.last!.turretImageView.removeFromSuperview()
        turrets.removeLast()
    }
    
    /// get turret fixed size within cell size
    ///
    /// - Returns: CGPoint with width and height
    func getTurretSize() -> CGPoint {
        cellSize = CGPoint(x: gameView.mainView.bounds.width / 10, y: gameView.mainView.bounds.height / 5)
        return cellSize!
    }
    
    /// get tile image
    ///
    /// - Parameters:
    ///   - x: column
    ///   - y: row
    /// - Returns: UIImageView
    func getTile(x: Int, y: Int) -> UIImageView {
        var image: UIImage
        if curStage!.map[y][x] == 1 { image = UIImage(named: "water")! }
        else { image = UIImage(named: "grass")! }
        let imageView = UIImageView(image: image)
        return imageView
    }
    
    
    /// check valid area to install turret
    /// return only eanble area
    /// valid area refer as:
    /// 1 -> right top
    /// 2 -> right bottom
    /// 3 -> left bottom
    /// 4 -> left top
    ///
    /// - Parameters:
    ///   - x: center of x in current installing turret
    ///   - y: center of y in current installing turret
    /// - Returns: set of valid area
    func checkValidArea(x: CGFloat, y: CGFloat) -> [Int] {
        let notinclude = gameView.stageLabel.bounds.height
        var valid: [Int] = []
        let posX = Int((x / cellSize!.x * 2).rounded())
        let posY = Int(((y - notinclude) / cellSize!.y * 2).rounded())
        if curStage!.map[posY - 1][posX - 1] == 0 {valid.append(4) }
        if curStage!.map[posY][posX - 1] == 0 { valid.append(3) }
        if curStage!.map[posY][posX] == 0 { valid.append(2) }
        if curStage!.map[posY - 1][posX] == 0 { valid.append(1) }
        return valid
    }
    
    /// game start action hanlder for timer
    @objc func gameStart() {
        if count == 3 {
            startTimer.invalidate()
            spawnTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(spawnEnemy), userInfo: nil, repeats: true)
            spawnTimer.fire()
            count += 1
        }
        else { count += 1 }
    }
    
    /// enemy sapwn action handler for timer
    @objc func spawnEnemy() {
        let imageView = getSpawnEnemy()
        let leftBound: CGFloat = CGFloat(4) * cellSize!.y / 2 + imageView.bounds.maxY / 2
        let rightBound: CGFloat = CGFloat(6) * cellSize!.y / 2 - imageView.bounds.maxY / 2
        var ranCenterY = leftBound
        if leftBound != rightBound {
            ranCenterY = CGFloat.random(in: CGFloat.minimum(leftBound, rightBound) ..< CGFloat.maximum(leftBound, rightBound))
        }
        imageView.center = CGPoint(x: 0, y: ranCenterY)
        var enemy: Enemy = Enemy(type: 0, hp: 10, speed: 0.3, isDistroyed: false)
        if imageView.tag == 1 {
            enemy = Enemy(type: 0, hp: 30, speed: 0.6, isDistroyed: false)
        }
        enemies.append(EnemyClass(enemy: enemy, enemyImage: imageView, yStart: gameView.exitBtn.bounds.maxY))
        gameView.mainView.addSubview(enemies.last!.enemyImage)
    }

    /// move all objects for given timer
    @objc func moveAll() {
        autoTargeting()
        moveEnemy()
        gameTimeCount += 1
        
        if destroyedEnemyCount == 10 {
            print("win")
            gameTimer.invalidate()
            clearTheGame()
        }
    }
    
    /// move enemy
    func moveEnemy() {
        for i in 0 ..< enemies.count {
            if enemies[i].enemy.isDistroyed {
                continue
            }
            let from = enemies[i].getCenterPoint()
            let curGrid = CGPoint(x: from.x / (cellSize!.x / 2), y: from.y / (cellSize!.y / 2))
            let x = Int(curGrid.x)
            let y = Int(curGrid.y)
            var to: CGPoint?
            
            if curStage!.stage == 2 {
                to = CGPoint(x: CGFloat(enemies[i].enemy.speed), y: 0)
            }
            else {
                if x == 3 && (curStage!.map[y - 1][x+1] == 0 || curStage!.map[y - 1][x+1] == 2) {
                    to = CGPoint(x: 0, y: -CGFloat(enemies[i].enemy.speed))
                } else if x == 7 && (curStage!.map[y-1][x+1] == 0 || curStage!.map[y - 1][x+1] == 2) {
                    to = CGPoint(x: 0, y: CGFloat(enemies[i].enemy.speed))
                } else if x == 11 && (curStage!.map[y-1][x+1] == 0 || curStage!.map[y - 1][x+1] == 2) {
                    to = CGPoint(x: 0, y: -CGFloat(enemies[i].enemy.speed))
                } else if x == 15 && (curStage!.map[y-1][x+1] == 0 || curStage!.map[y - 1][x+1] == 2) {
                    to = CGPoint(x: 0, y: CGFloat(enemies[i].enemy.speed))
                }
                else {
                    to = CGPoint(x: CGFloat(enemies[i].enemy.speed), y: 0)
                }
                
            }
    
            enemies[i].autoMove(to: to!)
            if enemies[i].enemyImage.center.x > gameView.mainView.bounds.maxX {
                print("YOU LOSE")
                gameTimer.invalidate()
                failTheGame()
            }
        }
    }
    
    /// set current install state
    /// if install done,
    /// set map with turret component
    ///
    /// - Parameter state: current state in gameView
    func setCurrentInstallState(state: Bool) {
        isBuildingTurret = state
        // set turret in map info
        if !state {
            turrets.last!.dataSource = self
//            let x = installedTurrets.last!.1.center.x
//            let y = installedTurrets.last!.1.center.y
            let x = turrets.last!.turretImageView.center.x
            let y = turrets.last!.turretImageView.center.y
            let notinclude = gameView.stageLabel.bounds.height
            let posX = Int((x / cellSize!.x * 2).rounded())
            let posY = Int(((y - notinclude) / cellSize!.y * 2).rounded())
            
            curStage!.map[posY - 1][posX - 1] = 2
            curStage!.map[posY][posX - 1] = 2
            curStage!.map[posY][posX] = 2
            curStage!.map[posY - 1][posX] = 2
        }
    }
    
    /// function to set auto targetting for every turret
    func autoTargeting() {
//        var count = installedTurrets.count
        var count = turrets.count
        if isBuildingTurret { count = count - 1 }
        if count == -1 { return }
        for i in 0 ..< count {
            turrets[i].autoTargeting()
            moveBullets(from: turrets[i])
            if self.gameTimeCount % fps == 0 {
                // TODO: fix speed
                print("fire")
                fireBullet(from: turrets[i])
            }
        }
    }
    
    /// create enemy with time interval
    ///
    /// - Returns: enemy UIImageView
    func getSpawnEnemy() -> EnemyView {
        let imageView = EnemyView()
        if curStage!.enemy[spawnedEnemyCount] == 0 {
            imageView.setImage(image: UIImage(named: "enemy_right")!)
            imageView.frame = CGRect(x: 0, y: 0, width: cellSize!.x / 2, height: cellSize!.y / 2)
            imageView.tag = 0
        }
        else {
            imageView.setImage(image: UIImage(named: "enemy_boss_right")!)
            imageView.frame = CGRect(x: 0, y: 0, width: cellSize!.x, height: cellSize!.y)
            imageView.tag = 1
        }
        spawnedEnemyCount += 1
        if spawnedEnemyCount == 10 { spawnTimer.invalidate() }
        return imageView
    }
    
    /// Exit this game function
    func exitGameView() {
        // reset everything
        gameTimer.invalidate()
        delegate!.closeGame(self)
    }
    
    func fireBullet(from: TurretClass) {
        if !from.turret.lockOnTarget {
            print("not fired")
            return
        }
        let to = from.turret.lockAimTo
        let angle = from.turret.angle
        let bullet_view = UIImageView(image: UIImage(named: "bullet.png"))
        bullet_view.frame = CGRect(x: 0, y: 0, width: cellSize!.x / 4, height: cellSize!.y / 4)
        bullet_view.center = from.turretImageView.center
        bullet_view.transform = bullet_view.transform.rotated(by: from.turret.angle)
        let bullet = BulletClass(bullet: Bullet(xPos: from.turretImageView.center.x, yPos: from.turretImageView.center.y, speed: 10, angle: angle, aimed: to, duration: 0), bulletImage: bullet_view)
            
        from.turret.bullets.append(bullet)
        gameView.addSubview(from.turret.bullets.last!.bulletImage)
    }
    
    func moveBullets(from: TurretClass) {
        if from.turret.bullets.count == 0 {
            return
        }
        var removeBulletNums: [Int] = []
        for i in 0 ..< from.turret.bullets.count {
            if from.turret.bullets[i].bullet.aimed!.enemy.isDistroyed {
                // remove bullet
                print("remove this bullet")
                if !removeBulletNums.contains(i) {
                    removeBulletNums.append(i)
                    from.turret.bullets[i].bulletImage.removeFromSuperview()
                }
            }
            from.turret.bullets[i].bullet.duration += 1
            let fromPosX = from.turret.bullets[i].bulletImage.center.x
            let toPosX = from.turret.lockAimTo!.enemyImage.center.x
            let fromPosY = from.turret.bullets[i].bulletImage.center.y
            let toPosY = from.turret.lockAimTo!.enemyImage.center.y
            let distance = (pow(fromPosX - toPosX, 2) + pow(fromPosY - toPosY, 2)).squareRoot()
            from.turret.bullets[i].bulletImage.center.x +=  distance * sin(from.turret.bullets[i].bullet.angle!) * 0.05
            from.turret.bullets[i].bulletImage.center.y +=  distance * -cos(from.turret.bullets[i].bullet.angle!) * 0.05
            
            if checkCollision(turret: from.turret, bullet: from.turret.bullets[i]) {
                if !removeBulletNums.contains(i) {
                    removeBulletNums.append(i)
                    from.turret.bullets[i].bulletImage.removeFromSuperview()
                }
            }
            if from.turret.bullets[i].bullet.duration >= fps * 4{
                print("remove this bullet")
                if !removeBulletNums.contains(i) {
                    removeBulletNums.append(i)
                    from.turret.bullets[i].bulletImage.removeFromSuperview()
                }
            }
        }
        // need to fix bug
        removeBulletNums.sort()
        if removeBulletNums.count != 0 {
            if removeBulletNums.count == 1 {
                from.turret.bullets.removeFirst()
            }
            else {
                for i in stride(from: removeBulletNums.count - 1, to: 0, by: -1) {
                    from.turret.bullets.remove(at: i)
                }
            }
        }
    }
    
    func checkCollision(turret: Turret, bullet: BulletClass) -> Bool {
        let bulletBound = bullet.bulletImage.bounds
        let bulletCenter = bullet.bulletImage.center
        let bulletBoundPosition = CGRect(x: bulletCenter.x - bulletBound.width / 2, y: bulletCenter.y - bulletBound.height / 2, width: bulletBound.width, height: bulletBound.height)
        
        let enemy = bullet.bullet.aimed!
        let enemyBound = enemy.enemyImage.bounds
        let enemyCenter = enemy.getCenterPoint()
        let enemyBoundPosition = CGRect(x: enemyCenter.x - enemyBound.width / 2, y: enemyCenter.y - enemyBound.height / 2, width: enemyBound.width, height: enemyBound.height)
        
        if bulletBoundPosition.intersects(enemyBoundPosition) {
            print("collision!")
            // decrement hp of enemy
            enemy.enemy.hp -= turret.attackPower
            if enemy.enemy.hp <= 0 {
                enemy.enemy.isDistroyed = true
                enemy.enemyImage.removeFromSuperview()
                destroyedEnemyCount += 1
            }
            return true
        }
        return false
    }
    
    // TODO: clear the stage
    func clearTheGame() {
        let alert = UIAlertController(title: "Game Clear", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.delegate!.clearGame(self, earned: 0, stage: self.curStage!.stage)
        }))
        present(alert, animated: true)
    }
    // TODO: fail the stage
    func failTheGame() {
        let alert = UIAlertController(title: "Game Over", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.delegate!.failGame(self, earned: 0, stage: self.curStage!.stage)
        }))
    }
}
