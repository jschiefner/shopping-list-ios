//
//  UIDevice.swift
//  shopping-list-ios
//
//  Created by Jonas Schiefner on 20.05.21.
//

import SwiftUI

extension UIDevice {
    static func vibrate() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}
