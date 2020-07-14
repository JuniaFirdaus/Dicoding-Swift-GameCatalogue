//
//  AbouViewController.swift
//  Game Catalogue
//
//  Created by PT Lintas Media Danawa on 09/07/20.
//  Copyright © 2020 JFS Studio. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPoint: UILabel!
    @IBOutlet weak var lblStartJoin: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var viewBelajar: UIView!
    @IBOutlet weak var viewChallange: UIView!
    @IBOutlet weak var viewEvent: UIView!
    @IBOutlet weak var lblEmailName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

    }
    
    func setupView() {
        Utils.viewShadow(view: viewEvent, color: #colorLiteral(red: 0.9491188932, green: 1, blue: 0.3486513472, alpha: 1), corderRadius: 8)
        Utils.viewShadow(view: viewChallange,color: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), corderRadius: 8)
        Utils.viewShadow(view: viewBelajar, color: #colorLiteral(red: 0.3992670415, green: 0.7647058964, blue: 0.7317974462, alpha: 1), corderRadius: 8)
        
        imgProfile.image = UIImage(named: "juniaf")
        imgProfile.layer.cornerRadius = 8
        
        lblEmailName.text = "firdausjunia@gmail.com"
        lblName.text = "Junia Firdaus"
        lblPoint.text = "4300 XP"
        lblStartJoin.text = "Bergabung sejak 03 Jun 2016"
        lblAddress.text = "Kota Bekasi, Jawa Barat"
    }
    
    @IBAction func backBarItem(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
