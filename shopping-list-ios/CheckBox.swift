//
//  CheckBox.swift
//  shopping-list-ios
//
//  Created by Jonas Schiefner on 20.05.21.
//

import SwiftUI

struct CheckBox: View {
    @Binding var checked: Bool
    var callback: () -> Void

    var body: some View {
        Image(systemName: checked ? "checkmark.circle.fill" : "circle")
            .resizable()
            .frame(width: 23, height: 23)
            .scaledToFit()
            .foregroundColor(checked ? Color(UIColor.systemGreen) : Color.secondary)
            .onTapGesture {
                self.checked.toggle()
                UIDevice.vibrate()
                callback()
            }
    }
}

struct CheckBoxView_Previews: PreviewProvider {
    struct CheckBoxViewHolder: View {
        @State var checked = true

        var body: some View {
            CheckBox(checked: $checked) {
                
            }
        }
    }

    static var previews: some View {
        CheckBoxViewHolder()
    }
}
