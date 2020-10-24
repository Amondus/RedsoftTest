//
//  ProductTableViewCell.swift
//  RedsoftTest
//
//  Created by Антон Захарченко on 22.10.2020.
//

import UIKit
import Kingfisher

class ProductTableViewCell: UITableViewCell {
  
  @IBOutlet weak var mainView: UIView!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var productLabel: UILabel!
  @IBOutlet weak var supplierLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var basketValueLabel: UILabel!
  @IBOutlet weak var productImageView: UIImageView!
  @IBOutlet weak var buttonsBackgroundView: UIView!
  
  @IBOutlet weak var basketStackView: UIStackView!
  @IBOutlet weak var buttonsStackView: UIStackView!
  
  var onOrderButtonTapped: (() -> Void)?
  var onMinusButtonTapped: (() -> Void)?
  var onPlusButtonTapped: (() -> Void)?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    mainView.layer.borderWidth = 1
    mainView.layer.borderColor = UIColor.lightGray.cgColor
    mainView.layer.cornerRadius = 7
    buttonsBackgroundView.layer.cornerRadius = 7
  }
  
  func configure(with product: ProductsResponse.DataResponse?) {
    let inBasketValue = product?.inBasket ?? 0
    let stringAmount = String(format: "%.2f", product?.amount ?? 0)
    let imageUrl = URL(string: product?.image_url ?? "")
    
    categoryLabel.text = product?.categories.first?.title
    productLabel.text = product?.title
    supplierLabel.text = product?.producer
    basketValueLabel.text = String(inBasketValue) + " шт."
    amountLabel.text = stringAmount + " ₽"
    
    productImageView.kf.setImage(with: imageUrl)
    
    basketStackView.isHidden = inBasketValue > 0
    buttonsStackView.isHidden = inBasketValue < 1
    
    let gesture = UITapGestureRecognizer(target: self, action: #selector(basketViewTapped))
    basketStackView.addGestureRecognizer(gesture)
  }
  
  @objc private func basketViewTapped() {
    onOrderButtonTapped?()
  }
  
  // MARK: - @IBAction Methods
  
  @IBAction func didTapMinusButton(_ sender: UIButton) {
    onMinusButtonTapped?()
  }
  
  @IBAction func didTapPlusButton(_ sender: UIButton) {
    onPlusButtonTapped?()
  }
  
}
