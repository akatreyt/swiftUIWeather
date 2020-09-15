//
//  Environment.swift
//  Weather
//
//  Created by Trey Tartt on 9/15/20.
//

import Foundation


class Environment<NetworkFetcherGeneric, DataLayerGeneric> : NSObject where NetworkFetcherGeneric:NetworkFetchable, DataLayerGeneric:DataWorkable{
    public var data = DataLayerGeneric()
    public var network = NetworkFetcherGeneric()
}
