//
//  ToastMessageShadow.swift
//  KidsVideo
//
//  Created by headspinnerd on 2021/10/05.
//

import UIKit

public class ToastMessageShadow: UIView {
    override public func layoutSubviews() {
        super.layoutSubviews()
        dropShadow()
    }
    
    private func dropShadow(scale: Bool = true){
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 5
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 3
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 5).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
