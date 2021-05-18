//
//  ItemsView.swift
//  shopping-list-ios
//
//  Created by Jonas Schiefner on 18.05.21.
//

import SwiftUI

struct ItemsView: View {
    @ObservedObject var viewModel: ItemViewModel
    
    init(categoryId: String) {
        viewModel = ItemViewModel(categoryId: categoryId)
        viewModel.connectData()
    }
    
    var body: some View {
        return ForEach(viewModel.items) { item in
            Text(item.name)
        }
    }
}

struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView(categoryId: "")
    }
}
