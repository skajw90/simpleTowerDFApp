//
//  CoinInfoView.swift
//  Final_Project
//
//  Created by Jiwon Nam on 4/18/19.
//  Copyright © 2019 Jiwon Nam. All rights reserved.
//

import UIKit

class CoinInfoView: UIView {
    lazy var coinLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Coin: 0"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    } ()
    
    lazy var unknownCoinLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "UnKnown Coin: 0"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    } ()
}
