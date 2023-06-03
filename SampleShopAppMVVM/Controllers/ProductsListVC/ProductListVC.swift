//
//  ViewController.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 27/04/2023.
//

import UIKit
import Combine

class ProductListVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    @IBAction func tappedOnBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

