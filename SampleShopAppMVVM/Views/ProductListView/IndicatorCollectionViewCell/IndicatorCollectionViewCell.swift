//
//  IndicatorCollectionViewCell.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 03/06/2023.
//

import UIKit

class IndicatorCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var noMoreProductLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    static let cellReuseIdentifier = "IndicatorCollectionViewCell"
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.async {
            self.layer.cornerRadius = 8
        }
    }
    
    public var isShowIndicator: Bool = false{
        didSet {
            self.setUpCell()
        }
    }

    private func setUpCell() -> Void {
        if isShowIndicator {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            noMoreProductLabel.isHidden = true
        }
        else {
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
            noMoreProductLabel.isHidden = false
        }
    }
}
