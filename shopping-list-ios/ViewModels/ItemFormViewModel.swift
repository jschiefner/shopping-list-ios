//
//  ItemFormViewModel.swift
//  shopping-list-ios
//
//  Created by Jonas Schiefner on 25.05.21.
//

import Foundation
import FirebaseFirestore

class ItemFormViewModel: ObservableObject {
    // Published Properties
    @Published var item: Item
    @Published var addNewCategory = false
    @Published var newCategory = Category(name: "", position: Category.defaultCategory.position+1)
    @Published var addRule = true
    @Published var deleteRule = true
    @Published var selectedCategory: Category
    @Published var categories: [Category]
    
    // Computed Properties
    var lowercaseItemName: String { return item.name.lowercased() }
    var category: Category { return addNewCategory ? newCategory : selectedCategory }
    var existingCategory: Category?
    var ruleExists: Bool { return existingCategory != nil }
    var showAddRule: Bool {
        if (addNewCategory) { return true }
        
        if (ruleExists) {
            return selectedCategory != existingCategory!
        } else {
            return true
        }
    }
    var showDeleteRule: Bool {
        guard ruleExists else { return false }
        
        if (addNewCategory) {
            return true
        } else {
            return selectedCategory != existingCategory!
        }
    }
    var saveDisabled: Bool {
        if addNewCategory {
            return item.name.isEmpty || newCategory.name.isEmpty
        } else {
            return item.name.isEmpty
        }
    }
    
    // private properties
    private var db = Firestore.firestore()
    
    // initializers
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
        self.addRule = false
        self.deleteRule = false
        loadCategories()
        itemNameOnEnter() // fetch category that item should be assigned to
    }
    
    // functionality
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
                self.existingCategory = foundCategory
            } else { // no categories found
                self.addRule = true
                self.existingCategory = nil
            }
        }
    }
    
    func newCategoryToggled(_ : Any) {
        if ruleExists {
            if addNewCategory {
                self.addRule = true
                self.deleteRule = true
            } else {
                if existingCategory! != selectedCategory {
                    self.addRule = true
                    self.deleteRule = true
                }
            }
        } else {
            self.addRule = true
        }
    }
    
    func newCategoryOnEnter() {
        // pass
    }
    
    func onCategoryPicked(_ : Any) {
        if ruleExists {
            if existingCategory! != selectedCategory {
                self.addRule = true
                self.deleteRule = true
            }
        } else {
            self.addRule = true
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
