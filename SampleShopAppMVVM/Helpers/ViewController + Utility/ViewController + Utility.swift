//
//  ViewController + Utility.swift
//  GadgetGlobal
//
//  Created by Nazmul on 29/05/2023.
//

import Foundation
import UIKit

enum AppStoryboard : String {
    case Main = "Main"
    case PreLogin = "PreLogin"
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T>(vc : T.Type) -> T where T: UIViewController {
        let identifier = String(describing: T.self)
        return self.instance.instantiateViewController(withIdentifier: identifier) as! T
    }
}
