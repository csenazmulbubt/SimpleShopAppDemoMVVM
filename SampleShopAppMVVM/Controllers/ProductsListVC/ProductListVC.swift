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
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    deinit {
        print("Deinit Call")
    }
}

//MARK: - ProductListViewDelegate
extension ProductListVC: ProductListViewDelegate {
    func tappedOnBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
