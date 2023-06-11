//
//  ProductDetailsView.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 08/06/2023.
//

import UIKit

protocol ProductDetailsViewDelegate: AnyObject {
    func tappedOnBackButton()
}


class ProductDetailsView: UIView {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var productImgSlideCollectionView: UICollectionView!
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var brandTextLabel: UILabel!
    @IBOutlet weak var ratingTextLabel: UILabel!
    @IBOutlet weak var descriptionTextLabel: UILabel!
    
    weak var delegate: ProductDetailsViewDelegate?
    static let nibName = "ProductDetailsView"
    private var timer: Timer?
    private var counter = 0
    
    public var product: Product? {
        didSet {
            self.initialTextSetup()
            self.productImgSlideCollectionView.reloadData()
            setupPageControl()
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
        guard let view = self.loadViewFromNib(nibName: ProductDetailsView.nibName) else{return}
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        self.initialSetup()
    }
    
    private func initialSetup() -> Void {
        self.productImgSlideCollectionView.register(UINib(nibName: ProductDetailsSlideCollectionViewCell.cellReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: ProductDetailsSlideCollectionViewCell.cellReuseIdentifier)
        
        self.productImgSlideCollectionView.delegate = self
        self.productImgSlideCollectionView.dataSource = self
    }
    
    private func initialTextSetup() -> Void {
        self.titleTextLabel.text = product?.title ?? ""
        self.brandTextLabel.text = product?.brand ?? ""
        self.ratingTextLabel.text = "\(product?.rating ?? 0)"
        self.descriptionTextLabel.text = product?.description
    }
    
    func setupPageControl() {
        pageControl.numberOfPages = product?.images.count ?? 0
        pageControl.currentPage = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
           self.startTimer()
        }
    }
    
    func startTimer() -> Void {
        self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.autoSlideer), userInfo: nil, repeats: true)
    }
    func stopTimer() -> Void {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func autoSlideer() {
        if counter < product?.images.count ?? 0 {
            let index = IndexPath.init(item: counter, section: 0)
            self.productImgSlideCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageControl.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.productImgSlideCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageControl.currentPage = counter
            counter = 1
        }
    }
    
    
    
    @IBAction func tappedOnDoneButton(_ sender: UIButton) {
        delegate?.tappedOnBackButton()
    }
    
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension ProductDetailsView: UICollectionViewDataSource,
                              UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return product?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductDetailsSlideCollectionViewCell.cellReuseIdentifier,
                                                            for: indexPath) as? ProductDetailsSlideCollectionViewCell
        else { return UICollectionViewCell()}
        if let product = self.product {
            cell.productImageView.setImage(with: product.images[safe: indexPath.item] ?? "")
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ProductDetailsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
   
}

//MARK: - UIScrollViewDelegate
extension ProductDetailsView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPos = scrollView.contentOffset.x / self.productImgSlideCollectionView.bounds.size.width
        pageControl.currentPage = Int(scrollPos)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.stopTimer()
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.stopTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.counter = self.pageControl.currentPage
        self.startTimer()
    }
    
}
