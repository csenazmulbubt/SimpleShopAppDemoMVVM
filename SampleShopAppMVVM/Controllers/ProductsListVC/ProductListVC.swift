//
//  ViewController.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 27/04/2023.
//

import UIKit
import Combine

class ProductListVC: UIViewController {
    
    @IBOutlet weak var productListView: ProductListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productListView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

//MARK: - ProductListViewDelegate
extension ProductListVC: ProductListViewDelegate {
    func tappedOnBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
