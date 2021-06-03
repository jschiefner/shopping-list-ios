//
//  CategoryEditor.swift
//  shopping-list-ios
//
//  Created by Jonas Schiefner on 29.05.21.
//

import SwiftUI

struct CategoryEditor: View {
    @Binding var activeSheet: ActiveSheet?
    @StateObject var viewModel = CategoriesViewModel()
        
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.categories, id: \.id) { category in
                    NavigationLink(category.name, destination: RulesView(category: category))
                }
                .onMove(perform: move)
                .onDelete(perform: delete)
            }.onAppear {
                viewModel.connectData()
            }
            .navigationBarTitle("Categories", displayMode: .inline)
            .listStyle(PlainListStyle())
            .navigationBarItems(leading: EditButton(), trailing: doneButton)
        }
    }
    
    var doneButton: some View {
        Button("Done") {
            activeSheet = nil
        }
    }
    
    func delete(indexSet: IndexSet) {
        // TODO: show alert if default category (pass in @State var that checks if alert should be displayed
        indexSet.forEach { index in
            viewModel.delete(itemAt: index)
        }
    }
    
    func move(index: IndexSet, to: Int) {
        viewModel.move(from: index.first!, to: to)
    }
}

struct CategoryEditor_Previews: PreviewProvider {
    @State static var activeSheet: ActiveSheet? = .categoryEditor
    
    static var previews: some View {
        CategoryEditor(activeSheet: $activeSheet)
    }
}
