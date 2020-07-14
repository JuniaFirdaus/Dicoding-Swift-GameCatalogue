//
//  TableViewCell.swift
//  Game Catalogue
//
//  Created by PT Lintas Media Danawa on 01/07/20.
//  Copyright © 2020 JFS Studio. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgGame: UIImageView!
    @IBOutlet weak var titleHeaderGame: UILabel!
    @IBOutlet weak var titleSubGame: UILabel!
    @IBOutlet weak var titleOverviewGame: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgGame.layer.cornerRadius = 16
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
