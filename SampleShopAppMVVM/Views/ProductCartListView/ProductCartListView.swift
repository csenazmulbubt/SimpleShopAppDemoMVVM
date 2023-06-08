//
//  ProductCartListView.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 04/06/2023.
//

import Foundation
import UIKit

protocol ProductCartListViewDelegate: AnyObject {
    func tappedOnBackButton()
}

class ProductCartListView: UIView {
    
    @IBOutlet weak var productCartListTableView: UITableView!
    
    weak var delegate: ProductCartListViewDelegate? = nil
    static let nibName = "ProductCartListView"
    public var productList: [Product] = []
    private var totalItemSecondSection = 0
    
    public var productListViewModel: ProductListViewModel? = nil {
        didSet {
            self.productList = productListViewModel?.getProductListBasedOnCartItems() ?? []
            self.totalItemSecondSection = self.productList.isEmpty ? 0 : 1
            self.productListViewModel?.productCartListViewModel?.delegate = self
            self.productCartListTableView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    private func configureView() -> Void {
        guard let view = self.loadViewFromNib(nibName: ProductCartListView.nibName) else{return}
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        self.initialSetup()
    }
    
    private func initialSetup() -> Void {
        self.productCartListTableView.register(UINib(nibName: ProductCartTableViewCell.cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: ProductCartTableViewCell.cellReuseIdentifier)
        self.productCartListTableView.register(UINib(nibName: ProductCartResultTableViewCell.cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: ProductCartResultTableViewCell.cellReuseIdentifier)
        self.productCartListTableView.separatorStyle = .none
        
        self.productCartListTableView.delegate = self
        self.productCartListTableView.dataSource = self
    }
    
    //MARK: - tapped On Back Button
    @IBAction func tappedOnBackButton(_ sender: UIButton) {
        delegate?.tappedOnBackButton()
    }
}

//MARK: - UITableViewDataSource
extension ProductCartListView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
       
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return self.productList.count
        }
       
        return totalItemSecondSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductCartTableViewCell.cellReuseIdentifier, for: indexPath) as? ProductCartTableViewCell else { return UITableViewCell() }
           
            let productCartResponse = productListViewModel?.productCartListViewModel?.productCartList?.filter { $0.id ==  productList[safe: indexPath.row]?.id ?? 0}
           
            cell.delegate = self
            cell.setupCell(product: productList[safe: indexPath.row],
                           productCartResponse: productCartResponse?.first)
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductCartResultTableViewCell.cellReuseIdentifier, for: indexPath) as? ProductCartResultTableViewCell else { return UITableViewCell() }
            
            cell.setupCell(productCartResponse: productListViewModel?.productCartListViewModel?.productCarts)
            return cell
        }
    }
}

//MARK: - UITableViewDelegate
extension ProductCartListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
       return 150
    }
}

//MARK: - ProductCartTableViewCellDelegate
extension ProductCartListView: ProductCartTableViewCellDelegate {
    func tappedOnIncrementButton(productId: Int) {
        productList.forEach { pro in
            print("ProductIncrement",pro.id,productId)
        }
        self.productListViewModel?.productCartListViewModel?.addToCart(ProductCart(id: productId, quantity: 1))
    }
    
    func tappedOnDecrementButton(productId: Int) {
        productList.forEach { pro in
            print("ProductDecremen \(pro.id)",productId)
        }
        self.productListViewModel?.productCartListViewModel?.removeFromCart(ProductCart(id: productId, quantity: 1))
    }
}

//MARK: - ProductCartListViewModelDelegate
extension ProductCartListView: ProductCartListViewModelDelegate {
    func didReceiveCartOperationStatus(_ responseStatus: ResoponseStatus) {
        
        DispatchQueue.main.async {
            switch responseStatus {
            case .loading:
                break
            case .success:
                self.productCartListTableView.reloadData()
            case .failure(let error):
                print("Failure",error)
            }
        }
    }
}
