//
//  UIView+loadViewFromNib.swift
//  QwertyTAP
//
//  Created by Shahar Biran on 20/05/2021.
//

import Foundation
import UIKit

extension UIView {
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view =  nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = self.bounds
        self.backgroundColor = .clear
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view]))
        return view
    }
}
