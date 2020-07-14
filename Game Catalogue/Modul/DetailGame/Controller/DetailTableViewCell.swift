//
//  DetailTableViewCell.swift
//  Game Catalogue
//
//  Created by PT Lintas Media Danawa on 13/07/20.
//  Copyright © 2020 JFS Studio. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var imgDetail: UIImageView!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var viewLabel: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewLabel.layer.cornerRadius = 8
        viewLabel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        imgDetail.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
