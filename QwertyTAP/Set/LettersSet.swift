//
//  LettersSet.swift
//  QwertyTAP
//
//  Created by Shahar Biran on 20/05/2021.
//

import Foundation

class LettersSet {
    
    private var sets : [Int:[String]]
    private var indices : [String:Int]
    
    private init() {
        self.sets = [Int:[String]]()
        self.indices = [String:Int]()
    }
    
    
    
    private func createSet(with set:[String], index:Int) -> Void {
        self.sets[index] = set
        for letter in set {
            self.indices[letter.uppercased()] = index
        }
    }
    
    
    func getSet(for index:Int) -> [String]? {
        return self.sets[index]
    }
    
    func getIndex(for letter:String) -> Int? {
        return self.indices[letter.uppercased()]
    }
    
    static func qwertySet() -> LettersSet {
        let qwerty = LettersSet()
        qwerty.createSet(with: ["Q","A","Z"], index: 0)
        qwerty.createSet(with: ["W","S","X"], index: 1)
        qwerty.createSet(with: ["E","D","C"], index: 2)
        qwerty.createSet(with: ["R","F","V","T","G","B"], index: 3)
        qwerty.createSet(with: ["Y","H","N","U","J","M"], index: 4)
        qwerty.createSet(with: ["I","K"], index: 5)
        qwerty.createSet(with: ["O","L"], index: 6)
        qwerty.createSet(with: ["P"], index: 7)
        return qwerty
    }
    
    func getIndices() -> [Int] {
        var res = Set<Int>()
        for (_, index) in self.indices {
            res.insert(index)
        }
        return Array<Int>(res)
    }
}

