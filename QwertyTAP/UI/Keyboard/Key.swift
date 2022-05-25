//
//  Key.swift
//  QwertyTAP
//
//  Created by Shahar Biran on 23/05/2021.
//

import UIKit

class Key: UILabel {

    var keyColor : UIColor? {
        didSet {
            self.backgroundColor = self.keyColor
        }
    }
    
    var keyTextColor : UIColor? {
        didSet {
            self.textColor = self.keyTextColor ?? .white
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = min(self.bounds.size.width, self.bounds.size.height) * 0.3
        self.clipsToBounds = true
        
    }
}
