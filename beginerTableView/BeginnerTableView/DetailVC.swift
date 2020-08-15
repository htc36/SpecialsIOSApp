//
//  DetailVC.swift
//  BeginnerTableView
//
//  Created by Edward on 14/08/20.
//  Copyright © 2020 Sean Allen. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var productBrandLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    var item: Items?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        productNameLabel.text = item?.name
        productBrandLabel.text = item?.brand
        productPriceLabel.text = item?.salePrice

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
