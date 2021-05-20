//
//  ItemsView.swift
//  shopping-list-ios
//
//  Created by Jonas Schiefner on 18.05.21.
//

import SwiftUI

struct ItemsView: View {
    @ObservedObject var viewModel: ItemsViewModel
    let categoryId: String
    
    init(categoryId: String) {
        self.categoryId = categoryId
        viewModel = ItemsViewModel(categoryId: categoryId)
        viewModel.connectData()
    }
    
    var body: some View {
        return ForEach(viewModel.items) { item in
            ItemView(item: item, categoryId: categoryId)
        }
        .onDelete(perform: delete)
    }
    
    func delete(indexSet: IndexSet) {
        indexSet.forEach { index in
            viewModel.delete(itemAt: index)
        }
    }
}

struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView(categoryId: "")
    }
}
