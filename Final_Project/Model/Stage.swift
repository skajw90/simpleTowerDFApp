//
//  Map.swift
//  Final_Project
//
//  Created by Jiwon Nam on 4/27/19.
//  Copyright © 2019 Jiwon Nam. All rights reserved.
//

import Foundation

struct Stage: Codable {
    var stage: Int
    var map: [[Int]]
    var enemy: [Int]
    
    enum Error: Swift.Error {
        case encoding
        case writing
    }
}
extension Array where Element == Stage {
    func save(to url: URL) throws {
        guard let jsonData = try? JSONEncoder().encode(self) else {
            throw Stage.Error.encoding
        }
        do {
            try jsonData.write(to: url)
        }
        catch {
            throw Stage.Error.writing
        }
    }
    
    init(from url: URL) throws {
        let jsonData = try! Data(contentsOf: url)
        self = try JSONDecoder().decode([Stage].self, from: jsonData)
    }
}
