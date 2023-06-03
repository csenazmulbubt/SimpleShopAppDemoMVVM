//
//  SearchProductVC.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 03/06/2023.
//

import UIKit

class SearchProductListVC: UIViewController {

    @IBOutlet weak var searchProductListView: SearchProductListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchProductListView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
}

//MARK: - SearchProductListViewDelegate
extension SearchProductListVC: SearchProductListViewDelegate {
    func tappedOnBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
