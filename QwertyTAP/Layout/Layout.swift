//
//  Layout.swift
//  QwertyTAP
//
//  Created by Shahar Biran on 20/05/2021.
//

import Foundation

enum LayoutKeyKind {
    case letter(_ letter:String)
    case handSpacer
}

class Layout {
    private(set) var topdown : [[LayoutKeyKind]]
    
    private init() {
        self.topdown = [[LayoutKeyKind]]()
    }
    
    static func qwertyLayout() -> Layout {
        let qwerty = Layout()
        qwerty.addTopdown([.letter("Q"),.letter("A"),.letter("Z")])
        qwerty.addTopdown([.letter("W"),.letter("S"),.letter("X")])
        qwerty.addTopdown([.letter("E"),.letter("D"),.letter("C")])
        qwerty.addTopdown([.letter("R"),.letter("F"),.letter("V")])
        qwerty.addTopdown([.letter("T"),.letter("G"),.letter("B")])
        qwerty.addTopdown([.handSpacer, .handSpacer, .handSpacer])
        qwerty.addTopdown([.letter("Y"),.letter("H"),.letter("N")])
        qwerty.addTopdown([.letter("U"),.letter("J"),.letter("M")])
        qwerty.addTopdown([.letter("I"),.letter("K")])
        qwerty.addTopdown([.letter("O"),.letter("L")])
        qwerty.addTopdown([.letter("P")])
        return qwerty
    }
    
    private func addTopdown(_ letters : [LayoutKeyKind]) -> Void {
        self.topdown.append(letters)
    }
}
