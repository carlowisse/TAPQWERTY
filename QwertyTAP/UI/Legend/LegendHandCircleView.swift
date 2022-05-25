//
//  LegendHandCircleView.swift
//  QwertyTAP
//
//  Created by Shahar Biran on 25/05/2021.
//

import Foundation
import UIKit

class LegendHandCircleView : UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = min(self.bounds.size.width, self.bounds.size.height)/2.0
    }
}
