//
//  DetailVC.swift
//  BeginnerTableView
//
//  Created by Edward on 14/08/20.
//  Copyright © 2020 Sean Allen. All rights reserved.
//

import UIKit
import Charts

class DetailVC: UIViewController, IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return String(describing: nameValues[Int(value)])
    }
    
    @IBOutlet weak var productBrandLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var lineChartView: LineChartView!
    var item: Items?
    var nameValues: [String]!
    var priceValues: [Double]!
    var data = LineChartData()
    
//    lazy var lineChartView: LineChartView = {
//        let chartView = LineChartView()
//        chartView.backgroundColor = .systemBlue
//        return chartView
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productBrandLabel.text = item?.brand.capitalized
        productPriceLabel.text = item?.salePrice
        title = item?.name.capitalized
        adjustLargeTitleSize()
        var image = item!.image
        let urll = URL(string: "https://static.countdown.co.nz/assets/product-images/big/" + image)
        lineChartView.backgroundColor = .systemBlue
        lineChartView.xAxis.valueFormatter = self
        lineChartView.rightAxis.enabled = false
        lineChartView.animate(xAxisDuration: 2.5)
        
        let yAxis = lineChartView.leftAxis
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .white
        
        let xAxis = lineChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = .white
        xAxis.setLabelCount(4, force: false)

        getData()
        let marker:BalloonMarker = BalloonMarker(color: UIColor.black, font: .systemFont(ofSize: 12), textColor: UIColor.white, insets: UIEdgeInsets(top: 7.0, left: 7.0, bottom: 7.0, right: 7.0))
        marker.chartView = lineChartView
        marker.minimumSize = CGSize(width: 75.0, height: 50.0)
        lineChartView.marker = marker
        lineChartView.drawMarkers = true
        productImage.load(url: urll!)
}
    private func createCountdownGraph(dateIndexes : [Double], priceValues : [Double]) {
        var lineChartEntry = [ChartDataEntry]()
        var index = Double(0)
        for price in priceValues{
            lineChartEntry.append(ChartDataEntry(x: dateIndexes[Int(index)], y: price))
            index += 1
        }
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Date")
        line1.drawCirclesEnabled = false
        line1.mode = .horizontalBezier
        line1.setColor(.white)
//        line1.fill = Fill(color : .white)
//        line1.fillAlpha = 0.8
//        line1.drawFilledEnabled = true
//        line1.drawHorizontalHighlightIndicatorEnabled = false
//        line1.highlightColor = .systemRed
//        let data = LineChartData()
        data.addDataSet(line1)
        data.setDrawValues(false)
        lineChartView.data = data
    }
    private func createPaknSaveLine(products : [PakNsaveResult]) {
        if (products.isEmpty) {
            return
        }
        let first = products.first
        let pricees = first!.price
        let dateIndexes = first!.date
        var lineChartEntry = [ChartDataEntry]()
        var index = 0
        for price in pricees{
            lineChartEntry.append(ChartDataEntry(x: dateIndexes[index], y: price))
            index += 1
        }
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Date")
        line1.drawCirclesEnabled = false
        line1.mode = .horizontalBezier
        line1.setColor(.red)
        //        line1.fill = Fill(color : .white)
        //        line1.fillAlpha = 0.8
        //        line1.drawFilledEnabled = true
        //        line1.drawHorizontalHighlightIndicatorEnabled = false
        //        line1.highlightColor = .systemRed
        data.addDataSet(line1)
        data.setDrawValues(false)
        lineChartView.data = data
    }
    private func getData(){
        let base = "http://45.76.124.20:8080/api/pakNsave/getSingleLinkedProductHistory?code=" + item!.code + "&location=Taupo"
        print(base)
        let url = URL(string: base)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
            guard let data = data, error == nil else {
                print("bad")
                return
            }
            var result: History?
            do {
                result = try JSONDecoder().decode(History.self, from: data)
            }
            catch {
                print(error.localizedDescription)
            }
            guard let json = result else {
                return
            }
            
            DispatchQueue.main.async {
                self.nameValues = json.dates
//                self.dateValues = json.result.countdown.date
//                self.priceValues = json.result.countdown.price
                self.createCountdownGraph(dateIndexes: json.result.countdown.date, priceValues: json.result.countdown.price)
                self.createPaknSaveLine(products: json.result.paknsave)
//                self.createCountdownGraph()
//                self.createPaknSaveLine(products: json.paknsave)
            }
            })
            task.resume()
    }
}

extension UIViewController {
func adjustLargeTitleSize() {
  guard let title = title, #available(iOS 11.0, *) else { return }

  let maxWidth = UIScreen.main.bounds.size.width - 60
  var fontSize = UIFont.preferredFont(forTextStyle: .largeTitle).pointSize
    var width = title.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]).width

  while width > maxWidth {
    fontSize -= 1
    width = title.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]).width
  }

  navigationController?.navigationBar.largeTitleTextAttributes =
    [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize)
  ]
}
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
class ChartStringFormatter: NSObject, IAxisValueFormatter {
    var nameValues: [String]! = ["A", "B"]
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return String(describing: nameValues[Int(value)])
    }
}


