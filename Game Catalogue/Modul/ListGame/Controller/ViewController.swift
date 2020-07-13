//
//  ViewController.swift
//  Game Catalogue
//
//  Created by PT Lintas Media Danawa on 01/07/20.
//  Copyright © 2020 JFS Studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchGame: UISearchBar!
    @IBOutlet weak var tableViewGame: UITableView!
    var gameItems = [GameItems]()
    var search:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewGame.delegate = self
        tableViewGame.dataSource = self
        searchGame.delegate = self
        searchGame.returnKeyType = .search
        searchGame.placeholder = "Search Game"
        
        getData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func showAbout(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "About", bundle: nil)
        let destination = storyBoard.instantiateViewController(withIdentifier: "aboutVC") as! AboutViewController
        destination.modalPresentationStyle = .fullScreen
        present(destination, animated: true, completion: nil)
    }
    
    func getData() {
        let components = URLComponents(string: BaseUrl.BaseUrl+"games")!
        
        let request = URLRequest(url: components.url!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse else { return }
            if let data = data {
                if response.statusCode == 200 {
                    do {
                        let responses = try JSONDecoder().decode(GameResponse.self, from: data)
                        self.gameItems.removeAll()
                        self.gameItems = responses.results
                        if self.gameItems.count != 0 {
                            DispatchQueue.main.async {
                                self.tableViewGame.reloadData()
                            }
                            
                        }
                    } catch let error {
                        print(error)
                    }
                } else {
                    print("ERROR: \(data), Http Status: \(response.statusCode)")
                }
            }
        }
        
        task.resume()
    }
    
    func getSearchData(game:String) {
        let components = URLComponents(string: BaseUrl.BaseUrl+"games?search=\(game)")!
        
        let request = URLRequest(url: components.url!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse else { return }
            if let data = data {
                if response.statusCode == 200 {
                    do {
                        let responses = try JSONDecoder().decode(GameResponse.self, from: data)
                        self.gameItems.removeAll()
                        self.gameItems = responses.results
                        if self.gameItems.count != 0 {
                            DispatchQueue.main.async {
                                self.tableViewGame.reloadData()
                                
                            }
                        }
                    } catch let error {
                        print(error)
                    }
                } else {
                    print("ERROR: \(data), Http Status: \(response.statusCode)")
                }
            }
        }
        
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as! TableViewCell
        cell.titleHeaderGame.text = gameItems[indexPath.row].name ?? ""
        cell.titleSubGame.text = gameItems[indexPath.row].released ?? ""
        cell.titleOverviewGame.text = "Rating " + "\(gameItems[indexPath.row].rating!)"
        
        let url = URL(string: gameItems[indexPath.row].background_image ?? "-" )
        
        UIImage.loadFrom(url: url!) { image in
            cell.imgGame.image = image
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let destination = storyBoard.instantiateViewController(withIdentifier: "detailVC") as! DetailViewController
        destination.modalPresentationStyle = .fullScreen
        destination.gameImage = gameItems[indexPath.row].background_image
        destination.gameName = gameItems[indexPath.row].name
        destination.gameRelease = gameItems[indexPath.row].released
        destination.gameRating = "\(gameItems[indexPath.row].rating!)"
        present(destination, animated: true, completion: nil)
    }
    
}

extension UIImage {
    
    public static func loadFrom(url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
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
            getData()
        }
        search = searchText
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if search == ""{
            getData()
        }else{
            getSearchData(game: search!)
            
        }
    }
    
}
