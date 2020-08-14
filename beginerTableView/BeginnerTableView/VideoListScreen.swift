//
//  VideoListScreen.swift
//  BeginnerTableView
//
//  Created by Sean Allen on 5/19/17.
//  Copyright © 2017 Sean Allen. All rights reserved.
//

import UIKit

class VideoListScreen: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var videos: [Video] = []
    var items: [Items] = []
    var count = 20
    var date = "04/08/20"
    var url = URLComponents(string: "http://45.76.124.20:8080/api/getProducts?limit=20")!

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let url = "http://45.76.124.20:8080/api/getProducts?dateOfSpecials=04/08/20&limit=20"
        url.queryItems = [URLQueryItem(name: "dateOfSpecials", value: "04/08/20")]
        getData(from: url)
        videos = createArray()
    }
    private func getData(from url: URLComponents){
        let url = URL(string: "http://45.76.124.20:8080/api/getProducts?dateOfSpecials=" + date + "&limit=" + String(count))!
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
                print(self.items)
                self.tableView.reloadData()
            }
            })

            task.resume()
            self.tableView.reloadData()
        print(self.items)


    }
    

    
    func createArray() -> [Video] {
        
        let video1 = Video(image: #imageLiteral(resourceName: "beginner-first-app"), title: "Your First App")
        let video2 = Video(image: #imageLiteral(resourceName: "dev-setup"), title: "My Dev Setup")
        let video3 = Video(image: #imageLiteral(resourceName: "int-overview"), title: "iOS Interview")
        let video4 = Video(image: #imageLiteral(resourceName: "ss-delegates"), title: "Buttons in TableViews")
        let video5 = Video(image: #imageLiteral(resourceName: "ss-uipickerview-card"), title: "UIPickerView Tutorial")
        let video6 = Video(image: #imageLiteral(resourceName: "vlog-4"), title: "Day in the Life")
    
        return [video1, video2, video3, video4, video5, video6]
    }
}


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





