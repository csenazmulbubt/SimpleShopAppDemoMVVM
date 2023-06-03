//
//  ProductsView.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 01/06/2023.
//

import UIKit

class ProductListView: UIView {

    @IBOutlet weak var productCollectionView: UICollectionView!
    
    static let nibName = "ProductListView"
    private let section = 2
    
    let productViewModel = ProductViewModel(NetworkService())
    
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
        self.productViewModel.delegate = self
        self.startProductFetchRequest()
    }
    
    private func startProductFetchRequest() -> Void {
        let URLRequestBuilder = productViewModel.makeURLRequestBuilder(["limit": "10"],
                                                                        httpMethod: .get,
                                                                        host: .dummyHost,
                                                                        scheme: .https,
                                                                        endPath: ProductPathRequestType.getProducts.path,
                                                                        headers: nil)
        self.productViewModel.startProductRequest(URLReuquestBuilder: URLRequestBuilder)
    }
}

//MARK: - UICollectionViewDataSource
extension ProductListView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return section
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return productViewModel.productArray.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.cellReuseIdentifier, for: indexPath) as? ProductCollectionViewCell
            else { return  UICollectionViewCell() }
            cell.setupCell(product: productViewModel.productArray[indexPath.item])
            return cell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IndicatorCollectionViewCell.cellReuseIdentifier, for: indexPath) as? IndicatorCollectionViewCell
            else { return  UICollectionViewCell() }
            cell.isShowIndicator = self.productViewModel.hasMorePage
            return cell
        }
    }
}

//MARK: - UICollectionViewDelegate
extension ProductListView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.section == 1 && productViewModel.isNeedLoadMorePage{
            self.startProductFetchRequest()
        }
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

//MARK: - ProductViewModelDelegate
extension ProductListView: ProductViewModelDelegate {
    
    func didReceiveProductResponseStatus(_ Response: ResoponseStatus) {
        switch Response {
        case .loading:
            break
        case .success:
            print("Product",productViewModel.hasMorePage)
            self.productCollectionView.reloadData()
        case .failure(let error):
            print("Error",error)
        }
    }
}
