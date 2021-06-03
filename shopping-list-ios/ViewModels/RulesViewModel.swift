//
//  RulesViewModel.swift
//  shopping-list-ios
//
//  Created by Jonas Schiefner on 03.06.21.
//

import Foundation
import FirebaseFirestore

class RulesViewModel: ObservableObject {
    @Published var category: Category
    private let categoryDocument: DocumentReference
    
    init(category: Category) {
        self.category = category
        categoryDocument = Firestore
            .firestore()
            .collection("categories")
            .document(category.id!)
        connectData()
    }
    
    func connectData() {
        categoryDocument.addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                print("could not fetch category")
                return
            }
            
            self.category = try! document.data(as: Category.self)!
        }
    }
    
    func addRow() {
        category.rules.append("")
    }
    
    func save() {
        category.rules.removeAll { string -> Bool in string.isEmpty }
        try? categoryDocument.setData(from: category)
    }
    
    func delete(indexSet: IndexSet) {
        indexSet.forEach { index in
            category.rules.remove(at: index)
        }
        save()
    }
}
