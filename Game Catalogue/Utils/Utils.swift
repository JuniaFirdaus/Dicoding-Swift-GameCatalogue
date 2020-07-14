//
//  Utils.swift
//  Game Catalogue
//
//  Created by PT Lintas Media Danawa on 03/07/20.
//  Copyright © 2020 JFS Studio. All rights reserved.
//
import UIKit
import Foundation
import Kingfisher

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
    
    static func loadImage(url:String, imageAttach:UIImageView){
        
        let url = URL(string: url)
        
        imageAttach.kf.indicatorType = .activity
        imageAttach.kf.setImage(with: url, placeholder: UIImage(systemName: "photo.fill"), options: [
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1))
        ]) {
            
            (image, error, type, url) in
            if error == nil && image != nil {
                DispatchQueue.main.async {
                    imageAttach.image = image
                }
            } else {
                imageAttach.image = UIImage(systemName: "photo.fill")
                
            }
        }
        
    }
}
