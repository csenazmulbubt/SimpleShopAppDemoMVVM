//
//  ViewController.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 27/04/2023.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet weak var buttonView: ButtonView!
    @IBOutlet weak var statusLabelShow: UILabel!
    
    private var cancellables = Set<AnyCancellable>()
    let productViewModel = ProductViewModel(NetworkService())
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.binding()
        let EndPoint = URLRequestBuilder(httpMethod: .get,
                                host: .dummyHost,
                                scheme: .https,
                                endPath: ProductPathRequestType.getProducts.path,
                                queryParams: ["limit": "10"])
      
        print("Endl",EndPoint.url)
        productViewModel.getProducts(URLReuquestBuilder: EndPoint)
        
    }
    
    private func binding() -> Void {
        
        buttonView.model.$isEnable
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return  }
                if self.buttonView.model.isEnable {
                    self.statusLabelShow.text = "Enable"
                }
                else{
                    self.statusLabelShow.text = "Disable"
                }
            })
            .store(in: &cancellables)
    }

}

