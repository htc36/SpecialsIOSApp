//
//  VideoListScreen.swift
//  BeginnerTableView
//
//  Created by Sean Allen on 5/19/17.
//  Copyright © 2017 Sean Allen. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class VideoListScreen: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var videos: [Video] = []
    var items: [Items] = []
    var totalProducts = 20
    var count = 10
    var offset = 0
    var date = "2020-08-04"
    var url = URLComponents(string: "http://45.76.124.20:8080/api/getProducts?limit=20")!
    let searchController = UISearchController(searchResultsController: nil)
    var searchQuery = ""
    var pageDown = false
    var loaded = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let url = "http://45.76.124.20:8080/api/getProducts?dateOfSpecials=04/08/20&limit=20"
        url.queryItems = [URLQueryItem(name: "dateOfSpecials", value: "04/08/20")]
        getData()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Seach for a product"

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.searchBar.delegate = self;
    }
    private func addTapped() {
        print("hi")
    }
    private func getData(){
        var base = "http://45.76.124.20:8080/api/getProducts?dateOfSpecials="
        base += date + "&limit=" + String(count) + "&offset=" + String(offset) + "&search=" + searchQuery
        let url = URL(string: base)!
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
            
            if (self.pageDown) {
                self.items += json.rows
                self.pageDown = false
            }else {
                self.items = json.rows
            }
            print("items.count " + String(self.items.count))
            print("offset " + String(self.offset))
            print("count " + String(self.count))
            self.totalProducts = json.total
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
            self.loaded = true
            })
            task.resume()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailVC {
            destination.item = items[(tableView.indexPathForSelectedRow?.row)!]
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
        }
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:  IndexPath) {
        performSegue(withIdentifier: "showProductDetail", sender: self)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == items.count - 1 && indexPath.row < totalProducts && loaded && offset + count - 1 == indexPath.row {
            loaded = false
            print(indexPath.row)
            pageDown = true
            offset += count
            getData()
            
            
        }
    }
}

@available(iOS 11.0, *)
extension VideoListScreen: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchBar = searchController.searchBar
        offset = 0
        count = 10
        pageDown = false
        loaded = false
        searchQuery = searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        getData()
        if items.count != 0 {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchQuery = ""
        offset = 0
        pageDown = false
        loaded = false
        getData()
        if items.count != 0 {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
}





