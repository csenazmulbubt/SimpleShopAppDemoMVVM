//
//  ProductCartListVC.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 07/06/2023.
//

import UIKit

class ProductCartListVC: UIViewController {
    
    @IBOutlet weak var productCartListView: ProductCartListView!
    
    public var productListViewModel: ProductListViewModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productCartListView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showHideNavigationBarHidden()
        self.productCartListView.productListViewModel = self.productListViewModel
    }
    
}

//MARK: - ProductCartListViewDelegate
extension ProductCartListVC: ProductCartListViewDelegate {
    func tappedOnBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
