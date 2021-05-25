//
//  ItemForm.swift
//  shopping-list-ios
//
//  Created by Jonas Schiefner on 20.05.21.
//

import SwiftUI

struct ItemForm: View {
    @Binding var overlayDisplayed: Bool
    
    @State var name = ""
    let categories = [
        Category(id: "a", name: "Obst", position: 1),
        Category(id: "b", name: "Gemüse", position: 2),
    ]
    @State var selectedCategory = Category(id: "a", name: "Obst", position: 1)
    @State var showAddRule = true
    @State var showDeleteRule = true
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item")) {
                    TextField("Name", text: $name)
                    HStack {
                        Text("Category")
                        Spacer()
                        Picker(selectedCategory.name, selection: $selectedCategory) {
                            ForEach(categories, id: \.id) { category in
                                Text(category.name).tag(category)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
                Section(header: Text("Rules")) {
                    Toggle(isOn: $showAddRule) {
                        Text("name -> category")
                    }
                    Toggle(isOn: $showDeleteRule) {
                        Text("name -> category")
                    }.toggleStyle(SwitchToggleStyle(tint: Color.red))
                }
            }
            .navigationBarTitle(Text("New Item"), displayMode: .inline)
            .navigationBarItems(leading: cancelButton, trailing: doneButton)
        }
    }
    
    var cancelButton: some View {
        Button("Cancel") {
            overlayDisplayed.toggle()
        }
    }
    
    var doneButton: some View {
        Button("Done") {
            // save item
            overlayDisplayed.toggle()
        }
    }
}

struct ItemForm_Previews: PreviewProvider {
    @State static var overlayDisplayed = true
    
    static var previews: some View {
        ItemForm(overlayDisplayed: $overlayDisplayed)
    }
}
