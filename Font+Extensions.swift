//
//  Font+Extensions.swift
//  KidsVideo
//
//  Created by Gemini Code Assist on 2023-10-27.
//

import SwiftUI

extension Font {
    /// An enum to manage custom font names, preventing typos and centralizing font management.
    enum CustomFont {
        case penguinAttack

        var name: String {
            // This name MUST match the PostScript name from the font log.
            return "PenguinAttack"
        }
    }

    static func custom(_ font: CustomFont, size: CGFloat) -> Font {
        // Explicitly call the system's `custom` initializer that takes a String
        // to avoid recursive ambiguity with our own `custom` static func.
        return Font.custom(font.name, size: size)
    }
}