//
//  Hand.swift
//  QwertyTAP
//
//  Created by Shahar Biran on 23/05/2021.
//

import UIKit

class Hand: UIView {

    var view : UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bluetoothImageView: UIImageView!
    
    @IBInspectable var leftHand : Bool = false {
        didSet {
            self.imageView.image = UIImage(named: self.leftHand ? "lefthand" : "righthand")
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.view = self.loadViewFromNib()
    }
    
    func setBluetoothImageHidden(_ hidden:Bool) -> Void {
        self.bluetoothImageView.isHidden = hidden
    }
    
    func setHandTint(_ color:UIColor) -> Void {
        self.imageView.tintColor = color
    }
    
    func animateTint(to color:UIColor) -> Void {
        UIView.animate(withDuration: 1.0, animations: {
            self.imageView.tintColor = color
        })
    }

}
