//
//  Hands.swift
//  QwertyTAP
//
//  Created by Shahar Biran on 23/05/2021.
//

import UIKit

class Hands: UIView {

    var view : UIView!
    
    @IBOutlet weak var leftHand: Hand!
    @IBOutlet weak var rightHand: Hand!
    @IBOutlet weak var textLabel: UILabel!
    
    
    private var hands : [Orientation:Hand]
    
    required init?(coder: NSCoder) {
        self.hands = [Orientation : Hand]()
        super.init(coder: coder)
        self.view = self.loadViewFromNib()
        self.hands[.left] = self.leftHand
        self.hands[.right] = self.rightHand
    }

    func setConnectedCount(_ connectedCount:Int, connectedColor:UIColor, disconnectedColor:UIColor) -> Void {
        self.rightHand.setBluetoothImageHidden(connectedCount > 0)
        self.leftHand.setBluetoothImageHidden(connectedCount > 1)
        self.rightHand.setHandTint(connectedCount > 0 ? connectedColor : disconnectedColor)
        self.leftHand.setHandTint(connectedCount > 1 ? connectedColor : disconnectedColor)
    }
    
    func setTextHidden(_ hidden:Bool) -> Void {
        self.textLabel.isHidden = hidden
    }
    func setText(_ text:String?, fadingOut:Bool, fadeOutDuration:TimeInterval = 0.0) -> Void {
        self.textLabel.text = text ?? ""
        self.textLabel.alpha = text != nil ? 1.0 : 0.0
        if fadingOut {
            UIView.animate(withDuration: fadeOutDuration, animations: {
                self.textLabel.alpha = 0.0
            })
        }
        
    }
    
    func animateTint(orientation:Orientation,to toColor:UIColor) -> Void {
        self.hands[orientation]?.animateTint(to: toColor)
    }
    
    func setHandTint(orientation:Orientation, color:UIColor) -> Void {
        if let hand = self.hands[orientation] {
            hand.setHandTint(color)
        }
    }
    
    
}
