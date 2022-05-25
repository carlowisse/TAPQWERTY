//
//  Classifier.swift
//  QwertyTAP
//
//  Created by Shahar Biran on 20/05/2021.
//

import Foundation

class Indexed {
    private var depth : Int
    private var words : [String:Int]
    private var next : [Int:Indexed]
    private weak var parent : Indexed?
    
    init(parent:Indexed?) {
        self.depth = 0
        self.words = [String:Int]()
        self.next = [Int:Indexed]()
        self.parent = parent
    }
    
    init(depth:Int, parent:Indexed) {
        self.depth = depth
        self.words = [String:Int]()
        self.next = [Int:Indexed]()
        self.parent = parent
    }
    
    func classify(word:String, freq:Int, letterIndex:Int, lettersSet:LettersSet) -> Void {
        guard word.count != self.depth else {
            self.words[word] = freq
            return
        }
        guard letterIndex >= 0 && letterIndex < word.count else {
            return
        }
        if let index = lettersSet.getIndex(for: String(word[word.index(word.startIndex, offsetBy: letterIndex)])) {
            if !self.next.keys.contains(index) {
                self.next[index] = Indexed(depth: self.depth+1, parent: self)
            }
            self.next[index]!.classify(word: word, freq: freq, letterIndex: letterIndex+1, lettersSet: lettersSet)
        }
    }
    
    func clear() -> Void {
        self.depth = 0
        self.words.removeAll()
        for (_,n) in self.next {
            n.clear()
        }
        self.next.removeAll()
    }
    
    func getWordsSorted() -> [Dictionary<String,Int>.Element] {
        return self.words.sorted(by: { one, two in one.value > two.value })
    }
    
    func getWords() -> [String:Int] {
        return self.words
    }
    
    func getNext(at index:Int) -> Indexed? {
        return self.next[index]
    }
    
    func getParent() -> Indexed? {
        return self.parent
    }
    
}



class IndexClassifier {

    private var lettersSet:LettersSet
    private var origin : Indexed
    private weak var current : Indexed?
    
    private let commonLetters : [String] =
        ["E","T","A","O","I","N","S","R","H","D","L","U","C","M","F","Y","W","G","P","B","V","K","X","Q","J","Z"]
    
    
    init(lettersSet:LettersSet) {
        self.lettersSet = lettersSet
        self.origin = Indexed(parent: nil)
        self.current = self.origin
    }
    
    func classify(words:[String:Int]) -> Void {
        self.origin.clear()
        for (word, freq) in words {
            self.origin.classify(word: word, freq: freq, letterIndex: 0, lettersSet: self.lettersSet)
        }
    }

    func newWord() -> Void {
        self.current = self.origin
    }
    
    private func getCommonLetter(in letters:[String]) -> String? {
        return self.commonLetters.filter(letters.contains).first
    }
    
    func tap(_ index:Int) -> [String]? {
        self.current = self.current?.getNext(at: index)
        return self.current?.getWordsSorted().map({ (key,value) in key})
    }
    
    func getWords(path:[Int]) -> [String:Int] {
        var cursor = self.origin
        for i in 0..<path.count {
            let index = path[i]
            if let next = cursor.getNext(at: index) {
                cursor = next
            } else {
                return [String:Int]()
            }
        }
        return cursor.getWords()
    }
    
    func getWords(_ indices:[Int]) -> (words:[String], deepestWord:String, deepestIndex:Int)  {
        var cursor = self.origin
        var deepestWord:String = ""
        var deepestIndex:Int = 0
        for i in 0..<indices.count {
            let index = indices[i]
            if let first = cursor.getWordsSorted().map({ (key,value) in key}).first {
                deepestWord = first
                deepestIndex = i
            }
            if let next = cursor.getNext(at: index) {
                cursor = next
            } else {
                return (words:[], deepestWord:deepestWord, deepestIndex:deepestIndex)
            }
        }
        return (words:cursor.getWordsSorted().map({ (key,value) in key}), deepestWord:deepestWord, deepestIndex:deepestIndex)
    }
    
    func getAutocomplete(path : [Int], minDepth:Int, eligibleIndices : [Int]) -> [String:Int] {
        let indexAutocomplete = IndexAutocomplete()
        var cursor = self.origin
        for i in 0..<path.count {
            if let next = cursor.getNext(at: path[i]) {
                cursor = next
            } else {
                break
            }
        }
        let words = indexAutocomplete.getAutocomplete(with: cursor, minDepth: 2, indices: self.lettersSet.getIndices())
        return words 
    }
    
    func canDelete() -> Bool {
        return self.current?.getParent() != nil
    }
    
    func delete() -> [String]? {
        if let parent = self.current?.getParent() {
            self.current = parent
            return self.current?.getWordsSorted().map({ (key,value) in key})
        }
        return nil
    }
    
    func classify(csv:String) -> Void {
        let rows = csv.components(separatedBy: "\n")
        var words = [String:Int]()
        for row in rows {
            let components = row.components(separatedBy: ",")
            guard components.count == 2 else {
                continue
            }
            if let freq = Int(components[1].trimmingCharacters(in: .whitespaces)) {
                let word = components[0].trimmingCharacters(in: .whitespaces)
                if let exists = words[word] {
                    if exists > freq {
                        continue
                    }
                }
                words[word] = freq
            }
        }
        self.classify(words: words)
    }
    
}
