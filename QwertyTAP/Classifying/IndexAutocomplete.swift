//
//  IndexAutocomplete.swift
//  QwertyTAP
//
//  Created by Shahar Biran on 16/06/2021.
//

import Foundation

class IndexAutocomplete {
    
    private var words : [String:Int]
    
    init() {
        self.words = [String:Int]()
    }
    
    func getAutocomplete(with indexed:Indexed, minDepth:Int, indices : [Int]) -> [String:Int] {
        self.words.removeAll()
        self.autocomplete(with: indexed, currentDepth: 1, minDepth: minDepth, indices: indices)
        return self.words
    }
    
    private func autocomplete(with indexed:Indexed, currentDepth:Int, minDepth:Int, indices : [Int]) -> Void {
        if currentDepth > minDepth && self.words.count > 0 {
            return
        }
        for index in indices {
            if let next = indexed.getNext(at: index) {
                for (word, freq) in next.getWords() {
                    self.words[word] = freq
                }
                self.autocomplete(with: next, currentDepth: currentDepth + 1, minDepth: minDepth, indices: indices)
            }
        }
    }
    
    
}
