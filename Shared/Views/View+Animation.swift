//
//  View+Animation.swift
//  KidsVideo
//
//  Created by headspinnerd on 2021/09/28.
//

import SwiftUI

extension View {
    func wiggle(isActive: Bool) -> some View {
        self
            .rotationEffect(.degrees(isActive ? 2.5 : 0))
            .rotation3DEffect(.degrees(isActive ? 5 : 0), axis: (x: 0, y: isActive ? -5 : 0, z: 0))
            .animation(isActive ? Animation.easeInOut(duration: 0.15).repeatForever(autoreverses: true) : nil)
    }
}
