//
//  ItemsView.swift
//  shopping-list-ios
//
//  Created by Jonas Schiefner on 18.05.21.
//

import SwiftUI

struct ItemsTableView: View {
    let category: Category
    @StateObject var viewModel: ItemsTableViewModel
    
    var body: some View {
        return ForEach(viewModel.items) { item in
            ItemTableView(item: item, category: category)
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
        ItemsTableView(category: Category.defaultCategory, viewModel: ItemsTableViewModel(category: Category.defaultCategory))
    }
}
