//
//  Utils.swift
//  Game Catalogue
//
//  Created by PT Lintas Media Danawa on 03/07/20.
//  Copyright © 2020 JFS Studio. All rights reserved.
//
import UIKit
import Foundation

struct Utils {
    static func viewShadow(view:UIView, color:UIColor, corderRadius:Int) -> Void {
        view.layer.backgroundColor = color.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 4
        view.layer.cornerRadius = CGFloat(corderRadius)
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
    }
}
