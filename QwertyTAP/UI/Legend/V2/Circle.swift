//
//  Circle.swift
//  QwertyTAP
//
//  Created by Shahar Biran on 20/06/2021.
//

import UIKit

class Circle : UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = min(self.bounds.size.width/2.0, self.bounds.size.height/2.0)
        self.clipsToBounds = true
    }
}
