//
//  TextViewCursor.swift
//  QwertyTAP
//
//  Created by Shahar Biran on 23/06/2021.
//

import Foundation
import UIKit

class TextViewCursor {
    
    private var cursor:UIView
    private let textView:UITextView
    
    init(textView:UITextView) {
        self.textView = textView
        self.cursor = UIView(frame: .zero)
        textView.addSubview(self.cursor)
        self.cursor.backgroundColor = UIColor(named: "cursor")
    }
    
    func update(offsetFirstLetters:Int) -> Void {
        var rect : CGRect?
        var cursorOnLeft : Bool = true
        if self.textView.text == "" || (self.textView.text.last != nil && self.textView.text.last! == " ") {
            // Add a space
            // Get rect
            // Remove Space
            // Cursor on Left
            self.textView.text.append(" ")
            rect = self.getLastStringRect(" ", in: self.textView, offsetFirstLetters: 0)
            cursorOnLeft = true
            self.textView.deleteBackward()
        } else {
            if let last = self.textView.text.components(separatedBy: " ").last {
                cursorOnLeft = offsetFirstLetters < last.count
                rect = self.getLastStringRect(last, in: self.textView, offsetFirstLetters: cursorOnLeft ? offsetFirstLetters : 0)
                
            }
        }
        
        if let r = rect {
            self.cursor.frame = CGRect(x: cursorOnLeft ? r.minX : r.maxX, y: r.minY, width: 6.0, height: r.height)
        }
        
        
        
        return
    }
    
    private func getLastStringRect(_ string:String, in t:UITextView, offsetFirstLetters:Int) -> CGRect? {
        if let range = t.text.range(of: string, options: .backwards, range: nil, locale: nil) {
            if let posBegin = t.position(from: t.beginningOfDocument, offset: t.text.distance(from: t.text.startIndex, to: t.text.index(range.lowerBound, offsetBy: offsetFirstLetters))),
               let posEnd = t.position(from: t.beginningOfDocument, offset: t.text.distance(from: t.text.startIndex, to: range.upperBound)) {
                if let textRange = t.textRange(from: posBegin, to: posEnd) {
                    return t.firstRect(for: textRange)
                }
            }
        }
        return nil
    }
}
