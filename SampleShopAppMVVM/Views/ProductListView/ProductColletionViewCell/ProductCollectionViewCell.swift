//
//  ProductCollectionViewCell.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 02/06/2023.
//

import UIKit

protocol ProductCollectionViewCellDelegate: AnyObject {
    func tappedOnAddCartButton(tag: Int)
}

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cartAddButton: UIButton!
   
    weak var delegate: ProductCollectionViewCellDelegate? = nil
    static let cellReuseIdentifier = "ProductCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.async {
            self.layer.cornerRadius = 8
            self.productTitleLabel.layer.cornerRadius = 8
            self.cartAddButton.layer.cornerRadius = 8
        }
    }
    
    @IBAction func cartAddButtonAction(_ sender: UIButton) {
        delegate?.tappedOnAddCartButton(tag: sender.tag)
    }
    
    public func setupCell(product: Product?) -> Void {
        if product != nil {
            productTitleLabel.text = product!.title
            priceLabel.text = "$\(product!.price)"
            
            if let firstImageURL = product!.images.first {
                self.productImageView.setImage(with: firstImageURL)
            }
        }
    }
}
