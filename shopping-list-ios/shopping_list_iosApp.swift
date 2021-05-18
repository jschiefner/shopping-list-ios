//
//  shopping_list_iosApp.swift
//  shopping-list-ios
//
//  Created by Jonas Schiefner on 18.05.21.
//

import SwiftUI
import Firebase

@main
struct shopping_list_iosApp: App {
    var body: some Scene {
        FirebaseApp.configure()
        
        return WindowGroup {
            ShoppingList()
        }
    }
}
