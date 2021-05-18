//
//  ItemViewModel.swift
//  shopping-list-ios
//
//  Created by Jonas Schiefner on 18.05.21.
//

import Foundation
import FirebaseFirestore

class ItemViewModel: ObservableObject {
    @Published var items = [Item]()
    private var db = Firestore.firestore()
    
    var categoryId: String
    
    init(categoryId: String) {
        self.categoryId = categoryId
    }
    
    func connectData() {
        db.collection("categories").document(categoryId).collection("items").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No item documents")
                return
            }
                        
            self.items = documents.compactMap({ (queryDocumentSnapshot) -> Item? in
                return try? queryDocumentSnapshot.data(as: Item.self)
            })
        }
    }
    
}
