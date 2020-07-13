//
//  DetailViewController.swift
//  Game Catalogue
//
//  Created by PT Lintas Media Danawa on 03/07/20.
//  Copyright © 2020 JFS Studio. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageGame: UIImageView!
    @IBOutlet weak var nameGame: UILabel!
    @IBOutlet weak var releaseGame: UILabel!
    @IBOutlet weak var rattingGame: UILabel!

    var gameImage:String?
    var gameName:String?
    var gameRating:String?
    var gameRelease:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameGame.text = gameName ?? ""
        rattingGame.text = gameRating ?? ""
        releaseGame.text = gameRelease ?? ""
        
        let url = URL(string: gameImage ?? "")

        UIImage.loadFrom(url: url!) { image in
            self.imageGame.image = image
        }
    }
    
    @IBAction func dissmiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
