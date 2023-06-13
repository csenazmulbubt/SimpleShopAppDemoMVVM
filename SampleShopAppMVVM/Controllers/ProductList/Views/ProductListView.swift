//
//  ProductsView.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 01/06/2023.
//

import UIKit

protocol ProductListViewDelegate: AnyObject {
    func tappedOnBackButton()
    func tappedOnCartButton()
    func showProductDetails(productIndex: Int)
    func tappedOnAddCartButton(productIndex: Int)
    func fetchProductRequest(URLRequestBuilder: URLRequestBuilder)
}

class ProductListView: UIView {
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var totalCartItemShowLabel: UILabel!
    
    weak var delegate: ProductListViewDelegate? = nil
    static let nibName = "ProductListView"
    private let section = 2
    
    private let debounce = Debounce(timeInterval: 0.5, queue: .global(qos: .userInitiated))
    private var productArray: [Product] = []
    private var hasMorePage: Bool = true
    private var isNeedLoadMorePage: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    private func configureView() -> Void {
        guard let view = self.loadViewFromNib(nibName: ProductListView.nibName) else{return}
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        self.initialSetup()
    }
    
    private func initialSetup() -> Void {
        self.productCollectionView.register(UINib(nibName: ProductCollectionViewCell.cellReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: ProductCollectionViewCell.cellReuseIdentifier)
        
        self.productCollectionView.register(UINib(nibName: IndicatorCollectionViewCell.cellReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: IndicatorCollectionViewCell.cellReuseIdentifier)
        self.productCollectionView.delegate = self
        self.productCollectionView.dataSource = self
        self.startProductFetchRequest()
    }
    
    private func startProductFetchRequest() -> Void {
        var paraDict: [String: String] = ["limit": "10" ]
        paraDict ["skip"] = "\(self.productArray.count)"
        let URLRequestBuilder = URLRequestBuilder.makeURLRequestBuilder(paraDict,
                                                                        httpMethod: .get,
                                                                        host: .dummyHost,
                                                                        scheme: .https,
                                                                        endPath: ProductPathRequestType.getProducts.path,
                                                                        headers: nil)
        self.debounce.dispatch { [weak self] in
            guard let self = self else { return }
            self.delegate?.fetchProductRequest(URLRequestBuilder: URLRequestBuilder)
        }
    }
    
    @IBAction func tappedOnCartButton(_ sender: UIButton) {
        self.delegate?.tappedOnCartButton()
    }
    
    @IBAction func tappedOnBackButton(_ sender: UIButton) {
        self.delegate?.tappedOnBackButton()
    }
    
    func updateCartLable(totalItem: Int) -> Void {
        self.totalCartItemShowLabel.text = "\(totalItem)"
    }
    
    public func updateData(product: [Product],
                           hasMorePage: Bool,
                           isNeedLoadMorePage: Bool) -> Void {
        self.productArray = product
        self.hasMorePage = hasMorePage
        self.isNeedLoadMorePage = isNeedLoadMorePage
        self.productCollectionView.reloadData()
    }
    
    deinit {
        print("Deinit Call Product List View")
    }
}

//MARK: - UICollectionViewDataSource
extension ProductListView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return section
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return productArray.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.cellReuseIdentifier,
                                                                for: indexPath) as? ProductCollectionViewCell
            else { return  UICollectionViewCell() }
            cell.cartAddButton.tag = indexPath.item
            cell.delegate = self
            cell.setupCell(product: self.productArray[indexPath.item])
            return cell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:             IndicatorCollectionViewCell.cellReuseIdentifier,
                                                                for: indexPath) as? IndicatorCollectionViewCell
            else { return  UICollectionViewCell() }
            cell.isShowIndicator = self.hasMorePage
            return cell
        }
    }
}

//MARK: - UICollectionViewDelegate
extension ProductListView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        if indexPath.section == 1 && self.isNeedLoadMorePage{
            self.startProductFetchRequest()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        self.delegate?.showProductDetails(productIndex: indexPath.item)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ProductListView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = productCollectionView.bounds.size
        
        if indexPath.section == 0 {
            let width = (size.width / 2) - 20
            let height = (size.height / 3) - 20
            return CGSize(width: width, height: height)
        }
        
        return CGSize(width: size.width - 20, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 10, bottom: 5, right: 10)
    }
}

//MARK: - ProductCollectionViewCellDelegate
extension ProductListView: ProductCollectionViewCellDelegate {
    func tappedOnAddCartButton(tag: Int) {
        self.delegate?.tappedOnAddCartButton(productIndex: tag)
    }
}

