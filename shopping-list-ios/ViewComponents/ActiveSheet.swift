//
//  ActiveSheet.swift
//  shopping-list-ios
//
//  Created by Jonas Schiefner on 29.05.21.
//

import Foundation

enum ActiveSheet: Identifiable {
    case itemForm, categoryEditor
    
    var id: Int { hashValue }
}
