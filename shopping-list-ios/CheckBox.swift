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
        // Todo: make this a round circle like in "Reminders", same size, same look just green
        Image(systemName: checked ? "checkmark.square.fill" : "square")
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
        @State var checked = false

        var body: some View {
            CheckBox(checked: $checked) {
                
            }
        }
    }

    static var previews: some View {
        CheckBoxViewHolder()
    }
}
