//
//  PlayerControlCommonButton.swift
//  KidsVideo
//
//  Created by headspinnerd on 2021/10/09.
//

import UIKit

class PlayerControlCommonButton: UIButton {
    init(systemImageName: String, size: CGSize? = nil) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setImage(UIImage(systemName: systemImageName), for: .normal)
        tintColor = UIColor(white:1, alpha:1)
        contentVerticalAlignment = .fill
        contentHorizontalAlignment = .fill
        alpha = 0.6
        if let size = size {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
