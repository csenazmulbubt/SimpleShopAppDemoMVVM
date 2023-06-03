//
//  HomeVC.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 03/06/2023.
//

import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func tappedOnMenuButton(_ sender: UIButton) {
        switch sender.tag {
        case 2000:
            self.pushProductListVC()
        case 2001:
            self.pushSearchProductListVC()
        default:
            break
        }
    }
    
    func pushProductListVC() -> Void {
        let vc = AppStoryboard.Main.viewController(vc: ProductListVC.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushSearchProductListVC() -> Void {
        let vc = AppStoryboard.Main.viewController(vc: SearchProductListVC.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
