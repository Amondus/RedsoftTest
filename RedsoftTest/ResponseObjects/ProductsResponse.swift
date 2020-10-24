//
//  ProductsResponse.swift
//  RedsoftTest
//
//  Created by Антон Захарченко on 22.10.2020.
//

import Foundation

struct ProductsResponse: Codable {
  var data: [DataResponse]
  
  struct DataResponse: Codable {
    let id: Int?
    let title: String?
    let short_description: String?
    let image_url: String?
    let amount: Double?
    let price: Double?
    let producer: String?
    let categories: [Categories]
    
    ///Field not from API (use for calculate products in basket)
    var inBasket: Int?
    
    struct Categories: Codable {
      let id: Int?
      let title: String?
      let parent_id: Int?
    }
  }
}
