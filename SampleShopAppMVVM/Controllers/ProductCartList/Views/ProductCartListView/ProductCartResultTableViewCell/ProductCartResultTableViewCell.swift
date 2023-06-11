//
//  ProductCartResultTableViewCell.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 08/06/2023.
//

import UIKit

class ProductCartResultTableViewCell: UITableViewCell {

    @IBOutlet weak var totalQuantityLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var discountedTotal: UILabel!
    
    static let cellReuseIdentifier = "ProductCartResultTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    
    func setupCell(productCartResponse: ProductCartsResponse?) -> Void {
        self.totalQuantityLabel.text = "\(productCartResponse?.totalQuantity ?? 0)"
        self.totalPriceLabel.text = "$\(productCartResponse?.total ?? 0)"
        self.discountedTotal.text = "$\(productCartResponse?.discountedTotal ?? 0)"
    }
    
}
