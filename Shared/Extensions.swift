//
//  Extensions.swift
//  Weather
//
//  Created by Trey Tartt on 9/15/20.
//

import Foundation
import NationalWeatherService
import SwiftUI

extension Forecast.Period : Identifiable{
    public var id: Date {
        return self.date.start
    }
}
