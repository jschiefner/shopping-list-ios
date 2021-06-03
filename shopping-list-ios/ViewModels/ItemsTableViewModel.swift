//
//  ItemsTableViewModel.swift
//  shopping-list-ios
//
//  Created by Jonas Schiefner on 18.05.21.
//

import Foundation
import FirebaseFirestore

class ItemsTableViewModel: ObservableObject {
    @Published var items = [Item]()
    private var db = Firestore.firestore()
    
    var category: Category
    
    init(category: Category) {
        self.category = category
        connectData()
    }
    
    func connectData() {
        db.collection("categories").document(category.id!).collection("items").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No item documents")
                return
            }
                        
            self.items = documents.compactMap({ (queryDocumentSnapshot) -> Item? in
                return try? queryDocumentSnapshot.data(as: Item.self)
            })
        }
    }
    
    func delete(itemAt index: Int) {
        db
            .collection("categories")
            .document(category.id!)
            .collection("items")
            .document(items[index].id!)
            .delete()
    }
    
}
