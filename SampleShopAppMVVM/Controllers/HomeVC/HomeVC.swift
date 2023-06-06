//
//  HomeVC.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 03/06/2023.
//

import UIKit
import Kingfisher

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //KingfisherManager.shared.cache.memoryStorage.config.totalCostLimit = 30_000
        //KingfisherManager.shared.cache.memoryStorage.config.countLimit = 30
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.clearCache()
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
    
    private func clearCache() -> Void {
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearCache(completion: nil)
        KingfisherManager.shared.cache.clearDiskCache(completion: nil)
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
