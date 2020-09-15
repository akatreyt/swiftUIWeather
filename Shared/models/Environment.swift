//
//  Environment.swift
//  Weather
//
//  Created by Trey Tartt on 9/15/20.
//

import Foundation
import NationalWeatherService
import CoreLocation


struct Environment{
    static let Mock = Coordinator<MockNetwork, PlistStorage, MockLocationManager>()
    static let Empty = Coordinator<MockNetwork, PlistStorage, MockLocationManager>()
    static let Release = Coordinator<Network, CoreDataStorage, LocationManager>()
    static let Debug = Coordinator<Network, PlistStorage, LocationManager>()
    static let Preview = PreviewCoordinator<MockNetwork, PlistStorage, MockLocationManager>()
}

