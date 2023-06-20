//
//  ProductDetailsVC.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 09/06/2023.
//

import UIKit

class ProductDetailsVC: UIViewController {
    
    @IBOutlet weak var productDetailsView: ProductDetailsView!
    
    var product: Product? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.productDetailsView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showHideNavigationBarHidden()
        productDetailsView.product = self.product
    }
}

//MARK: - ProductDetailsViewDelegate
extension ProductDetailsVC: ProductDetailsViewDelegate {
    func tappedOnBackButton() {
        self.popViewController()
    }
}
