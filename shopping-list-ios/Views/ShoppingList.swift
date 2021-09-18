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
            .listStyle(PlainListStyle())
            .navigationTitle("Shopping List")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { EditButton() }
                ToolbarItem(placement: .navigationBarTrailing) { trailingButtons }
            }
            .sheet(item: $activeSheet) { item in
                switch item {
                case .itemForm:
                    ItemForm(activeSheet: $activeSheet)
                case .categoryEditor:
                    CategoryEditor(activeSheet: $activeSheet)
                }
            }
        }
        .accentColor(.green)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var trailingButtons: some View {
        HStack {
            Menu {
                VStack {
                    Button(action: { viewModel.deleteAll(onlyCompleted: true) }) { Text("Delete Completed") }
                    Button(action: { viewModel.deleteAll(onlyCompleted: false) }) { Text("Delete All") }
                }
            } label: {
                Button(action: {}) { Image(systemName: "trash") }
            }
            Image(systemName: "tray")
                .foregroundColor(.green)
                .onTapGesture(perform: {
                    activeSheet = .categoryEditor
                })
            Image(systemName: "cart.badge.plus")
                .foregroundColor(.green)
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
