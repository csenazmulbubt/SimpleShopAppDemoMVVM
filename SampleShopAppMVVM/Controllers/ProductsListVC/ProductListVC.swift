//
//  ViewController.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 27/04/2023.
//

import UIKit
import Combine
import Kingfisher

class ProductListVC: UIViewController {
    
    @IBOutlet weak var productListView: ProductListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productListView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showHideNavigationBarHidden()
        self.productListView.updateCartLable()
        self.productListView.productListViewModel.setProductCartDelegate()
    }
    
    func gotoCartListVC() -> Void {
        let vc = AppStoryboard.Main.viewController(vc: ProductCartListVC.self)
        vc.productListViewModel = productListView.productListViewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - ProductListViewDelegate
extension ProductListVC: ProductListViewDelegate {
    func tappedOnBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tappedOnCartButton() {
        self.gotoCartListVC()
    }
}
