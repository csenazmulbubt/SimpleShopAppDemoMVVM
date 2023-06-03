//
//  ProductCollectionViewCell.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 02/06/2023.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cartAddButton: UIButton!
   
    static let cellReuseIdentifier = "ProductCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.async {
            self.layer.cornerRadius = 8
        }
    }
    
    @IBAction func cartAddButtonAction(_ sender: UIButton) {
        
    }
    
    public func setupCell(product: Product) -> Void {
        productTitleLabel.text = product.title
        priceLabel.text = "$\(product.price)"
    }
}
