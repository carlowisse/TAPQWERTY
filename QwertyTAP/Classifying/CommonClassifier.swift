//
//  CommonClassifier.swift
//  QwertyTAP
//
//  Created by Shahar Biran on 25/05/2021.
//

import Foundation

class CommonClassifier {
    private let commonLetters : [String] =
        ["E","T","A","O","I","N","S","R","H","D","L","U","C","M","F","Y","W","G","P","B","V","K","X","Q","J","Z"]
    
    func getCommonLetter(in letters:[String]) -> String? {
        return self.commonLetters.filter(letters.contains).first
    }
}
