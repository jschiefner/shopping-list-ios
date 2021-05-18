//
//  ContentView.swift
//  shopping-list-ios
//
//  Created by Jonas Schiefner on 18.05.21.
//

import SwiftUI

struct ShoppingList: View {
    @ObservedObject var viewModel = CategoriesViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.categories, id: \.id) { category in
                    Section(header: Text(category.name)) {
                        ItemsView(categoryId: category.id!)
                    }
                }
            }.onAppear() {
                viewModel.connectData()
            }
            .navigationTitle("Shopping List")
            .navigationBarItems(leading: EditButton())
            .listStyle(PlainListStyle())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingList()
    }
}
