//
//  ProductCartTableViewCell.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 05/06/2023.
//

import UIKit

class ProductCartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImageCV: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var previousPriceLabel: UILabel!
    @IBOutlet weak var decreamentButton: UIButton!
    @IBOutlet weak var totalProductLabel: UILabel!
    @IBOutlet weak var incrementButton: UIButton!
    
    static let cellReuseIdentifier = "ProductCartTableViewCell"

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
    
    
    @IBAction func tappedOnDecreamentButton(_ sender: UIButton) {
        
    }
    
    
    @IBAction func tappedOnIncrementButton(_ sender: UIButton) {
        
    }
    
}
