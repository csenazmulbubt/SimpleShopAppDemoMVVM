//
//  ProductDetailsSlideCollectionViewCell.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 08/06/2023.
//

import UIKit

class ProductDetailsSlideCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    
    
    static let cellReuseIdentifier = "ProductDetailsSlideCollectionViewCell"
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
