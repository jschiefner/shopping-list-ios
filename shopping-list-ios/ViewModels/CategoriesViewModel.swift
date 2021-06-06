//
//  CategoryViewModel.swift
//  shopping-list-ios
//
//  Created by Jonas Schiefner on 18.05.21.
//

import Foundation
import FirebaseFirestore

class CategoriesViewModel: ObservableObject {
    @Published var categories = [Category]()
    private var db = Firestore.firestore()
    
    func connectData() {
        db.collection("categories").order(by: "position").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No category documents")
                return
            }
            
            self.categories = documents.compactMap({ (queryDocumentSnapshot) -> Category? in
                return try! queryDocumentSnapshot.data(as: Category.self)
            })
        }
    }
    
    func delete(itemAt index: Int) {
        let category = categories[index]
        guard !category.isDefault else {
            print("warning: cannot delete default category")
            return
        }
        db.collection("categories")
            .document(category.id!)
            .delete()
    }
    
    func move(from: Int, to: Int) {      
        var category = categories[from]
        let beforeIndex = to-1
        let afterIndex = to
                
        if beforeIndex < 0 {
            let after = categories[afterIndex]
            category.position = after.position / 2
        } else if afterIndex >= categories.count {
            let before = categories[beforeIndex]
            category.position = before.position + 100
        } else {
            let before = categories[beforeIndex]
            let after = categories[afterIndex]
            category.position = (before.position + after.position) / 2
        }
        
        try? db.collection("categories").document(category.id!).setData(from: category)
    }
}
