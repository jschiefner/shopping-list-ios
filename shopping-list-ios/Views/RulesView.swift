//
//  RulesView.swift
//  shopping-list-ios
//
//  Created by Jonas Schiefner on 03.06.21.
//

import SwiftUI

struct RulesView: View {
    let category: Category
    @ObservedObject var viewModel: RulesViewModel
    
    init(category: Category) {
        self.category = category
        self.viewModel = RulesViewModel(category: category)
    }
    
    var body: some View {
        List {
            ForEach(0..<viewModel.category.rules.count, id: \.self) { index in
                TextField("Rule", text: $viewModel.category.rules[index], onCommit: viewModel.save)
                    .autocapitalization(.none)
            }
            .onDelete(perform: viewModel.delete)
        }
        .navigationTitle(category.name)
        .navigationBarItems(trailing: addButton)
    }
    
    var addButton: some View {
        Image(systemName: "plus")
            .foregroundColor(.blue)
            .onTapGesture(perform: viewModel.addRow)
    }
}

struct RulesView_Previews: PreviewProvider {
    static var previews: some View {
        RulesView(category: Category.defaultCategory)
    }
}
