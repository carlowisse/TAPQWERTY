//
//  TapsController.swift
//  QwertyTAP
//
//  Created by Shahar Biran on 24/05/2021.
//

import Foundation



protocol TapsControllerDelegate : AnyObject {
    func tapsControllerStatusUpdate(_ status:TapsControllerStatus) -> Void
}

struct TapsControllerStatus {
    var connectedTaps : Int
    var assigned : Set<Orientation>
    var nextOrientation : Orientation?
    init() {
        self.connectedTaps = 0
        self.assigned = Set<Orientation>()
        self.nextOrientation = nil
    }
    
    func compare(other : TapsControllerStatus) -> Bool {
        return self.connectedTaps == other.connectedTaps && self.assigned == other.assigned && self.nextOrientation == other.nextOrientation
    }
    
    func isReady() -> Bool {
        guard self.connectedTaps == 2 else { return false }
        guard self.assigned.contains(.left) && assigned.contains(.right) else { return false }
        guard self.nextOrientation == nil else { return false }
        return true
    }
}

class TapsController {
    
    var taps : Set<String>
    var orientations : [String : Orientation]
    var lastStatus : TapsControllerStatus
    
    weak var delegate : TapsControllerDelegate?
    
    init() {
        self.taps = Set<String>()
        self.orientations = [String : Orientation]()
        self.lastStatus = TapsControllerStatus()
        self.lastStatus = self.getStatus()
    }
    
    private func shouldProcessConnectedTaps(_ identifiers:[String]) -> Bool {
        if self.taps == Set<String>(identifiers) && self.taps.count == 2 {
            return self.getNextUnassignedOrientation() != nil
        } else {
            return true
        }
    }
    
    func getOrientation(_ identifier:String) -> Orientation? {
        return self.orientations[identifier]
    }
    
    func connectedTaps(_ identifiers:[String]) -> Void {
        guard self.shouldProcessConnectedTaps(identifiers) else {
            return
        }
        // Keep only connected taps
        self.taps = Set<String>(identifiers)

        // Check status of each connected tap.
        // First, check how many taps are connected

        if self.taps.count < 2 {
            self.orientations.removeAll()
        }
        let newStatus = self.getStatus()
        if !self.lastStatus.compare(other: newStatus) {
            self.lastStatus = newStatus
            self.delegate?.tapsControllerStatusUpdate(newStatus)
        }
        
    }

    func getNextUnassignedOrientation() -> Orientation? {
        if !self.orientations.contains(where: { (k, or) in or == .right}) {
            return .right
        }
        
        if !self.orientations.contains(where: { (k, or) in or == .left}) {
            return .left
        }
        return nil
    }

    func assignOrientation(identifier:String) -> Void {
        if self.taps.count == 2 {
            if let nextOrientation = self.getNextUnassignedOrientation() {
                if self.orientations.keys.contains(identifier) {
                    self.orientations.removeValue(forKey: identifier)
                 }
                self.orientations[identifier] = nextOrientation
                let newStatus = self.getStatus()
                if !self.lastStatus.compare(other: newStatus) {
                    self.lastStatus = newStatus
                    self.delegate?.tapsControllerStatusUpdate(newStatus)
                }
            }
        }
    }
    
    private func getStatus() -> TapsControllerStatus {
        var status = TapsControllerStatus()
        status.connectedTaps = self.taps.count
        for (_, orientation) in self.orientations {
            status.assigned.insert(orientation)
        }
        if status.connectedTaps == 2 {
            status.nextOrientation = self.getNextUnassignedOrientation()
        }
        return status
        
    }
}
