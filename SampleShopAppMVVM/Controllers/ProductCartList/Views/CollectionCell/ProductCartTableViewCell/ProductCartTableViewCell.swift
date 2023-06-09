//
//  ProductCartTableViewCell.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 05/06/2023.
//

import UIKit

protocol ProductCartTableViewCellDelegate: AnyObject {
    
    func tappedOnIncrementButton(productId: Int)
    func tappedOnDecrementButton(productId: Int)
}

class ProductCartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImageCV: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var previousPriceLabel: UILabel!
    @IBOutlet weak var decreamentButton: UIButton!
    @IBOutlet weak var totalProductLabel: UILabel!
    @IBOutlet weak var incrementButton: UIButton!
    @IBOutlet weak var productTitleLable: UILabel!
    
    weak var delegate: ProductCartTableViewCellDelegate? = nil
    static let cellReuseIdentifier = "ProductCartTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.async {
            self.productImageCV.layer.cornerRadius = 8
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layer.cornerRadius = 8
        self.contentView.frame = self.contentView.frame.inset(by:  UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    @IBAction func tappedOnDecreamentButton(_ sender: UIButton) {
        delegate?.tappedOnDecrementButton(productId: sender.tag)
    }
    
    
    @IBAction func tappedOnIncrementButton(_ sender: UIButton) {
        delegate?.tappedOnIncrementButton(productId: sender.tag)
    }
    
    func setupCell(product: Product?,
                   productCartResponse: ProductCartResponse?) -> Void {
        
        if let url = product?.images.first {
            productImageView.setImage(with: url)
        }
        
        if let productCartResponse = productCartResponse {
            print("Product Cart response",productCartResponse.id,
                  productCartResponse.quantity)
        }
        self.productTitleLable.text = "\(product?.title ?? "")"
        self.totalProductLabel.text = "\(productCartResponse?.quantity ?? 0)"
        self.currentPriceLabel.text = "\(productCartResponse?.discountedPrice ?? 0)"
        self.previousPriceLabel.text = "\(productCartResponse?.total ?? 0)"
        self.incrementButton.tag = product?.id ?? 0
        self.decreamentButton.tag = product?.id ?? 0
    }
    
}
