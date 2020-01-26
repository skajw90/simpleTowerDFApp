//
//  ContentsViewController.swift
//  Final_Project
//
//  Created by Jiwon Nam on 4/11/19.
//  Copyright © 2019 Jiwon Nam. All rights reserved.
//

import UIKit

protocol ContentsViewControllerDelegate {
    func getAllTurrets() -> [TurretClass]
}

class ContentsViewController: UIViewController, ContentsViewDelegate {
   
    var selectedCell: IndexPath?
    var delegate: ContentsViewControllerDelegate?
    var data: [TurretClass] = []
    
    var contentsView: ContentsView {
        return view as! ContentsView
    }
    
    override func loadView() {
        super.loadView()
        view = ContentsView()
        setConstraint()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentsView.collectionView.dataSource = self
        contentsView.collectionView.delegate = self
        contentsView.collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
        contentsView.collectionView.alwaysBounceVertical = true
        contentsView.collectionView.backgroundColor = .white
        loadData()
    }
    
    func loadData() {
        data = delegate!.getAllTurrets()
    }
    
    func setConstraint() {
        view.frame = parent!.view.bounds
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        NSLayoutConstraint.activate([
            contentsView.leftView.leftAnchor.constraint(equalTo: view.leftAnchor),
            contentsView.leftView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            contentsView.leftView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentsView.leftView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
            contentsView.collectionView.topAnchor.constraint(equalTo: contentsView.leftView.topAnchor),
            contentsView.collectionView.bottomAnchor.constraint(equalTo: contentsView.leftView.bottomAnchor),
            contentsView.collectionView.leftAnchor.constraint(equalTo: contentsView.leftView.rightAnchor),
            contentsView.collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            contentsView.exitBtn.topAnchor.constraint(equalTo: view.topAnchor),
            contentsView.exitBtn.bottomAnchor.constraint(equalTo: contentsView.collectionView.topAnchor),
            contentsView.exitBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.05),
            contentsView.exitBtn.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
        contentsView.delegate = self
    }
    
    func closeItemView() {
        print("close itemView")
        self.remove()
    }
}

extension ContentsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as! Cell
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        let data = self.data[indexPath.item]
        let imageView = data.turretImageView.turret
        imageView.frame = cell.frame
        imageView.center = cell.center
        cell.backgroundView = imageView
        return cell
    }
}

extension ContentsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let change = selectedCell {
            let changeCell = collectionView.cellForItem(at: change)
            changeCell?.backgroundColor = .white
        }
        let cell = collectionView.cellForItem(at: indexPath)
        cell!.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        selectedCell = indexPath
        let view = TurretInfoView()
        view.backgroundColor = .black
        let thisData = data[indexPath.item]
        print(thisData.turret.name)
        let image = UIImage(named: "\(thisData.turret.name)")
        view.imageView.image = image
        view.infoLabel.text = "name: \(thisData.turret.name)\n attackPower: \(thisData.turret.attackPower)\n attackRange: \(thisData.turret.attackRange * contentsView.bounds.height)\n attackSpeed: \(thisData.turret.attackSpeed)\n"
        view.frame = CGRect(x: 0, y: 0, width: contentsView.leftView.bounds.width, height: contentsView.leftView.bounds.height)
        (view.imageView.frame, view.infoLabel.frame) = view.bounds.divided(atDistance: view.bounds.height / 2, from: .minYEdge)
        print("selected cell: \(indexPath.item)")
        
        contentsView.leftView.addSubview(view)
        
    }
}

extension ContentsViewController: UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 5, height: collectionView.bounds.height / 5)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    class Cell: UICollectionViewCell {
        
        static var identifier: String = "Cell"
        
        weak var textLabel: UILabel!
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            let textLabel = UILabel(frame: .zero)
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(textLabel)
            NSLayoutConstraint.activate([
                self.contentView.centerXAnchor.constraint(equalTo: textLabel.centerXAnchor),
                self.contentView.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor),
                ])
            self.textLabel = textLabel
            self.reset()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            self.reset()
        }
        
        func reset() {
            self.textLabel.textAlignment = .center
        }
    }
}
