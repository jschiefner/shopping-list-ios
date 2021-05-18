//
//  ItemsView.swift
//  shopping-list-ios
//
//  Created by Jonas Schiefner on 18.05.21.
//

import SwiftUI

struct ItemsView: View {
    @ObservedObject var viewModel: ItemsViewModel
    
    init(categoryId: String) {
        viewModel = ItemsViewModel(categoryId: categoryId)
        viewModel.connectData()
    }
    
    var body: some View {
        return ForEach(viewModel.items) { item in
            Text(item.name)
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
