//
//  Item.swift
//  shopping-list-ios
//
//  Created by Jonas Schiefner on 18.05.21.
//

import Foundation
import FirebaseFirestoreSwift

struct Item: Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    var name: String
    var completed: Bool
}
