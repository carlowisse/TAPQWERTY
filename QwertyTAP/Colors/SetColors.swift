//
//  SetColors.swift
//  QwertyTAP
//
//  Created by Shahar Biran on 20/05/2021.
//

import Foundation
import UIKit

class SetColors {
    private let namePrefix : String
    
    private init(namePrefix:String) {
        self.namePrefix = namePrefix
    }
    
    func keyColor(for set:Int) -> UIColor? {
        return UIColor(named: "\(self.namePrefix)\(set)")
    }
    
    func textColor(for set:Int) -> UIColor? {
        return UIColor(named: "\(self.namePrefix)_text")
    }
    
    static func qwertyColors() -> SetColors {
        return SetColors(namePrefix: "qwerty")
    }
}
