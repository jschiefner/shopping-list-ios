//
//  Category.swift
//  shopping-list-ios
//
//  Created by Jonas Schiefner on 18.05.21.
//

import Foundation
import FirebaseFirestoreSwift

struct Category: Identifiable, Codable, Hashable {
    @DocumentID var id: String? = UUID().uuidString
    var name: String
    var position: Float
    var rules = [String]()
    
    static let defaultCategory = Category(id: "BqvRVayFXsRfNVbnQc2C", name: "Default", position: 10000300)
    
    mutating func addRule(_ rule: String) {
        rules.append(rule.lowercased())
    }
    
    mutating func deleteRule(_ rule: String) {
        rules.removeAll { value in
            value == rule.lowercased()
        }
    }
}
