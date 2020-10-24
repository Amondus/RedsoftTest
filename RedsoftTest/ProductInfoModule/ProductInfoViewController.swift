//
//  ProductInfoViewController.swift
//  RedsoftTest
//
//  Created by Антон Захарченко on 22.10.2020.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

final class ProductInfoViewController: UIViewController {
  
  @IBOutlet weak var productLabel: UILabel!
  @IBOutlet weak var producerLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var firstCategory: UILabel!
  @IBOutlet weak var secondCategory: UILabel!
  @IBOutlet weak var thirdCategory: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var basketValueLabel: UILabel!
  @IBOutlet weak var productImageView: UIImageView!
  @IBOutlet weak var buttonsBackgroundView: UIView!
  @IBOutlet weak var basketStackView: UIStackView!
  @IBOutlet weak var buttonsStackView: UIStackView!
  
  // MARK: - Properties
  
  let productSubject = BehaviorRelay<[ProductsResponse.DataResponse]>(value: [])
  
  var product: Observable<[ProductsResponse.DataResponse]> {
      return productSubject.asObservable()
  }
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationItem.largeTitleDisplayMode = .never
    navigationItem.title = productSubject.value.first?.title
  }
  
  // MARK: - Private Methods
  
  private func configureView() {
    let inBasketValue = productSubject.value.first?.inBasket ?? 0
    let stringAmount = String(format: "%.2f", productSubject.value.first?.amount ?? 0)
    let imageUrl = URL(string: productSubject.value.first?.image_url ?? "")
    
    productLabel.text = productSubject.value.first?.title
    producerLabel.text = productSubject.value.first?.producer
    descriptionLabel.text = productSubject.value.first?.short_description
    basketValueLabel.text = String(productSubject.value.first?.inBasket ?? 0) + " шт."
    amountLabel.text = stringAmount + " ₽"
    
    productImageView.kf.setImage(with: imageUrl)
    
    basketStackView.isHidden = inBasketValue > 0
    buttonsStackView.isHidden = inBasketValue < 1
    
    buttonsBackgroundView.layer.cornerRadius = 7
    
    let gesture = UITapGestureRecognizer(target: self, action: #selector(basketViewTapped))
    basketStackView.addGestureRecognizer(gesture)
    
    configureCategoriesInfo()
  }
  
  @objc private func basketViewTapped() {
    basketStackView.isHidden = true
    buttonsStackView.isHidden = false
    
    var newProduct = productSubject.value
    newProduct[0].inBasket = 1
    productSubject.accept(newProduct)
    
    configureView()
  }
  
  private func configureCategoriesInfo() {
    guard productSubject.value.first?.categories.count ?? 0 > 0,
          let firstCatTitle = productSubject.value.first?.categories[0].title else {
      firstCategory.text = ""
      return }
    firstCategory.text = firstCatTitle
    
    guard productSubject.value.first?.categories.count ?? 0 > 1,
          let secondCatTitle = productSubject.value.first?.categories[1].title else {
      secondCategory.text = ""
      return }
    secondCategory.text = secondCatTitle
    
    guard productSubject.value.first?.categories.count ?? 0 > 2,
          let thirdCatTitle = productSubject.value.first?.categories[2].title else {
      thirdCategory.text = ""
      return }
    thirdCategory.text = thirdCatTitle
  }
  
  // MARK: - @IBAction Methods
  
  @IBAction func didTapMinusButton(_ sender: UIButton) {
    let inBasket = productSubject.value.first?.inBasket ?? 1
    
    if inBasket > 0 {
      var newProduct = productSubject.value
      newProduct[0].inBasket = (newProduct[0].inBasket ?? 1) - 1
      productSubject.accept(newProduct)
    }
    
    configureView()
  }
  
  @IBAction func didTapPlusButton(_ sender: UIButton) {
    let inBasket = productSubject.value.first?.inBasket ?? 0
    
    var newProduct = productSubject.value
    newProduct[0].inBasket = inBasket + 1
    productSubject.accept(newProduct)
    
    configureView()
  }
}

