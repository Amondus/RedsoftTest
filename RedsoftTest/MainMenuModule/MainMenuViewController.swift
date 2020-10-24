//
//  MainMenuViewController.swift
//  RedsoftTest
//
//  Created by Антон Захарченко on 22.10.2020.
//

import UIKit
import RxSwift
import RxCocoa

final class MainMenuViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: - Properties
  
  var products: ProductsResponse? {
    didSet {
      reloadTableView()
    }
  }
  
  let disposeBag = DisposeBag()
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.prefersLargeTitles = true
    registerCell()
    tableView.dataSource = self
    tableView.delegate = self
    
    configureSearchBar()
    
    loadProducts()
  }
  
  // MARK: - Private Methods
  
  private func configureSearchBar() {
    let search = UISearchController(searchResultsController: nil)
    search.searchResultsUpdater = self
    search.obscuresBackgroundDuringPresentation = false
    search.searchBar.placeholder = "Я ищу"
    navigationItem.searchController = search
  }
  
  private func loadProducts() {
    let stringUrl = "https://rstestapi.redsoftdigital.com/" + PathComponents.products.rawValue
    guard let url = URL(string: stringUrl) else { return }
    let resource = Resource<ProductsResponse>(url: url, httpMethod: HttpMethod.get)
    
    URLRequest.load(resource: resource)
      .subscribe (onNext: { result in
        self.products = result
      }).disposed(by: disposeBag)
    
  }
  
  private func reloadTableView() {
    DispatchQueue.main.async { [weak self] in
      self?.tableView.reloadData()
    }
  }
  
  // MARK: - Configure Cells
  
  private func registerCell() {
    tableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil),
                       forCellReuseIdentifier: "ProductTableViewCell")
  }
  
  private func createProductCell(indexPath: IndexPath) -> ProductTableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as? ProductTableViewCell else
    {
      return ProductTableViewCell()
      
    }
    
    cell.configure(with: products?.data[indexPath.row])
    
    cell.onOrderButtonTapped = { [weak self] in
      self?.products?.data[indexPath.row].inBasket = 1
    }
    
    cell.onMinusButtonTapped = { [weak self] in
      let inBasket = self?.products?.data[indexPath.row].inBasket ?? 1
      
      if inBasket > 0 {
        self?.products?.data[indexPath.row].inBasket = inBasket - 1
      }
    }
    
    cell.onPlusButtonTapped = { [weak self] in
      let inBasket = self?.products?.data[indexPath.row].inBasket ?? 0
      self?.products?.data[indexPath.row].inBasket = inBasket + 1
    }
    
    return cell
  }
}

extension MainMenuViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchText = searchController.searchBar.searchTextField.text,
          searchText != "" else { return }
    
    let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
          
    let stringUrl = "https://rstestapi.redsoftdigital.com/" + PathComponents.products.rawValue + "?filter%5Btitle%5D=" + encodedText
    guard let url = URL(string: stringUrl) else { return }
    let resource = Resource<ProductsResponse>(url: url, httpMethod: HttpMethod.get)
    
    URLRequest.load(resource: resource)
      .delay(.milliseconds(300), scheduler: MainScheduler.instance)
      .subscribe (onNext: { result in
        self.products = result
      }).disposed(by: disposeBag)
  }
}

// MARK: - ProductInfoDelegate Methods

extension MainMenuViewController: ProductInfoDelegate {
  func updateProducts(with product: ProductsResponse.DataResponse?) {
    var newProducts = ProductsResponse(data: [])
    
    self.products?.data.forEach { element in
      if element.id == product?.id {
        if let product = product {
          newProducts.data.append(product)
          return
        }
      }
      
      newProducts.data.append(element)
    }
    
    products = newProducts
  }
}

// MARK: - UITableViewDataSource Methods

extension MainMenuViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return products?.data.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return createProductCell(indexPath: indexPath)
  }
}

// MARK: - UITableViewDataSource Methods

extension MainMenuViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    if let viewController = UIStoryboard(name: "ProductInfo", bundle: nil).instantiateViewController(withIdentifier: "ProductInfoViewController") as? ProductInfoViewController {
      viewController.product = products?.data[indexPath.row]
      viewController.delegate = self
      if let navigator = navigationController {
        navigator.pushViewController(viewController, animated: true)
      }
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 160
  }
}
