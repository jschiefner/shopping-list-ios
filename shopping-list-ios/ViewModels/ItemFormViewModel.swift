//
//  ItemFormViewModel.swift
//  shopping-list-ios
//
//  Created by Jonas Schiefner on 25.05.21.
//

import Foundation
import FirebaseFirestore

class ItemFormViewModel: ObservableObject {
    @Published var item: Item
    @Published var addNewCategory = false
    @Published var newCategory = Category(name: "", position: Category.defaultCategory.position+1)
    @Published var addRule = true
    @Published var deleteRule = true
    @Published var showAddRule = false
    @Published var showDeleteRule = false
    @Published var selectedCategory: Category
    @Published var categories: [Category]
    var canSave: Bool {
        return item.name.isEmpty
    }
    var lowercaseItemName: String {
        return item.name.lowercased()
    }
    var category: Category {
        return addNewCategory ? newCategory : selectedCategory
    }
    var categoryToDeleteFrom: Category?
    var ruleExists: Bool {
        return categoryToDeleteFrom != nil
    }
    
    private var db = Firestore.firestore()
    
    init() {
        self.item = Item(name: "", completed: false)
        self.selectedCategory = Category.defaultCategory
        self.categories = [Category.defaultCategory]
        loadCategories()
    }
    
    init(item: Item, category: Category) {
        self.item = item
        self.selectedCategory = category
        self.categories = [
            category,
            Category.defaultCategory,
        ]
        loadCategories()
    }
    
    func loadCategories() {
        db.collection("categories").order(by: "position").getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No Categories")
                return
            }
            
            self.categories = documents.compactMap({ (queryDocumentSnapshot) -> Category? in
                return try? queryDocumentSnapshot.data(as: Category.self)
            })
        }
    }
    
    func itemNameOnEnter() {
        db.collection("categories").whereField("rules", arrayContains: lowercaseItemName).getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No matching Categories")
                return
            }
            
            let foundCategories = documents.compactMap({ (queryDocumentSnapshot) -> Category? in
                return try? queryDocumentSnapshot.data(as: Category.self)
            })
            
            if (foundCategories.count >= 1) { // at least one category found
                let foundCategory = foundCategories.first!
                self.selectedCategory = foundCategory
                self.addNewCategory = false
                self.showAddRule = false
                self.showDeleteRule = false
                self.categoryToDeleteFrom = foundCategory
            } else { // no categories found
                self.showAddRule = true
                self.addRule = true
                self.showDeleteRule = false
                self.categoryToDeleteFrom = nil
            }
        }
    }
    
    func newCategoryToggled(_ : Any) {
        if ruleExists {
            if addNewCategory {
                print("here-1")
                self.showAddRule = true
                self.showDeleteRule = true
                self.addRule = true
                self.deleteRule = true
            } else {
                if categoryToDeleteFrom! == selectedCategory {
                    print("here too")
                    self.showAddRule = false
                    self.showDeleteRule = false
                } else {
                    print("here0")
                    self.showAddRule = true
                    self.addRule = true
                    self.showDeleteRule = true
                    self.deleteRule = true
                }
            }
        } else {
            print("here1")
            self.showAddRule = true
            self.addRule = true
            self.showDeleteRule = false
        }
    }
    
    func newCategoryOnEnter() {
        print("entered \(newCategory.name)")
    }
    
    func onCategoryPicked(_ : Any) {
        if ruleExists {
            if categoryToDeleteFrom! == selectedCategory {
                self.showAddRule = false
                self.showDeleteRule = false
            } else {
                print("here2")
                self.showAddRule = true
                self.addRule = true
                self.showDeleteRule = true
                self.deleteRule = true
            }
        } else {
            print("here3")
            self.showAddRule = true
            self.addRule = true
            self.showDeleteRule = false
        }
    }
    
    func save() {
        try? db
            .collection("categories")
            .document(category.id!)
            .collection("items")
            .document(item.id!)
            .setData(from: item)
    }
}
