//
//  ContentView.swift
//  shopping-list-ios
//
//  Created by Jonas Schiefner on 18.05.21.
//

import SwiftUI

struct ShoppingList: View {
    @ObservedObject var viewModel = CategoriesViewModel()
    @State var overlayDisplayed = true
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.categories, id: \.id) { category in
                    Section(header: Text(category.name)) {
                        ItemsTableView(category: category)
                    }
                }
            }.onAppear() {
                viewModel.connectData()
            }
            .navigationTitle("Shopping List")
            .listStyle(PlainListStyle())
            .navigationBarItems(leading: EditButton(), trailing: addButton)
            .sheet(isPresented: $overlayDisplayed, content: {
                ItemForm(overlayDisplayed: $overlayDisplayed)
            })
        }
    }
    
    var addButton: some View {
        Image(systemName: "square.and.pencil")
            .foregroundColor(.blue)
            .onTapGesture(perform: {
                overlayDisplayed.toggle()
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingList()
    }
}
