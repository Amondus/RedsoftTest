//
//  MainMenuViewModel.swift
//  RedsoftTest
//
//  Created by Антон Захарченко on 22.10.2020.
//

import Foundation
import RxSwift
import RxCocoa

final class MainMenuViewModel {
  let disposeBag = DisposeBag()
  
  var products: Driver<ProductsResponse>? = nil
  
  func loadProducts() {
    
  }
}
