//
//  ItemsView.swift
//  shopping-list-ios
//
//  Created by Jonas Schiefner on 18.05.21.
//

import SwiftUI

struct ItemsTableView: View {
    @ObservedObject var viewModel: ItemsTableViewModel
    let categoryId: String
    
    init(categoryId: String) {
        self.categoryId = categoryId
        viewModel = ItemsTableViewModel(categoryId: categoryId)
        viewModel.connectData()
    }
    
    var body: some View {
        return ForEach(viewModel.items) { item in
            ItemTableView(item: item, categoryId: categoryId)
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
        ItemsTableView(categoryId: "")
    }
}
