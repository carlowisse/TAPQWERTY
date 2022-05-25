//
//  Keyboard.swift
//  QwertyTAP
//
//  Created by Shahar Biran on 20/05/2021.
//

import UIKit

class Keyboard: UIView {

    private let viewTagDeleteOnReset : Int = 393
    private var view:UIView!
    private let keyAlpha : (low:CGFloat, high:CGFloat) = (low:0.6, high:1.0)
    private let keyAnimationDuration : TimeInterval = 0.4
    
    @IBInspectable var propotionalSpacer : CGFloat = 0.0 {
        didSet {
            self.layoutSubviews()
        }
    }
    
    @IBInspectable var keySizePhone : CGFloat = 10.0 {
        didSet {
            
            self.layoutSubviews()
        }
    }
    @IBInspectable var keySizePad : CGFloat = 20.0 {
        didSet {
            self.layoutSubviews()
        }
    }
    
    private var keySize : CGFloat {
        get {
            return DeviceSize.get(phone: self.keySizePhone, pad: self.keySizePad)
        }
    }
    
    @IBInspectable var spacingPhone : CGFloat = 0.0 {
        didSet {
            
            self.layoutSubviews()
        }
    }
    
    @IBInspectable var spacingPad : CGFloat = 0.0 {
        didSet {
            self.layoutSubviews()
        }
    }
    
    
    
    @IBOutlet var stacksHeight: [NSLayoutConstraint]!
    
    @IBOutlet var leftSpacersWidth: [NSLayoutConstraint]!
    
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet var keysStacks: [UIStackView]!
    
    private var keys : [Int:[Key]]
    
    required init?(coder: NSCoder) {
        self.keys = [Int:[Key]]()
        super.init(coder: coder)
         
        self.view = self.loadViewFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let spacing = DeviceSize.get(phone: self.spacingPhone, pad: self.spacingPad)
        self.mainStack.spacing = max(spacing,0.0)
        self.keysStacks.forEach( {
            $0.spacing = max(spacing,0.0)
        })
        
        let count = min(self.leftSpacersWidth.count, self.stacksHeight.count, self.keysStacks.count)
        for i in 0..<count {
            self.stacksHeight[i].constant = self.keySize
            if i > 0 {
                self.leftSpacersWidth[i].constant = max(0,CGFloat(i) * self.propotionalSpacer * self.keySize)
            } else {
                self.leftSpacersWidth[i].constant = 0.0
            }
        }
    }
    

    private func removeAllKeys() -> Void {
        var removedSubviews = [UIView]()
        self.keys.removeAll()
        for stack in self.keysStacks {
            for v in stack.arrangedSubviews {
                if v.tag == self.viewTagDeleteOnReset {
                    stack.removeArrangedSubview(v)
                    removedSubviews.append(v)
                }
            }
        }
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
    
    
    
    func setLayout(layout:Layout, set:LettersSet, setColors:SetColors) -> Void {
        self.removeAllKeys()
        
        for topdown in layout.topdown {
            var index = 0
            for key in topdown {
                guard self.keysStacks.indices.contains(index) else {
                    continue
                }
                switch key {
                case .letter(let letter):
                    let key = self.makeKey(letter.uppercased(), size: self.keySize, keyColor: setColors.keyColor(for: set.getIndex(for: letter.uppercased()) ?? 0), textColor: setColors.textColor(for: set.getIndex(for: letter.uppercased()) ?? 0))
                    self.keysStacks[index].addArrangedSubview(key)
                    
                    if let setIndex = set.getIndex(for: letter.uppercased()) {
                        if !self.keys.keys.contains(setIndex) {
                            self.keys[setIndex] = [Key]()
                        }
                        self.keys[setIndex]?.append(key)
                    }
                    
                    
                    break
                case .handSpacer:
                    let spacer = self.makeSpacer()
                    self.keysStacks[index].addArrangedSubview(spacer)
                    spacer.widthAnchor.constraint(equalTo: self.keysStacks[index].heightAnchor, multiplier: 0.5).isActive = true
                    break
                }
                
                index = index + 1
            }
        }
    }
    
    private func makeSpacer() -> UIView {
        let v = UIView(frame: .zero)
        v.backgroundColor = .clear
        v.tag = self.viewTagDeleteOnReset
        return v
    }
    
    private func makeKey(_ text:String, size:CGFloat, keyColor:UIColor?, textColor:UIColor?) -> Key {
        let label = Key()
        label.textAlignment = .center
        label.backgroundColor = keyColor
        label.textColor = textColor ?? .white
        label.text = text
        label.addConstraint(NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: label, attribute: .height, multiplier: 1.0, constant: 0.0))
        label.tag = self.viewTagDeleteOnReset
        label.alpha = self.keyAlpha.low
        label.font = UIFont.boldSystemFont(ofSize: DeviceSize.get(phone: 20.0, pad: 32.0))
        return label
    }
    
    func tapped(at index:Int) -> Void {
        for k in self.keys[index] ?? [] {
            k.layer.removeAllAnimations()
            k.alpha = self.keyAlpha.high
            UIView.animate(withDuration: self.keyAnimationDuration, animations: {
                k.alpha = self.keyAlpha.low
            })
            
        }
    }

}
