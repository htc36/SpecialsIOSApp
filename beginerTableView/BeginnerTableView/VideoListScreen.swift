//
//  VideoListScreen.swift
//  BeginnerTableView
//
//  Created by Sean Allen on 5/19/17.
//  Copyright © 2017 Sean Allen. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class VideoListScreen: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var videos: [Video] = []
    var items: [Items] = []
    var count = 20
    var date = "04/08/20"
    var url = URLComponents(string: "http://45.76.124.20:8080/api/getProducts?limit=20")!
    let searchController = UISearchController(searchResultsController: nil)
    var searchQuery = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let url = "http://45.76.124.20:8080/api/getProducts?dateOfSpecials=04/08/20&limit=20"
        url.queryItems = [URLQueryItem(name: "dateOfSpecials", value: "04/08/20")]
        getData(from: url)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Seach for a product"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    private func getData(from url: URLComponents){
        let url = URL(string: "http://45.76.124.20:8080/api/getProducts?dateOfSpecials=" + date + "&limit=" + String(count) + "&search=" + searchQuery)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
            guard let data = data, error == nil else {
                print("bad")
                return
            }
            var result: Response?
            do {
                result = try JSONDecoder().decode(Response.self, from: data)
            }
            catch {
                print(error.localizedDescription)
            }
            guard let json = result else {
                return
            }
            
            self.items = json.rows
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            })

            task.resume()
            self.tableView.reloadData()
        print(self.items)


    }
    
}


@available(iOS 11.0, *)
extension VideoListScreen: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as! VideoCell
        if(items.count==0){
            return cell
        }
        let itemm = items[indexPath.row]
        cell.setItem(item: itemm)
        
        return cell
    }
}

@available(iOS 11.0, *)
extension VideoListScreen: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        searchQuery = searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        getData(from: url)
        
    }
}





