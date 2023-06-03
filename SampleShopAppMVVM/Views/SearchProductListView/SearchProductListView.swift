//
//  SearchProductListView.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 03/06/2023.
//

import UIKit

protocol SearchProductListViewDelegate: AnyObject {
    func tappedOnBackButton()
}

class SearchProductListView: UIView {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var productCollectionCV: UIView!
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorCV: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noProductFoundLabel: UILabel!
    
    static let nibName = "SearchProductListView"
    weak var delegate: SearchProductListViewDelegate? = nil
    
    private let section = 2
    private let searchProductListViewModel = SearchProductListViewModel(NetworkService())
    private var searchText: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    private func configureView() -> Void {
        guard let view = self.loadViewFromNib(nibName: SearchProductListView.nibName) else{return}
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        self.initialSetup()
    }
    
    private func initialSetup() -> Void {
        productCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 300, right: 0)
        self.activityIndicatorCV.isHidden = true
        self.productCollectionCV.isHidden = true
        self.searchProductListViewModel.delegate = self
        self.setupSearchBar()
        self.productCollectionView.register(UINib(nibName: ProductCollectionViewCell.cellReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: ProductCollectionViewCell.cellReuseIdentifier)
        
        self.productCollectionView.register(UINib(nibName: IndicatorCollectionViewCell.cellReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: IndicatorCollectionViewCell.cellReuseIdentifier)
        self.productCollectionView.delegate = self
        self.productCollectionView.dataSource = self
    }
    
    private func setupSearchBar() -> Void {
        searchBar.layer.cornerRadius = 16
        searchBar.clipsToBounds = true
        searchBar.searchTextField.textColor = UIColor.white.withAlphaComponent(0.8)
        self.searchBar.barTintColor = UIColor.gray.withAlphaComponent(1.0)
        self.searchBar.backgroundImage = UIColor.clear.image(self.searchBar.bounds.size)
        self.searchBar.delegate = self
    }
    
    
    @IBAction func tappedOnBackButton(_ sender: UIButton) {
        delegate?.tappedOnBackButton()
        
    }
    
    private func startSearch(isNeedLoadMorePage: Bool = false) -> Void {
        var paraDict: [String: String] = ["limit": "10"]
        paraDict["q"] = self.searchText
        let URLRequestBuilder = searchProductListViewModel.makeURLRequestBuilder(paraDict,
                                                                        httpMethod: .get,
                                                                        host: .dummyHost,
                                                                        scheme: .https,
                                                                        endPath: ProductPathRequestType.searchProduct.path,
                                                                        headers: nil)
        if !isNeedLoadMorePage {
            self.searchProductListViewModel.startSearchRequest(URLReuquestBuilder: URLRequestBuilder, searchText: searchText)
            return
        }
        self.searchProductListViewModel.loadMorePage(URLReuquestBuilder: URLRequestBuilder)
    }
    
    private func startLoading() -> Void {
        productCollectionCV.isHidden = true
        activityIndicatorCV.isHidden = false
        noProductFoundLabel.isHidden = true
        activityIndicator.startAnimating()
    }
    
    private func startSuccess() -> Void {
        self.searchProductListViewModel.isAvailableProduct ?
        setupNoProductView(error: "No Product Found"): setupCollectionView()
    }
    
    private func setupCollectionView() -> Void {
        self.activityIndicator.isHidden = true
        activityIndicatorCV.isHidden = true
        noProductFoundLabel.isHidden = true
        productCollectionCV.isHidden = false
    }
    
    private func setupNoProductView(error: String) -> Void {
        self.activityIndicator.isHidden = true
        productCollectionCV.isHidden = true
        activityIndicatorCV.isHidden = false
        noProductFoundLabel.isHidden = false
        noProductFoundLabel.text = error
    }
}

//MARK: - SearchProductListView
extension SearchProductListView: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        self.startSearch(isNeedLoadMorePage: false)
    }
}

//MARK: - UICollectionViewDataSource
extension SearchProductListView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return section
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return searchProductListViewModel.productArray.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.cellReuseIdentifier, for: indexPath) as? ProductCollectionViewCell
            else { return  UICollectionViewCell() }
            cell.setupCell(product: searchProductListViewModel.productArray[safe: indexPath.item])
            return cell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IndicatorCollectionViewCell.cellReuseIdentifier, for: indexPath) as? IndicatorCollectionViewCell
            else { return  UICollectionViewCell() }
            cell.isShowIndicator = self.searchProductListViewModel.hasMorePage
            return cell
        }
    }
}

//MARK: - UICollectionViewDelegate
extension SearchProductListView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.section == 1 && searchProductListViewModel.isNeedLoadMorePage{
            self.startSearch(isNeedLoadMorePage: true)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension SearchProductListView: UICollectionViewDelegateFlowLayout {
    
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

//MARK: - SearchProductViewModelDelegate
extension SearchProductListView: SearchProductListViewModelDelegate {
    func didReceiveProductResponseStatus(_ response: ResoponseStatus) {
        DispatchQueue.main.async {
            switch response {
            case .loading:
                self.startLoading()
            case .success:
                self.startSuccess()
            case .failure(let error):
                self.setupNoProductView(error: error)
                break
            }
            self.productCollectionView.reloadData()
        }
    }
}
