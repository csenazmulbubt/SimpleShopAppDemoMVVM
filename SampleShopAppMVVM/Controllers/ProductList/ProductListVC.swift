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
    
    private let productListViewModel = ProductListViewModel(NetworkService(),
                                                cartService: ProductCartOperation())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productListView.delegate = self
        self.productListViewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showHideNavigationBarHidden()
        self.productListView.updateCartLable(totalItem: productListViewModel.getTotalCartItem())
        self.productListViewModel.setProductCartDelegate()
    }
    
    private func updateProductListView() -> Void {
        let productArray = self.productListViewModel.productArray
        let hasMorePage = self.productListViewModel.hasMorePage
        let isNeedLoadMorePage = self.productListViewModel.isNeedLoadMorePage
        self.productListView.updateData(product: productArray,
                                        hasMorePage: hasMorePage,
                                        isNeedLoadMorePage: isNeedLoadMorePage)
    }
    
}

//MARK: - ProductListViewModelDelegate
extension ProductListVC: ProductListViewModelDelegate {
    func onProductListUpdateStatus(_ response: ResoponseStatus) {
        
        DispatchQueue.main.async {
            switch response {
            case .loading:
                break
            case .success:
                self.updateProductListView()
            case .failure(let message):
                print("Error Message",message)
            }
        }
    }
    
    func onCartItemsUpdateStatus(responseStatus: ResoponseStatus) {
        DispatchQueue.main.async {
            switch responseStatus {
            case .loading:
                break
            case .success:
                self.productListView.updateCartLable(totalItem: self.productListViewModel.getTotalCartItem())
            case .failure(let message):
                print("Error Message",message)
            }
        }
    }
}

//MARK: - ProductListViewDelegate
extension ProductListVC: ProductListViewDelegate {
    func showProductDetails(productIndex: Int) {
        self.gotoProductDetailsVC(self.productListViewModel.productArray[productIndex])
    }
    
    func tappedOnAddCartButton(productIndex: Int) {
        let productId = self.productListViewModel.productArray[productIndex].id
        self.productListViewModel.addToCart(productId)
    }
    
    func fetchProductRequest(URLRequestBuilder: URLRequestBuilder) {
        self.productListViewModel.startProductRequest(URLReuquestBuilder: URLRequestBuilder)
    }
    
    func showProductDetails(product: Product) {
        self.gotoProductDetailsVC(product)
    }
    
    func tappedOnBackButton() {
        self.popViewController()
    }
    
    func tappedOnCartButton() {
        self.gotoCartListVC()
    }
}

//MARK: - Goto To Different VC
extension ProductListVC {
    func gotoCartListVC() -> Void {
        let vc = AppStoryboard.Main.viewController(vc: ProductCartListVC.self)
        vc.productListViewModel = self.productListViewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoProductDetailsVC(_ product: Product) -> Void {
        let vc = AppStoryboard.Main.viewController(vc: ProductDetailsVC.self)
        vc.product = product
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
