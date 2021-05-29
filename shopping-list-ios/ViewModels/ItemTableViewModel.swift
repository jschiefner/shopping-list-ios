//
//  ItemTableViewModel.swift
//  shopping-list-ios
//
//  Created by Jonas Schiefner on 20.05.21.
//

import Foundation
import FirebaseFirestore

class ItemTableViewModel: ObservableObject {
    @Published var item: Item
    private var document: DocumentReference
    
    init(item: Item, categoryId: String) {
        self.item = item
        self.document = Firestore
            .firestore()
            .collection("categories")
            .document(categoryId)
            .collection("items")
            .document(item.id!)
    }
    
    func updateCompleted() {
        document.updateData(["completed": item.completed])
    }
    
    func updateName() {
        document.updateData(["name": item.name])
    }
    
    func delete() {
        document.delete()
    }
}
