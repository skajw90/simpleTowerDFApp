//
//  ContentsView.swift
//  Final_Project
//
//  Created by Jiwon Nam on 4/11/19.
//  Copyright © 2019 Jiwon Nam. All rights reserved.
//

import UIKit

protocol ContentsViewDelegate {
    func closeItemView()
}

class ContentsView: UIView {
    
    var delegate: ContentsViewDelegate?
    
    lazy var leftView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    } ()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
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

