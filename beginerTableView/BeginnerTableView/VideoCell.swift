//
//  VideoCell.swift
//  BeginnerTableView
//
//  Created by Sean Allen on 5/19/17.
//  Copyright © 2017 Sean Allen. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {

    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var videoTitleLabel: UILabel!
    
    @IBOutlet weak var priceLabell: UILabel!
    func setVideo(video: Video) {
        videoTitleLabel.text = video.title
    }
    func setItem(item : Items){
        brandLabel.text = item.brand.capitalized
        videoTitleLabel.text=item.name.capitalized
        priceLabell.text=item.salePrice
    }
    
}
