//
//  HomeVC.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 03/06/2023.
//

import UIKit
import Kingfisher

class HomeVC: UIViewController {

    let networkService = NetworkService()
    override func viewDidLoad() {
        super.viewDidLoad()
        //KingfisherManager.shared.cache.memoryStorage.config.totalCostLimit = 30_000
        //KingfisherManager.shared.cache.memoryStorage.config.countLimit = 30
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showHideNavigationBarHidden()
        self.clearCache()
    }
    
    @IBAction func tappedOnMenuButton(_ sender: UIButton) {
        switch sender.tag {
        case 2000:
            self.pushProductListVC()
        case 2001:
            self.pushSearchProductListVC()
        default:
            print("Namul")
            //https://dummyjson.com/products
            //https://appstaflix.com/Shamim/api/home
            let surl = URL(string: "https://appstaflix.com/Shamim/api/home")
            
            var urlRequest = URLRequest(url: surl!)
            urlRequest.httpMethod = HTTPMethod.get.rawValue
            let headers: [String: String] = ["Content-Type": "application/json", "Access-Control-Allow-Origin": "https://appstaflix.com",  "Access-Control-Allow-Headers": "*", "Access-Control-Allow-Methods": "*"]
            headers.forEach { key,Value in
                urlRequest.addValue(Value, forHTTPHeaderField: key)
            }
            
            networkService.sendGetRequest(URLReuquestBuilder: urlRequest)
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
