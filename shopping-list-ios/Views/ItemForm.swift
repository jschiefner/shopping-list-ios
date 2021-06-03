//
//  ItemForm.swift
//  shopping-list-ios
//
//  Created by Jonas Schiefner on 20.05.21.
//

import SwiftUI

struct ItemForm: View {
    @Binding var activeSheet: ActiveSheet?
    @ObservedObject var viewModel: ItemFormViewModel
    
    init(activeSheet: Binding<ActiveSheet?>) {
        self._activeSheet = activeSheet
        self.viewModel = ItemFormViewModel()
    }
    
    init(activeSheet: Binding<ActiveSheet?>, item: Item, category: Category) {
        self._activeSheet = activeSheet
        self.viewModel = ItemFormViewModel(item: item, category: category)
    }
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    CheckBox(checked: $viewModel.item.completed)
                    TextField("Name", text: $viewModel.item.name, onCommit: viewModel.itemNameOnEnter)
                }
                Section(header: Text("Category")) {
                    Toggle(isOn: $viewModel.addNewCategory) {
                        Text("New Category")
                    }
                    .onChange(of: viewModel.addNewCategory, perform: viewModel.newCategoryToggled)
                    if !viewModel.addNewCategory {
                        HStack {
                            Text("Category")
                            Spacer()
                            Picker(viewModel.selectedCategory.name, selection: $viewModel.selectedCategory) {
                                ForEach(viewModel.categories, id: \.id) { category in
                                    Text(category.name).tag(category)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .onChange(of: viewModel.selectedCategory.name, perform: viewModel.onCategoryPicked)
                        }
                    } else {
                        TextField("Category Name", text: $viewModel.newCategory.name, onCommit: viewModel.newCategoryOnEnter)
                    }
                }
                if viewModel.showAddRule || viewModel.showDeleteRule {
                    Section(header: Text("Rules")) {
                        if (viewModel.showAddRule) {
                            Toggle(isOn: $viewModel.addRule) {
                                Text("\(viewModel.lowercaseItemName) → \(viewModel.category.name)")
                            }
                        }
                        if (viewModel.showDeleteRule && viewModel.existingCategory != nil) {
                            Toggle(isOn: $viewModel.deleteRule) {
                                Text("\(viewModel.lowercaseItemName) → \(viewModel.existingCategory!.name)")
                            }
                            .toggleStyle(SwitchToggleStyle(tint: Color.red))
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle()) // only applies for List instead of Form
            .navigationBarTitle(Text(viewModel.addingItem ? "New Item" : "Update Item"), displayMode: .inline)
            .navigationBarItems(leading: cancelButton, trailing: doneButton)
        }
    }
    
    var cancelButton: some View {
        Button("Cancel") {
            activeSheet = nil
        }
    }
    
    var doneButton: some View {
        Button("Done") {
            viewModel.save()
            activeSheet = nil
        }
        .disabled(viewModel.saveDisabled)
    }
}

struct ItemForm_Previews: PreviewProvider {
    @State static var activeSheet: ActiveSheet? = .itemForm
    
    static var previews: some View {
        ItemForm(activeSheet: $activeSheet)
    }
}
