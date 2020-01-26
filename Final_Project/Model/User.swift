//
//  User.swift
//  Final_Project
//
//  Created by Jiwon Nam on 4/9/19.
//  Copyright © 2019 Jiwon Nam. All rights reserved.
//

import Foundation

struct User: Codable {
    var numOfClearStage: Int = 0
    var level: Int = 0
    var name: String = ""
    var coin: Int = 0
    
    enum Error: Swift.Error {
        case encoding
        case writing
    }
    
    func save(to url: URL) throws {
        guard let jsonData = try? JSONEncoder().encode(self) else {
            throw User.Error.encoding
        }
        do {
            try jsonData.write(to: url)
        }
        catch {
            throw User.Error.writing
        }
    }
}

