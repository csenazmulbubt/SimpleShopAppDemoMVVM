//
//  ButtonView.swift
//  SampleShopAppMVVM
//
//  Created by Nazmul on 28/04/2023.
//

import UIKit
import Combine

class ButtonView: UIView {

    let model = Model()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    @IBAction func enableButtonAction(_ sender: UIButton) {
        model.isEnable = true
    }
    
    @IBAction func disableButtonAction(_ sender: UIButton) {
        model.isEnable = false
    }
    
    private func configureView() -> Void {
        guard let view = self.loadViewFromNib(nibName: "ButtonView") else{return}
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
}


extension UIView {
    func loadViewFromNib (nibName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

class Model: ObservableObject {
    @Published var isEnable = false
}
