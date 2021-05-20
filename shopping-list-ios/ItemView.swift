//
//  ItemView.swift
//  shopping-list-ios
//
//  Created by Jonas Schiefner on 20.05.21.
//

import SwiftUI

struct ItemView: View {
    @ObservedObject var viewModel: ItemViewModel
    
    init(item: Item, categoryId: String) {
        self.viewModel = ItemViewModel(item: item, categoryId: categoryId)
    }
    
    var body: some View {
        HStack {
            CheckBox(checked: $viewModel.item.completed, callback: viewModel.updateCompleted)
            TextField("Name", text: $viewModel.item.name, onCommit: viewModel.updateName)
        }
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView(item: Item(name: "test", completed: true), categoryId: "")
    }
}