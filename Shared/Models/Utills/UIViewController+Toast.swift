//
//  UIViewController+Toast.swift
//  KidsVideo
//
//  Created by headspinnerd on 2021/10/05.
//

import Foundation
import UIKit

enum ToastType {
    case alert, success, notice
}

extension UIViewController {
    func showToast(message: String, font: UIFont?, type: ToastType) {
        //ラベルのコンテナViewを作る。
        let toastView = ToastMessageShadow(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 35))
        switch type {
        case .alert:
            toastView.backgroundColor = .red
            break;
        case .success:
            toastView.backgroundColor = .green
            break;
        case .notice:
            toastView.backgroundColor = .blue
            break;
        }
        // ラベルも作成
        let toastLabel = UILabel(frame: CGRect(x: 10, y: 9, width: toastView.bounds.width - 10, height: 17))
        if let font = font{
            toastLabel.font = font
        }
        toastLabel.text = message
        toastLabel.textColor = .white
        toastLabel.lineBreakMode = .byTruncatingTail
        toastLabel.textAlignment = .left
        //ここでラベルをメッセージの幅に合わせる
        toastLabel.sizeToFit()
        //右上の座標を計算する
        let xPosition = self.view.frame.width - toastLabel.frame.width
        //ラベルコンテナのFrameを指定し直す。
        //@x:                       = 右から10pt離れるようにする。横幅に+20するから30
        //@y:                       = Status Bar(44pt) + Navigation Bar(97pt) + 10
        //@width:                   = ラベルの横幅 + 20
        //@height:                  = フォントサイズが17でy paddingを9にしてるから 17 + 18 = 35
        toastView.frame = CGRect(x: ceil(xPosition) - 30, y: 151.0, width: toastLabel.frame.width + 20, height: 35)
        //autoresizingMaskでその座標から動かないようにする。念のため
        toastView.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        toastView.addSubview(toastLabel)
        self.view.addSubview(toastView)
        
        UIView.animate(withDuration: 1.0,
                       delay: 2.0,
                       options: .curveEaseOut,
                       animations: {
                        toastView.alpha = 0.0
                        toastView.center.y -= 35
        }, completion: { (isCompleted) in
            toastView.removeFromSuperview()
        })
    }
}
