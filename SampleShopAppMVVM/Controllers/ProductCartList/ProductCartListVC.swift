//
//  ProductCartListVC.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 07/06/2023.
//

import UIKit

class ProductCartListVC: UIViewController {
    
    @IBOutlet weak var productCartListView: ProductCartListView!
    
    public var productCartListViewModel: ProductCartListViewModel? = nil
    public var productList: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productCartListView.delegate = self
        self.productCartListViewModel?.delegate = self
        // Do any additional setup after loading the view.
        self.productCartListView.productList = self.productList
        self.updateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showHideNavigationBarHidden()
    }
    
    private func updateData() -> Void {
        if let productCarts = productCartListViewModel?.productCarts {
            self.productCartListView.updateData(productCartsResponse: productCarts)
        }
    }
}

//MARK: - ProductCartListViewDelegate
extension ProductCartListVC: ProductCartListViewDelegate {
    func tappedOnIncrementButton(productId: Int) {
        self.productCartListViewModel?.addToCart(ProductCart(id: productId, quantity: 1))
    }
    
    func tappedOnDecrementButton(productId: Int) {
        self.productCartListViewModel?.removeFromCart(ProductCart(id: productId, quantity: 1))
    }
    
    func tappedOnBackButton() {
        self.popViewController()
    }
}

//MARK: - ProductListViewModelDelegate
extension ProductCartListVC: ProductCartListViewModelDelegate {
    func didReceiveCartOperationStatus(_ responseStatus: ResoponseStatus) {
        
        DispatchQueue.main.async {
            switch responseStatus {
            case .loading:
                break
            case .success:
                self.updateData()
                break
            case .failure(let error):
                print("Errror",error)
                break
            }
        }
    }
   
}
