//
//  CategoryEditor.swift
//  shopping-list-ios
//
//  Created by Jonas Schiefner on 29.05.21.
//

import SwiftUI

struct CategoryEditor: View {
    @Binding var activeSheet: ActiveSheet?
    
    var body: some View {
        Button("Close") {
            activeSheet = nil
        }
    }
}

struct CategoryEditor_Previews: PreviewProvider {
    @State static var activeSheet: ActiveSheet? = .categoryEditor
    
    static var previews: some View {
        CategoryEditor(activeSheet: $activeSheet)
    }
}
