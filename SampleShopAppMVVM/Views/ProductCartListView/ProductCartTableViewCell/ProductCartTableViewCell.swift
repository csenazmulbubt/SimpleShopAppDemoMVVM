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
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
