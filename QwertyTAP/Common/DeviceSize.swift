//
//  DeviceSize.swift
//  QwertyTAP
//
//  Created by Shahar Biran on 23/05/2021.
//

import Foundation
import UIKit

class DeviceSize {
    private init() {
        
    }
    
    static func get<T>(phone:T, pad:T) -> T {
        return UIDevice.current.userInterfaceIdiom == .pad ? pad : phone
    }
    
    static func ratio<T>(phone:T, pad:T) -> T {
        return UIDevice.current.userInterfaceIdiom == .pad ? pad : phone
    }
}
