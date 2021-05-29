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
        guard category != Category.defaultCategory else {
            print("warning: cannot delete default category")
            return
        }
        db.collection("categories")
            .document(category.id!)
            .delete()
    }
}
