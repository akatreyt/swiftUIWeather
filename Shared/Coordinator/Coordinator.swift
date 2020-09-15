//
//  Coordinator.swift
//  Weather
//
//  Created by Trey Tartt on 9/15/20.
//

import Foundation
import CoreLocation
import NationalWeatherService


protocol Coordinatorable : ObservableObject{
    init()
    associatedtype DataLayer : Storable
    var publicDataLayer : DataLayer { get set }
    
    associatedtype Network : NetworkFetchable
    var publicNetwork : Network { get }
    
    associatedtype Location : Locatable
    var publicLocation : Location { get }
    
    var locationDesc : String { get set }
    var currentWeather : Forecast? { get set }
    
    func receivedNew(location : CLLocation)
    
    var isFetchingWeather : Bool { get set }
    var isFetchingLocationDetails : Bool { get set }
}

extension Coordinatorable{
    internal func receivedNew(location : CLLocation){
        getZip(forLoction: location)
        updateWeather(atLocation: location)
    }
    
    internal func getZip(forLoction location : CLLocation){
        self.isFetchingLocationDetails = true
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            var descString = Constants.locationDesc
            if let error = error {
                print("Failed getting zip code: \(error)")
            }
            if let postalCode = placemarks?.first?.postalCode,
               let state = placemarks?.first?.administrativeArea,
               let locality = placemarks?.first?.locality{
                descString = locality + "," + state + " - " + postalCode
            } else {
                print("Failed getting zip code from placemark(s): \(placemarks?.description ?? "nil")")
            }
            DispatchQueue.main.async {
                self.locationDesc = descString
            }
            self.isFetchingLocationDetails = false
        }
    }
    
    internal func updateWeather(atLocation location:CLLocation){
        self.isFetchingWeather = true
        self.isFetchingLocationDetails = true
        let location = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        publicNetwork.fetchCurrentWeather(forLocation: location) { (weatherReturn) in
            switch weatherReturn{
            case .success(let newWeather):
                DispatchQueue.main.async {
                    self.currentWeather = newWeather
                }
            case .failure(let error):
                print(error)
            }
            DispatchQueue.main.async {
                self.isFetchingWeather = false
            }
        }
    }
}

class Coordinator<NetworkFetcherGeneric, DataLayerGeneric, LocationGeneric> : Coordinatorable where NetworkFetcherGeneric:NetworkFetchable, DataLayerGeneric:Storable, LocationGeneric:Locatable{
    
    required init() {
        self.publicNetwork = NetworkFetcherGeneric()
        self.publicDataLayer = DataLayerGeneric()
        self.publicLocation = LocationGeneric(withUpdateLocationHandler: nil)
        
        self.publicLocation.newLocationCompletion = { (newLocation) in
            self.receivedNew(location: newLocation)
        }
    }
    @Published var isFetchingWeather: Bool = false
    @Published var isFetchingLocationDetails: Bool = false

    typealias DataLayer = DataLayerGeneric
    typealias Network = NetworkFetcherGeneric
    typealias Location = LocationGeneric
    
    public var publicLocation : LocationGeneric
    public var publicDataLayer : DataLayerGeneric
    public var publicNetwork : NetworkFetcherGeneric
    
    @Published public var locationDesc : String = Constants.locationDesc
    @Published public var currentWeather : Forecast?
}

class PreviewCoordinator<NetworkFetcherGeneric, DataLayerGeneric, LocationGeneric> : Coordinatorable where NetworkFetcherGeneric:NetworkFetchable, DataLayerGeneric:Storable, LocationGeneric:Locatable{
    
    required init() {
        self.publicNetwork = NetworkFetcherGeneric()
        self.publicDataLayer = DataLayerGeneric()
        self.publicLocation = LocationGeneric(withUpdateLocationHandler: nil)
        
        MockNetwork().fetchCurrentWeather(forLocation: CLLocation(latitude: 33.031741, longitude: -97.078818)) { (result) in
            switch result{
            case .success(let location):
                DispatchQueue.main.async {
                    self.locationDesc = "Test"
                    self.currentWeather = location
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    var isFetchingWeather: Bool = false
    var isFetchingLocationDetails: Bool = false

    typealias DataLayer = DataLayerGeneric
    typealias Network = NetworkFetcherGeneric
    typealias Location = LocationGeneric
    
    public var publicLocation : LocationGeneric
    public var publicDataLayer : DataLayerGeneric
    public var publicNetwork : NetworkFetcherGeneric
    
    @Published public var locationDesc : String = Constants.locationDesc
    @Published public var currentWeather : Forecast?
}
