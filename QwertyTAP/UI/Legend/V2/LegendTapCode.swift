//
//  LegendTapCode.swift
//  QwertyTAP
//
//  Created by Shahar Biran on 21/06/2021.
//

import UIKit

class LegendTapCode: UIView {

    var view : UIView!
    
    @IBOutlet weak var tapCodeHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var rightHandSpacer: UIView!
    @IBOutlet weak var leftHandSpacer: UIView!
    
    @IBOutlet var circles: [Circle]!
    
    @IBInspectable var tapcode : UInt8 = 0 {
        didSet {
            self.updateCircles()
        }
    }
    
    @IBInspectable var tapCodeHeight : CGFloat = 10.0 {
        didSet {
            self.tapCodeHeight = max(0.0, self.tapCodeHeight)
            self.tapCodeHeightConstraint.constant = self.tapCodeHeight
        }
    }
    
    @IBInspectable var rightHand:Bool = true {
        didSet {
            self.updateOrientation()
            self.updateCircles()
            self.updateText()
        }
    }
    
    @IBInspectable var leftHand:Bool = false {
        didSet {
            self.updateOrientation()
            self.updateCircles()
            self.updateText()
        }
    }
    
    private var displayRightHand : Bool {
        get {
            return self.rightHand || (!self.leftHand)
        }
    }
    
    @IBInspectable var text : String = "" {
        didSet {
            self.updateText()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.view = self.loadViewFromNib()
    }

    private func updateOrientation() -> Void {
        self.leftHandSpacer.isHidden = self.displayRightHand
        self.rightHandSpacer.isHidden = !self.displayRightHand
    }
    
    private func updateText() -> Void {
        if self.text != "" {
            var orientationText : String = ""
            switch (self.rightHand, self.leftHand) {
            case (true, true) : orientationText = "Either hand"
                break
            case (true, false) : orientationText = "Right hand"
                break
            case (false, true) : orientationText = "Right Hand"
                break
            case (false, false) : orientationText = "Right Hand"
                break
            }
            self.textLabel.text = "\(self.text)(\(orientationText))"
        } else {
            self.textLabel.text = ""
        }
    }
    
    private func updateCircles() -> Void {
        
        let fingers : [UInt8] = [0b00001,0b00010,0b00100,0b01000,0b10000]
        
        for i in 0..<min(fingers.count, self.circles.count) {
            let index = self.displayRightHand ? i : min(fingers.count, self.circles.count)-i-1
            let circle = self.circles[index]
            let isOn = self.tapcode & fingers[i] > 0
            circle.backgroundColor = UIColor(named: isOn ? "tapcodeOn" : "tapcodeOff")
        }
    }
    
}
