//
//  ViewController.swift
//  QwertyTAP
//
//  Created by Shahar Biran on 20/05/2021.
//

import UIKit
import TAPKit

class ViewController: UIViewController {

    private let wordsCountLimit : Int = 10
    
    enum Mode {
        case loading
        case setup
        case tapping
        case none
    }
    @IBOutlet weak var hideKeyboardButton: UIButton!
    
    @IBOutlet weak var debugView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var keyboard: Keyboard!
    @IBOutlet weak var hands: Hands!
    @IBOutlet weak var curtain: UIView!
    @IBOutlet weak var wordPicker: UIPickerView!
    
    
    @IBOutlet weak var keyboardHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var keyboardBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBInspectable var htDisconnected : UIColor = .clear
    @IBInspectable var htDefault : UIColor = .clear
    @IBInspectable var htToBeAssigned : UIColor = .clear
    @IBInspectable var htAssigned : UIColor = .clear
    
    @IBOutlet weak var handsWidthConstraint: NSLayoutConstraint!
    
    private var ignoreTapping : Bool = false
    private var lettersSet : LettersSet = .qwertySet()
    private var mapping : TapcodeMapping = .qwertyMapping()
    private var mainClassifier = MainClassifier(lettersSet: .qwertySet())
    private var colors : SetColors = .qwertyColors()
    private var words : [String] = [String]()
    private var handsMinimumWidthConstant : CGFloat {
        get {
            return DeviceSize.get(phone: CGFloat(-280.0), pad: CGFloat(-620.0))
        }
    }
    private var isKeyboardVisible : Bool = true
    private var acceptedText : String = ""
     
    private var textViewCursor : TextViewCursor!
    
    var timer : Timer?
    var controller = TapsController()
    
    var taps : [String:Bool] = ["id1":false,"id2":false]
    var mode : Mode = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.controller.delegate = self
        self.keyboard.setLayout(layout: Layout.qwertyLayout(), set: LettersSet.qwertySet(), setColors: SetColors.qwertyColors())
        self.curtain.alpha = 0.0
        self.mainClassifier.delegate = self
        self.textViewCursor = TextViewCursor(textView: self.textView)
        self.hands.setText(nil, fadingOut: false)
        self.hands.setTextHidden(true)
        
        self.hideKeyboardButton.titleLabel?.numberOfLines = 0
        TAPKit.sharedKit.addDelegate(self)
        TAPKit.sharedKit.setDefaultTAPInputMode(.controllerWithFullHID(), immediate: true)
        TAPKit.sharedKit.start()
        self.updateTextView(text: "", appending: "", highlightFirstLetters: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !self.mainClassifier.hasWords {
            self.showLoading()
            if let csvContent = CSVReader.readCSV("word100k") {
                self.mainClassifier.classifyW(csvContent: csvContent)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3, execute: {
                self.hideLoading()
                self.mode = .setup
                self.setupIfNeeded()
            })
        } else {
            self.setupIfNeeded()
        }
    }
    
    @IBAction func showHideKeyboardButtonTouched(_ sender: Any) {
        if (self.isKeyboardVisible) {
            self.hideKeyboard()
        } else {
            self.showKeyboard()
        }
    }
    
    private func hideKeyboard() -> Void {
        guard self.isKeyboardVisible else { return }
        self.hideKeyboardButton.setTitle("SHOW KEYBOARD", for: .normal)
        self.isKeyboardVisible = false
        self.keyboard.layer.removeAllAnimations()
        UIView.animate(withDuration: 0.5, animations: {
            self.keyboardBottomConstraint.constant = -self.keyboardHeightConstraint.constant
            self.keyboard.alpha = 0.0
            self.wordPicker.layoutIfNeeded()
            self.view.layoutSubviews()
        })
    }
    
    private func showKeyboard() -> Void {
        guard !self.isKeyboardVisible else { return }
        self.hideKeyboardButton.setTitle("HIDE KEYBOARD", for: .normal)
        self.isKeyboardVisible = true
        self.keyboard.layer.removeAllAnimations()
        UIView.animate(withDuration: 0.5, animations: {
            self.keyboardBottomConstraint.constant = 16.0
            self.keyboard.alpha = 1.0
            self.wordPicker.layoutSubviews()
            self.view.layoutSubviews()
        })
    }
    
    
    
    private func setupIfNeeded() -> Void {
        self.processTapsStatus(self.controller.lastStatus)
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
//            let connectedTaps  = Array<String>(self.taps.filter({ (element) in element.value == true}).keys)
            let connectedTaps = Array<String>(TAPKit.sharedKit.getConnectedTaps().keys)
            self.controller.connectedTaps(connectedTaps)
        })
        
    }
    
    @IBAction func T1Touched(_ sender: Any) {
        if let b = sender as? UIButton {
            b.isSelected = !b.isSelected
            self.taps["id1"] = b.isSelected
        }
    }
    
    @IBAction func T2Touched(_ sender: Any) {
        if let b = sender as? UIButton {
            b.isSelected = !b.isSelected
            self.taps["id2"] = b.isSelected
        }
    }
    
    @IBAction func T1Assign(_ sender: Any) {
        self.controller.assignOrientation(identifier:"id1")
    }
    
    @IBAction func T2Assign(_ sender: Any) {
        self.controller.assignOrientation(identifier:"id2")
    }
    
    @objc func keyDown(command:UIKeyCommand) {
        if let input = command.input {
            if let index = Int(input) {
                var tapcode:UInt8?
                var orientation : Orientation?
                
                if index >= 1 && index <= 5 {
                    orientation = .left
                    switch index {
                    case 1 : tapcode = 16
                        break
                    case 2 : tapcode = 8
                        break
                    case 3 : tapcode = 4
                        break
                    case 4 : tapcode = 2
                        break
                    case 5 : tapcode = 1
                        break
                    default : break
                    }
                } else if (index >= 6 && index <= 9) || index == 0 {
                    orientation = .right
                    switch index {
                    case 6 : tapcode = 1
                        break
                    case 7 : tapcode = 2
                        break
                    case 8 : tapcode = 4
                        break
                    case 9 : tapcode = 8
                        break
                    case 0 : tapcode = 16
                        break
                    default : break
                    }
                }
                
                if let t = tapcode, let o = orientation {
                    self.tap(orientation: o, tapcode: t)
                }
                
            } else if input == "d" {
                self.tap(orientation: .right, tapcode: 28)
            }
        }
    }
    
    private func showLoading() -> Void {
        self.loadingView.alpha = 1.0
        self.loadingIndicator.startAnimating()
    }
    
    private func hideLoading() -> Void {
        self.loadingIndicator.stopAnimating()
        UIView.animate(withDuration: 0.3, animations: {
            self.loadingView.alpha = 0.0
        }, completion: nil)
    }
    
    private func minimizeHandsView() -> Void {
        self.handsWidthConstraint.constant = self.handsMinimumWidthConstant
        UIView.animate(withDuration: 0.3, animations: {
            self.hands.layoutIfNeeded()
            self.hands.layoutSubviews()
            self.view.layoutSubviews()
            self.curtain.alpha = 0.0
        })
        self.debugView.isHidden = true
    }
    
    private func maximizeHandsView() -> Void {
        self.handsWidthConstraint.constant = 0.0
        UIView.animate(withDuration: 0.3, animations: {
            self.hands.layoutIfNeeded()
            self.hands.layoutSubviews()
            self.view.layoutSubviews()
            self.curtain.alpha = 1.0
        })
        self.debugView.isHidden = false
    }
    
    private func processTapsStatus(_ status : TapsControllerStatus) -> Void {
        if status.isReady() {
            self.mode = .tapping
            self.minimizeHandsView()
            self.hands.setHandTint(orientation: .left, color: self.htDefault)
            self.hands.setHandTint(orientation: .right, color: self.htDefault)
            self.hands.setTextHidden(true)
        } else {
            self.mode = .setup
            self.updateTapsStatus(status)
            self.maximizeHandsView()
            self.hands.setTextHidden(false)
            
        }
    }
    
    @IBAction func buttonClearTouched(_ sender: Any) {
        self.ignoreTapping = true
        self.showLoading()
        self.mainClassifier.clear()
        self.textView.text = ""
        self.acceptedText = ""
        let _ = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { timer in
            self.ignoreTapping = false
            self.hideLoading()
        })
        self.updateTextView(text: "", appending: "", highlightFirstLetters: 0)
    }
    
    private func updateTapsStatus(_ status:TapsControllerStatus) -> Void {
        self.hands.setConnectedCount(status.connectedTaps, connectedColor: self.htDefault, disconnectedColor: self.htDisconnected)
        self.hands.setText("", fadingOut: false)
        if status.connectedTaps == 2 {
            for orientation in status.assigned {
                self.hands.setHandTint(orientation: orientation, color: self.htAssigned)
                self.hands.animateTint(orientation: orientation, to: self.htDefault)
            }
            if let next = status.nextOrientation {
                let orientationText = next == .right ? "right" : "left"
                self.hands.setText("Double tap SPACE with your \(orientationText) tap", fadingOut: false)
                self.hands.animateTint(orientation: next, to: self.htToBeAssigned)
            } else {
                self.hands.setText("All Done!", fadingOut: false )
            }
        } else {
            if status.connectedTaps == 0 {
                self.hands.setText("Please turn on the first tap", fadingOut: false)
            } else if status.connectedTaps == 1 {
                self.hands.setText("One tap connected. Please turn on the second tap", fadingOut: false)
            }
        }
    }
    
    private func updateTextView(text:String, appending:String, highlightFirstLetters:Int) -> Void {
        let string : String = "\(text)\(appending)"
        let attr = NSMutableAttributedString(string: string)
        let offset = string.count - appending.count + highlightFirstLetters
        let length = appending.count - highlightFirstLetters
        if length > 0 {
            attr.addAttribute(.foregroundColor, value: UIColor.black.withAlphaComponent(0.2), range: NSRange(location: offset, length: length))
        }
        
        attr.addAttribute(.font, value: UIFont.systemFont(ofSize: 60.0), range: NSRange(location: 0, length: string.count))
        self.textView.attributedText = attr
        self.textViewCursor.update(offsetFirstLetters: highlightFirstLetters)
    }
    
    private func pickNextWord() -> Void {
        guard self.words.count > 0 else { return }
        var selected = self.wordPicker.selectedRow(inComponent: 0) + 1
        
        if selected >= self.words.count {
            selected = 0
        }
        self.wordPicker.selectRow(selected, inComponent: 0, animated: true)
        if self.words.indices.contains(selected) {
            let word = self.words[selected]
            self.updateTextView(text: self.acceptedText, appending: word, highlightFirstLetters: self.mainClassifier.getCurrentPathCount())
        }
    }
    
    private func copyWordToText() -> Void {
        let selected = self.wordPicker.selectedRow(inComponent: 0)
        if self.words.indices.contains(selected) {
            self.acceptedText.append("\(self.words[selected]) ")
            self.updateTextView(text: self.acceptedText, appending: "", highlightFirstLetters: 0)
        }
    }
    
    private func tap(orientation:Orientation, tapcode:UInt8) -> Void {
        if let index = self.mapping.getIndexKind(for: orientation, tapcode: tapcode) {
            switch index {
            case .delete : self.mainClassifier.delete()
                break
            case .nextWord : self.pickNextWord()
                break
            case .space :
                self.copyWordToText()
                self.mainClassifier.clear()
                break
            case .keyboard(let index):
                if let color = self.colors.keyColor(for: index) {
                    self.hands.setHandTint(orientation: orientation, color: color)
                    self.hands.animateTint(orientation: orientation, to: self.htDefault)
                }
                self.keyboard.tapped(at: index)
                self.mainClassifier.tap(index: index)
                break
            }
        }
        
    }
}

extension ViewController : TapsControllerDelegate {
    
    func tapsControllerStatusUpdate(_ status: TapsControllerStatus) {
        self.processTapsStatus(status)
    }
}


extension ViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.words[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.words.count
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return DeviceSize.get(phone: 20.0, pad: 72.0)
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view as? UILabel { label = v }
        let word = self.words[row]
        label.font = UIFont.systemFont(ofSize: DeviceSize.get(phone: 20.0, pad: 48.0))
        label.text =  word
        label.textAlignment = .center
        return label
    }
}

extension ViewController : MainClassifierDelegate {
    func mainClassifierWordsChanged(words: [String], tappedLettersCount: Int) {
        
        self.words = words.count > self.wordsCountLimit ? words.dropLast(words.count - self.wordsCountLimit) : words
        self.words.sort(by: { $0.count < $1.count })
        self.wordPicker.reloadComponent(0)
        self.wordPicker.selectRow(0, inComponent: 0, animated: false)
        if self.words.count > 0 {
            self.updateTextView(text: self.acceptedText, appending: self.words[0], highlightFirstLetters: tappedLettersCount)
        } else {
            self.updateTextView(text: self.acceptedText, appending: "", highlightFirstLetters: 0)
        }
    }
}

extension ViewController : TAPKitDelegate {
    func tapped(identifier: String, combination: UInt8, mTap: UInt8) {
        
        if self.mode == .setup {
            let mTapDecoded = min(mTap+1,3)
            if combination == 31 && mTapDecoded == 2 {
                self.controller.assignOrientation(identifier: identifier)
            }
        }else if self.mode == .tapping {
            if !self.ignoreTapping {
                if let orientation = self.controller.getOrientation(identifier) {
                    self.tap(orientation: orientation, tapcode: combination)
                }
                
            }
        }
    }
}
