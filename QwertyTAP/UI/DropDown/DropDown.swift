//
//  DropDown.swift
//  QwertyTAP
//
//  Created by Shahar Biran on 20/06/2021.
//

import UIKit

class DropDown: UIView {

    private let words:[String]
    private var current:Int
    private let width : CGFloat = 999.0
    
    private let textColor:UIColor = .lightGray
    private let firstLettersColor:UIColor = .black
    
    required init?(coder: NSCoder) {
        self.words = [String]()
        self.current = 0
        super.init(coder: coder)
        
        self.backgroundColor = .clear
        self.clipsToBounds = true

    }
    
    init(rowHeight:CGFloat, words:[String], firstLettersCount:Int) {
        self.words = words
        self.current = 0
        let height = rowHeight * CGFloat(words.count)
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: self.width, height: height))
        self.backgroundColor = .clear
        self.clipsToBounds = true
        for i in 0..<words.count {
            
        }
    }
    
    private func makeLabel(word:String, posY:CGFloat, height:CGFloat, firstLettersCount:Int) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: posY, width: self.width, height: height))
        label.font = UIFont.systemFont(ofSize: 40.0)
        label.textColor = self.textColor
        label.textAlignment = .left
        return label
    }
    
    
    
}
