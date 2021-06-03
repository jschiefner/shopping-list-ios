//
//  ContentView.swift
//  shopping-list-ios
//
//  Created by Jonas Schiefner on 18.05.21.
//

import SwiftUI

struct ShoppingList: View {
    @StateObject var viewModel = CategoriesViewModel()
    @State var activeSheet: ActiveSheet?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.categories, id: \.id) { category in
                    ItemsTableView(category: category, viewModel: ItemsTableViewModel(category: category))
                }
            }.onAppear() {
                viewModel.connectData()
            }
            .navigationTitle("Shopping List")
            .listStyle(PlainListStyle())
            .navigationBarItems(leading: EditButton(), trailing: trailingButtons)
            .sheet(item: $activeSheet) { item in
                switch item {
                case .itemForm:
                    ItemForm(activeSheet: $activeSheet)
                case .categoryEditor:
                    CategoryEditor(activeSheet: $activeSheet)
                }
            }
        }
    }
    
    var trailingButtons: some View {
        HStack {
            Image(systemName: "tray")
                .foregroundColor(.blue)
                .onTapGesture(perform: {
                    activeSheet = .categoryEditor
                })
            Image(systemName: "cart.badge.plus")
                .foregroundColor(.blue)
                .onTapGesture(perform: {
                    activeSheet = .itemForm
                })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingList()
    }
}
