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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductCartTableViewCell.cellReuseIdentifier, for: indexPath) as? ProductCartTableViewCell else { return UITableViewCell() }
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension ProductCartListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
       return 150
    }

}
