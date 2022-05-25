//
//  TapcodeMapping.swift
//  QwertyTAP
//
//  Created by Shahar Biran on 25/05/2021.
//

import Foundation

enum IndexKind {
    case delete
    case space
    case nextWord
    case keyboard(_ index:Int)
}

class TapcodeMapping {
    private var mapping : [Orientation:[UInt8:IndexKind]]
    
    private init() {
        self.mapping = [Orientation:[UInt8:IndexKind]]()
    }
    
    private func addMapping(orientation:Orientation, tapcode:UInt8, index:IndexKind) -> Void {
        if !self.mapping.keys.contains(orientation) {
            self.mapping[orientation] = [UInt8:IndexKind]()
        }
        self.mapping[orientation]?[tapcode] = index
    }
    
    static func qwertyMapping() -> TapcodeMapping {
        let t = TapcodeMapping()
        t.addMapping(orientation: .left, tapcode: 16, index: .keyboard(0))
        t.addMapping(orientation: .left, tapcode: 8, index: .keyboard(1))
        t.addMapping(orientation: .left, tapcode: 4, index: .keyboard(2))
        t.addMapping(orientation: .left, tapcode: 2, index: .keyboard(3))
        t.addMapping(orientation: .right, tapcode: 2, index: .keyboard(4))
        t.addMapping(orientation: .right, tapcode: 4, index: .keyboard(5))
        t.addMapping(orientation: .right, tapcode: 8, index: .keyboard(6))
        t.addMapping(orientation: .right, tapcode: 16, index: .keyboard(7))
        t.addMapping(orientation: .left, tapcode: 1, index: .space)
        t.addMapping(orientation: .right, tapcode: 31, index: .nextWord)
        t.addMapping(orientation: .right, tapcode: 14, index: .delete)
        t.addMapping(orientation: .right, tapcode: 1, index: .space)
        return t
    }
    
    func getIndexKind(for orientation:Orientation, tapcode:UInt8) -> IndexKind? {
        return self.mapping[orientation]?[tapcode]
    }
}
