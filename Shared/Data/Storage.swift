//
//  DataLayer.swift
//  Weather
//
//  Created by Trey Tartt on 9/13/20.
//

import Foundation
import CoreLocation
import NationalWeatherService

protocol Storable {
    init()
    func save()
}

public class CoreDataStorage : Storable {
    required public init(){}
    
    func save() {
        print("save")
    }
}

public class PlistStorage : Storable{
    required init() {}
    
    func save() {
        print("save")
    }
}

