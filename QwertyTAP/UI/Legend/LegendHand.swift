//
//  LegendHand.swift
//  QwertyTAP
//
//  Created by Shahar Biran on 16/11/2017.
//  Copyright © 2017 Tap Systems Inc. All rights reserved.
//

import UIKit

class LegendHand: UIView {
    var view : UIView!
    
    @IBOutlet weak var handImageView: UIImageView!
    
    @IBOutlet weak var fingersContainerView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet var fingers: [LegendHandCircleView]!
    
    @IBInspectable var text : String = "" {
        didSet {
            self.textLabel.text = "\(self.text)\n\(self.additionalText)"
        }
    }
    
    @IBInspectable var additionalText : String = "" {
        didSet {
            self.textLabel.text = "\(self.text)\n\(self.additionalText)"
        }
    }
    
    @IBInspectable var rightHand : Bool = true {
        didSet {
            self.handImageView.image = UIImage(named: self.rightHand ? "righthand" : "lefthand")
            self.fingersContainerView.transform = .init(scaleX: rightHand ? 1.0 : -1.0, y: 1.0)
        }
    }
    
    @IBInspectable var tapcode : Int = 0 {
        didSet {
            for i in 0..<5 {
                if i < self.fingers.count {
                    self.fingers[i].isHidden = tapcode & (0b1 << i) == 0
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.view = self.loadViewFromNib()
        self.textLabel.numberOfLines = 0
    }
    
}
