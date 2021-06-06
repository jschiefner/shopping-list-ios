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
    var addingItem: Bool { return oldCategory == nil }
    var shouldAddRule: Bool { return showAddRule && addRule }
    var shouldDeleteRule: Bool { return showDeleteRule && deleteRule }
    var showAddRule: Bool {
        if (addNewCategory) { return true }
        if selectedCategory.isDefault { return false }
        
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
    private var collection = Firestore.firestore().collection("categories")
    private var oldCategory: Category?
    
    // initializers
    init() {
        self.item = Item(name: "", completed: false)
        self.selectedCategory = Category.defaultCategory
        self.categories = [Category.defaultCategory]
        loadCategories()
    }
    
    init(item: Item, category: Category) {
        self.item = item
        self.oldCategory = category
        self.selectedCategory = category
        self.categories = [
            category,
            Category.defaultCategory,
        ]
        self.addRule = false
        self.deleteRule = false
        loadCategories()
        fetchExistingCategory(overwrite: false)
    }
    
    // functionality
    func loadCategories() {
        collection.order(by: "position").getDocuments { (querySnapshot, error) in
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
        item.name = item.name.trimmingCharacters(in: .whitespacesAndNewlines)
        fetchExistingCategory(overwrite: true)
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
        addingItem ? saveNewItem() : updateExistingItem()
    }
    
    private func fetchExistingCategory(overwrite: Bool) {
        collection.whereField("rules", arrayContains: lowercaseItemName).getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No matching Categories")
                return
            }
            
            let foundCategories = documents.compactMap({ (queryDocumentSnapshot) -> Category? in
                return try? queryDocumentSnapshot.data(as: Category.self)
            })
            
            if (foundCategories.count >= 1) { // at least one category found
                let foundCategory = foundCategories.first!
                self.existingCategory = foundCategory
                if overwrite {
                    self.selectedCategory = foundCategory
                    self.addNewCategory = false
                }
            } else { // no categories found
                if overwrite {
                    self.addRule = true
                    self.existingCategory = nil
                }
            }
        }
    }
    
    private func saveNewItem() {
        if !addNewCategory { // save to existing category
            try? collection
                .document(selectedCategory.id!)
                .collection("items")
                .document(item.id!)
                .setData(from: item)
            // add rule if necessary
            if shouldAddRule { addRule(category: &selectedCategory) }
        } else { // save new category
            if shouldAddRule { newCategory.addRule(item.name) }
            let categoryDocument = try! collection.addDocument(from: newCategory)
            newCategory.id = categoryDocument.documentID
            let _ = try? collection
                .document(newCategory.id!)
                .collection("items")
                .addDocument(from: item)
        }
        
        // delete rule if necessary
        if shouldDeleteRule { deleteRule(category: &existingCategory!) }
    }
    
    private func updateExistingItem() {
        if oldCategory == category { // category stays the same
            // update item in old category
            let _ = try? collection
                .document(oldCategory!.id!)
                .collection("items")
                .document(item.id!)
                .setData(from: item)
            
            // add rule if necessary
            if shouldAddRule { addRule(category: &oldCategory!) }
        } else { // category changes
            // delete from old category
            collection
                .document(oldCategory!.id!)
                .collection("items")
                .document(item.id!)
                .delete()
            // save to new category
            if !addNewCategory { // save to existing
                let _ = try? collection
                    .document(selectedCategory.id!)
                    .collection("items")
                    .addDocument(from: item)
                // add rule if necessary
                if shouldAddRule { addRule(category: &selectedCategory) }
            } else { // save to new category
                if shouldAddRule { newCategory.addRule(item.name) }
                let categoryDocument = try! collection.addDocument(from: newCategory)
                newCategory.id = categoryDocument.documentID
                let _ = try? collection
                    .document(newCategory.id!)
                    .collection("items")
                    .addDocument(from: item)
            }
        }
        // delete rule if necessary
        if shouldDeleteRule { deleteRule(category: &existingCategory!) }
    }
    
    private func addRule(category: inout Category) {
        category.addRule(item.name)
        try? collection.document(category.id!).setData(from: category)
    }
    
    private func deleteRule(category: inout Category) {
        category.deleteRule(item.name)
        try? collection.document(category.id!).setData(from: category)
    }
}
