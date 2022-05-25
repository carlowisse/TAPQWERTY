//
//  MainClassifier.swift
//  QwertyTAP
//
//  Created by Shahar Biran on 25/05/2021.
//

import Foundation

protocol MainClassifierDelegate : AnyObject {
    func mainClassifierWordsChanged(words:[String], tappedLettersCount:Int) -> Void
}
class MainClassifier {
    private var indexClassifier : IndexClassifier
    private var commonClassifier : CommonClassifier
    private var lettersSet : LettersSet
    private(set) var words: [String]
    private var currentPath : [Int]
    
    weak var delegate : MainClassifierDelegate?
    
    private(set) var hasWords : Bool
    
    init(lettersSet:LettersSet) {
        self.hasWords = false
        self.currentPath = [Int]()
        self.commonClassifier = CommonClassifier()
        self.lettersSet = lettersSet
        self.indexClassifier = IndexClassifier(lettersSet: lettersSet)
        self.words = [String]()
    }
    
    func classifyW(csvContent:String) -> Void {
        self.indexClassifier.classify(csv: csvContent)
        self.hasWords = true
    }
    
    
    func getCurrentPathCount() -> Int {
        return self.currentPath.count
    }
    private func processPath(_ path:[Int]) -> Void {
        self.words.removeAll()
        guard path.count > 0 else {
            self.delegate?.mainClassifierWordsChanged(words: self.words, tappedLettersCount: path.count)
            return
        }
        
        let rawWords = self.indexClassifier.getWords(path: path)
        let autoCompleteWords = self.indexClassifier.getAutocomplete(path: path, minDepth: 2, eligibleIndices: self.lettersSet.getIndices())
        let merged = rawWords.merging(autoCompleteWords, uniquingKeysWith: { (current, _) in current })
        self.words = merged.sorted(by: { one, two in one.value > two.value }).map({ (key, value) in key})
        self.delegate?.mainClassifierWordsChanged(words: self.words, tappedLettersCount: path.count)
    }
    
    func tap(index:Int) -> Void {
        self.currentPath.append(index)
        self.processPath(self.currentPath)
    }
    
    func delete() -> Void {
        if !self.currentPath.isEmpty {
            self.currentPath.removeLast()
        }
        self.processPath(self.currentPath)
    }
    
    func clear() -> Void {
        self.words.removeAll()
        self.currentPath.removeAll()
        self.indexClassifier.newWord()
        self.delegate?.mainClassifierWordsChanged(words: self.words, tappedLettersCount: 0)
    }
    
    
    
}
