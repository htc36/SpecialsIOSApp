//
//  Item.swift
//  BeginnerTableView
//
//  Created by Donny on 10/08/20.
//  Copyright © 2020 Sean Allen. All rights reserved.
//

//import Foundation

struct Response: Codable {
    let rows: [Items]
    let total : Int
}
struct Items: Codable {
    let name: String
    let brand: String
//    let volSize: String
    let salePrice: String
    let origPrice: String
    let barcode: String
    let code: String
    let image: String
}

struct History: Codable {
    let countdown: CountdownResult
    let paknsave : [PakNsaveResult]
}
struct CountdownResult : Codable {
    let date : [String]
    let price : [Double]
}
struct PakNsaveResult : Codable {
    let date : [String]
    let price : [Double]
    let productId : String
    let name : String
    let quantityType : String
}
