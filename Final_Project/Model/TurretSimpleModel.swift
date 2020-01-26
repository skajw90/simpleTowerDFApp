//
//  TurretSimpleModel.swift
//  Final_Project
//
//  Created by Jiwon Nam on 4/29/19.
//  Copyright © 2019 Jiwon Nam. All rights reserved.
//

import Foundation

struct SimpleTurret: Codable {
    var name: String = ""
    var attackPower = 1
    var attackSpeed = 1
    var attackRange: Float = 0
    var price: Int = 0
    
    enum Error: Swift.Error {
        case encoding
        case writing
    }
}

extension Array where Element == SimpleTurret {
    func save(to url: URL) throws {
        guard let jsonData = try? JSONEncoder().encode(self) else {
            throw SimpleTurret.Error.encoding
        }
        do {
            try jsonData.write(to: url)
        }
        catch {
            throw SimpleTurret.Error.writing
        }
    }
    
    init(from url: URL) throws {
        let jsonData = try! Data(contentsOf: url)
        self = try JSONDecoder().decode([SimpleTurret].self, from: jsonData)
    }
}
