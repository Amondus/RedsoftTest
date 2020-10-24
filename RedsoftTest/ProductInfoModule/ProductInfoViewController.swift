//
//  ProductInfoViewController.swift
//  RedsoftTest
//
//  Created by Антон Захарченко on 22.10.2020.
//

import UIKit
import Kingfisher

protocol ProductInfoDelegate: class {
  func updateProducts(with product: ProductsResponse.DataResponse?)
}

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
  
  weak var delegate: ProductInfoDelegate?
  
  var product: ProductsResponse.DataResponse? {
    didSet {
      delegate?.updateProducts(with: product)
    }
  }
  
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationItem.largeTitleDisplayMode = .never
    navigationItem.title = product?.title
  }
  
  // MARK: - Private Methods
  
  private func configureView() {
    let inBasketValue = product?.inBasket ?? 0
    let stringAmount = String(format: "%.2f", product?.amount ?? 0)
    let imageUrl = URL(string: product?.image_url ?? "")
    
    productLabel.text = product?.title
    producerLabel.text = product?.producer
    descriptionLabel.text = product?.short_description
    basketValueLabel.text = String(product?.inBasket ?? 0) + " шт."
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
    
    product?.inBasket = 1
    
    configureView()
  }
  
  private func configureCategoriesInfo() {
    guard product?.categories.count ?? 0 > 0,
          let firstCatTitle = product?.categories[0].title else {
      firstCategory.text = ""
      return }
    firstCategory.text = firstCatTitle
    
    guard product?.categories.count ?? 0 > 1,
          let secondCatTitle = product?.categories[1].title else {
      secondCategory.text = ""
      return }
    secondCategory.text = secondCatTitle
    
    guard product?.categories.count ?? 0 > 2,
          let thirdCatTitle = product?.categories[2].title else {
      thirdCategory.text = ""
      return }
    thirdCategory.text = thirdCatTitle
  }
  
  // MARK: - @IBAction Methods
  
  @IBAction func didTapMinusButton(_ sender: UIButton) {
    let inBasket = product?.inBasket ?? 1
    
    if inBasket > 0 {
      product?.inBasket = inBasket - 1
    }
    
    configureView()
  }
  
  @IBAction func didTapPlusButton(_ sender: UIButton) {
    let inBasket = product?.inBasket ?? 0
    product?.inBasket = inBasket + 1
    
    configureView()
  }
}

