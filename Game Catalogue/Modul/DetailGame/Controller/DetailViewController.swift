//
//  DetailViewController.swift
//  Game Catalogue
//
//  Created by PT Lintas Media Danawa on 03/07/20.
//  Copyright © 2020 JFS Studio. All rights reserved.
//

import UIKit
import JGProgressHUD
import AVKit
import CoreData

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var lblnameGame: UILabel!
    @IBOutlet weak var lblreleaseGame: UILabel!
    @IBOutlet weak var lblrattingGame: UILabel!
    @IBOutlet weak var imgGame: UIImageView!
    
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var gamesegmentedController: UISegmentedControl!
    @IBOutlet weak var detailTableView: UITableView!
    
    private var gameFavoriteItems: [FavoriteModel] = []
    private lazy var favoriteProvider: FavoriteProvider = { return FavoriteProvider() }()
    
    var hud : JGProgressHUD?
    
    var publisherItems:[Publisher] = []
    var platformItems:[Platforms] = []
    var storeItems:[Stores] = []
    
    var descriptionGame:String?
    var idGame:Int?
    var imageGame:String?
    var switchTabId:Int?
    var isAvailabe:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hud = JGProgressHUD(style: .dark)
        detailTableView.delegate = self
        detailTableView.dataSource = self
        
        imgGame.layer.cornerRadius = 8
        imgGame.layer.borderWidth = 1.5
        imgGame.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        getDetailGame(id: idGame ?? 0)
        validateFavoriteGame()
    }
    
    func getDetailGame(id:Int){
        hud?.show(in: self.view, animated: true)
        initProviderServices.request(InitService.getDetailGames(id)) { (result) in
            switch result{
            case .success(let response):
                self.hud?.dismiss(animated: true)
                if response.statusCode == 200 {
                    do {
                        let responses = try JSONDecoder().decode(GameDetailResponse.self, from: response.data)
                        
                        self.lblnameGame.text = responses.name
                        self.lblrattingGame.text = "\(responses.rating ?? 0.00)"
                        self.lblreleaseGame.text = "\("Release " + responses.released!)"
                        
                        if responses.clip?.clip != nil {
                            self.getVideo(urlVidio: (responses.clip?.clip)!)
                        }else{
                            self.getBackDrop(urlImage: responses.background_image_additional ?? "")
                        }
                        
                        self.publisherItems = responses.publishers ?? []
                        self.platformItems = responses.platforms ?? []
                        self.storeItems = responses.stores ?? []
                        self.descriptionGame = responses.description
                        self.imageGame = responses.background_image
                        self.gamesegmentedController.selectedSegmentIndex = 0
                        Utils.loadImage(url: responses.background_image ?? "", imageAttach: self.imgGame)
                        
                        if self.gamesegmentedController.selectedSegmentIndex == 0{
                            self.switchTabId = 0
                            self.detailTableView.reloadData()
                        }
                        
                    } catch let error {
                        print(error)
                    }
                }
            case .failure(let fail):
                self.hud?.dismiss(animated: true)
                print(fail)
            }
        }
    }
    
    func saveGame() {
        let x = Int32(exactly: idGame! as NSNumber)
        favoriteProvider.createMember(x!, lblnameGame.text!, lblreleaseGame.text!, lblrattingGame.text!, imageGame!) {
            DispatchQueue.main.async {
                self.btnFavorite.tintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            }
        }
        
    }
    
    func deleteGame(id:Int) {
        favoriteProvider.deleteMember(id) {
            DispatchQueue.main.async {
                self.btnFavorite.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
    }
    
    func validateFavoriteGame(){
        let x = Int32(exactly: idGame! as NSNumber)
        self.favoriteProvider.getAllMember{ (result) in
            DispatchQueue.main.async {
                self.gameFavoriteItems = result
                print(self.gameFavoriteItems.count)
                
                for i in 0..<self.gameFavoriteItems.count{
                    if x == self.gameFavoriteItems[i].id_game {
                        self.isAvailabe = true
                    }
                }
                print(self.isAvailabe as Any)
                self.isFavoriteGame(status: self.isAvailabe)
            }
        }
    }
        
    func alert(_ message: String ){
        let allertController = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        allertController.addAction(alertAction)
        self.present(allertController, animated: true, completion: nil)
    }
    
    
    @IBAction func btnFavoriteTapped(_ sender: Any) {
        if isAvailabe == true {
            deleteGame(id: idGame!)
        }else{
            saveGame()
        }
    }
    
    func isFavoriteGame(status:Bool){
        if status == true {
            btnFavorite.tintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }else{
            btnFavorite.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    
    @IBAction func segmentDetailGame(_ sender: UISegmentedControl) {
        
        switch gamesegmentedController.selectedSegmentIndex {
        case 0:
            switchTabId = 0
            detailTableView.reloadData()
            print(storeItems)
        case 1:
            switchTabId = 1
            detailTableView.reloadData()
            print(publisherItems)
        case 2:
            switchTabId = 2
            detailTableView.reloadData()
            print(platformItems)
        default:
            print("nil")
        }
    }
    
    func getVideo(urlVidio:String){
        let videoURL = URL(string: urlVidio)
        let videoAsset = AVAsset(url: videoURL!)
        let videoPlayerItem = AVPlayerItem(asset: videoAsset)
        let player = AVPlayer(playerItem: videoPlayerItem)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.videoView.bounds
        self.videoView.layer.addSublayer(playerLayer)
        player.play()
        
    }
    
    func getBackDrop(urlImage:String){
        let imageView = UIImageView()
        Utils.loadImage(url: urlImage, imageAttach: imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: videoView.frame.width, height: videoView.frame.height)
        self.videoView.addSubview(imageView)
        self.videoView.bringSubviewToFront(imageView)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch switchTabId {
        case 0:
            return storeItems.count
        case 1:
            return publisherItems.count
        case 2:
            return platformItems.count
        default:
            print("nil")
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailTVC") as! DetailTableViewCell
        switch switchTabId {
        case 0:
            let data = storeItems
            cell.lblDetail.text = data[indexPath.row].store?.name
            Utils.loadImage(url: (data[indexPath.row].store?.image_background)!, imageAttach: cell.imgDetail)
        case 1:
            let data = publisherItems
            cell.lblDetail.text = data[indexPath.row].name
            Utils.loadImage(url: data[indexPath.row].image_background!, imageAttach: cell.imgDetail)
            
        case 2:
            let data = platformItems
            cell.lblDetail.text = data[indexPath.row].platform?.name
            Utils.loadImage(url: (data[indexPath.row].platform?.image_background)!, imageAttach: cell.imgDetail)
            
        default:
            print("nil")
        }
        return cell
    }
}
