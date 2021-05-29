//
//  ItemView.swift
//  shopping-list-ios
//
//  Created by Jonas Schiefner on 20.05.21.
//

import SwiftUI

struct ItemTableView: View {
    @ObservedObject var viewModel: ItemTableViewModel
    @State var activeSheet: ActiveSheet?
    
    let item: Item
    let category: Category
    
    init(item: Item, category: Category) {
        self.viewModel = ItemTableViewModel(item: item, categoryId: category.id!)
        self.item = item
        self.category = category
    }
    
    var body: some View {
        HStack {
            CheckBox(checked: $viewModel.item.completed, callback: viewModel.updateCompleted)
            TextField("Name", text: $viewModel.item.name, onCommit: viewModel.updateName)
        }
        .contextMenu {
            VStack {
                Button("Edit") {
                    activeSheet = .itemForm
                }
                Button("Delete") {
                    viewModel.delete()
                }
            }
        }
        .sheet(item: $activeSheet) { value in
            if value == .itemForm {
                ItemForm(activeSheet: $activeSheet, item: item, category: category)
            }
        }
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemTableView(item: Item(name: "test", completed: true), category: Category.defaultCategory)
    }
}

