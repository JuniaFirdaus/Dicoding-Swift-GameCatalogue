//
//  ViewController.swift
//  Game Catalogue
//
//  Created by PT Lintas Media Danawa on 01/07/20.
//  Copyright © 2020 JFS Studio. All rights reserved.
//

import UIKit
import JGProgressHUD
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchGame: UISearchBar!
    @IBOutlet weak var tableViewGame: UITableView!
    @IBOutlet weak var switchGame: UISwitch!
    
    var isFavoriteSwitched:Bool?
    var hud : JGProgressHUD?
    var gameItems = [GameItems]()
    var search:String?
    
    private var gameFavoriteItems: [FavoriteModel] = []
    private lazy var memberProvider: FavoriteProvider = { return FavoriteProvider() }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hud = JGProgressHUD(style: .dark)
        tableViewGame.delegate = self
        tableViewGame.dataSource = self
        searchGame.delegate = self
        searchGame.returnKeyType = .search
        searchGame.placeholder = "Search Game"
        
        getDataGame()
    }
    
    @IBAction func switchFavoriteGame(_ sender: UISwitch) {
        if sender.isOn {
            isFavoriteSwitched = true
            getData()
        }else{
            getDataGame()
            isFavoriteSwitched = false
        }
    }
    
    func getDataGame(){
        hud?.show(in: self.view, animated: true)
        initProviderServices.request(InitService.getDataGames) { (result) in
            switch result{
            case .success(let response):
                self.hud?.dismiss(animated: true)
                if response.statusCode == 200 {
                    do {
                        let responses = try JSONDecoder().decode(GameResponse.self, from: response.data)
                        self.gameItems.removeAll()
                        self.gameItems = responses.results
                        self.tableViewGame.reloadData()
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
    
    private func getData(){
        self.memberProvider.getAllMember{ (result) in
            DispatchQueue.main.async {
                self.gameFavoriteItems = result
                self.tableViewGame.reloadData()
            }
        }
    }
        
    func getSerachDataGame(game:String){
        hud?.show(in: self.view, animated: true)
        initProviderServices.request(InitService.getSearchDataGames(game)) { (result) in
            
            self.searchGame.endEditing(true)
            switch result{
            case .success(let response):
                print(response.request as Any)
                self.hud?.dismiss(animated: true)
                if response.statusCode == 200 {
                    do {
                        let responses = try JSONDecoder().decode(GameResponse.self, from: response.data)
                        self.gameItems.removeAll()
                        self.gameItems = responses.results
                        self.tableViewGame.reloadData()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFavoriteSwitched == true {
            return gameFavoriteItems.count
        }else{
            return gameItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as! TableViewCell
        
        if isFavoriteSwitched == true {
            cell.titleHeaderGame.text = gameFavoriteItems[indexPath.row].name_game ?? ""
            cell.titleSubGame.text = gameFavoriteItems[indexPath.row].release_game ?? ""
            cell.titleOverviewGame.text = gameFavoriteItems[indexPath.row].rating_game
            Utils.loadImage(url: gameFavoriteItems[indexPath.row].image_game ?? "-", imageAttach: cell.imgGame)
        }else{
            cell.titleHeaderGame.text = gameItems[indexPath.row].name ?? ""
            cell.titleSubGame.text = gameItems[indexPath.row].released ?? ""
            cell.titleOverviewGame.text = "Rating " + "\(gameItems[indexPath.row].rating!)"
            Utils.loadImage(url: gameItems[indexPath.row].background_image ?? "-", imageAttach: cell.imgGame)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "detailVC", sender: indexPath);
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailVC" {
            if isFavoriteSwitched == true {
                let row = (sender as! NSIndexPath).row
                let destination = segue.destination as! DetailViewController
                destination.modalPresentationStyle = .fullScreen
                destination.idGame = Int(gameFavoriteItems[row].id_game!)
            }else{
                let row = (sender as! NSIndexPath).row
                let destination = segue.destination as! DetailViewController
                destination.modalPresentationStyle = .fullScreen
                destination.idGame = gameItems[row].id
            }
        }
    }
}

extension ViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchGame.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            switchGame.isOn = false
            getDataGame()
        }
        search = searchText
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if search == ""{
            switchGame.isOn = false
            isFavoriteSwitched = false
            getDataGame()
        }else{
            switchGame.isOn = false
            isFavoriteSwitched = false
            getSerachDataGame(game: search!)
            
        }
    }
    
}
