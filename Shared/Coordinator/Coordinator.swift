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
    
    var forecast : CompleteWeather { get set }
    func receivedNew(location : CLLocation)
    
    var isFetchingWeather : Bool { get set }
    var isFetchingHourlyWeather : Bool { get set }
    var isFetchingLocationDetails : Bool { get set }
    
    var isFetching : Bool { get set }
}

extension Coordinatorable{
    internal func receivedNew(location : CLLocation){
        DispatchQueue.main.async {
            self.isFetching = true
        }
        getZip(forLoction: location)
        updateWeather(atLocation: location)
        updateHourlyWeather(atLocation: location)
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
            self.forecast.locationDesc = descString
            self.isFetchingLocationDetails = false
            self.updateFetching()
        }
    }
    
    internal func updateWeather(atLocation location:CLLocation){
        self.isFetchingWeather = true
        let location = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        publicNetwork.fetchCurrentWeather(forLocation: location) { (weatherReturn) in
            switch weatherReturn{
            case .success(let newWeather):
                do{
                    try DataLayer.save(completeWeather: self.forecast)
                    #if DEBUG
                    let _ = try DataLayer.getLatestForcast()
                    #endif
                }catch{
                    assertionFailure("saving failed")
                    print(error)
                }
                self.isFetchingWeather = false
                self.forecast.fullForecast = newWeather
                self.updateFetching()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    internal func updateHourlyWeather(atLocation location:CLLocation){
        self.isFetchingHourlyWeather = true
        let location = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        publicNetwork.fetchHourlyFor(forLocation: location) { (weatherReturn) in
            switch weatherReturn{
            case .success(let newWeather):
                do{
                    try DataLayer.save(completeWeather: self.forecast)
                    #if DEBUG
                    let _ = try DataLayer.getLatestForcast()
                    #endif
                }catch{
                    assertionFailure("saving failed")
                    print(error)
                }
                self.isFetchingHourlyWeather = false
                self.forecast.hourlyForecast = newWeather
                self.updateFetching()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateFetching(){
        let isFetchingSomething = isFetchingWeather || isFetchingHourlyWeather || isFetchingLocationDetails
        
        if isFetchingSomething && self.isFetching == false{
            DispatchQueue.main.async {
                self.isFetching = true
            }
        }
        
        if !isFetchingSomething && self.isFetching == true{
            DispatchQueue.main.async {
                self.isFetching = false
            }
        }

    }
}

class Coordinator<NetworkFetcherGeneric, DataLayerGeneric, LocationGeneric> : Coordinatorable where NetworkFetcherGeneric:NetworkFetchable, DataLayerGeneric:Storable, LocationGeneric:Locatable{
    
    required init() {
        self.publicNetwork = NetworkFetcherGeneric()
        self.publicDataLayer = DataLayerGeneric()
        self.publicLocation = LocationGeneric(withUpdateLocationHandler: nil)
        
        if let _storedWeather = try? DataLayer.getLatestForcast(){
            self.forecast = _storedWeather
        }
        
        self.publicLocation.newLocationCompletion = { (newLocation) in
            self.receivedNew(location: newLocation)
        }
    }
    internal var isFetchingWeather: Bool = false
    internal var isFetchingHourlyWeather: Bool = false
    internal var isFetchingLocationDetails: Bool = false
    @Published public var isFetching : Bool = false
    
    typealias DataLayer = DataLayerGeneric
    typealias Network = NetworkFetcherGeneric
    typealias Location = LocationGeneric
    
    public var publicLocation : LocationGeneric
    public var publicDataLayer : DataLayerGeneric
    public var publicNetwork : NetworkFetcherGeneric
    
    public var forecast = CompleteWeather()
}

class PreviewCoordinator<NetworkFetcherGeneric, DataLayerGeneric, LocationGeneric> : Coordinatorable where NetworkFetcherGeneric:NetworkFetchable, DataLayerGeneric:Storable, LocationGeneric:Locatable{
    
    required init() {
        self.publicNetwork = NetworkFetcherGeneric()
        self.publicDataLayer = DataLayerGeneric()
        self.publicLocation = LocationGeneric(withUpdateLocationHandler: nil)
        
        if let _storedWeather = try? DataLayer.getLatestForcast(){
            self.forecast = _storedWeather
        }
        
        MockNetwork().fetchCurrentWeather(forLocation: CLLocation(latitude: 33.031741, longitude: -97.078818)) { (result) in
            switch result{
            case .success(let location):
                DispatchQueue.main.async {
                    self.forecast.locationDesc = "Test"
                    self.forecast.fullForecast = location
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    internal var isFetchingWeather: Bool = false
    internal var isFetchingHourlyWeather: Bool = false
    internal var isFetchingLocationDetails: Bool = false
    @Published public var isFetching : Bool = false
    
    typealias DataLayer = DataLayerGeneric
    typealias Network = NetworkFetcherGeneric
    typealias Location = LocationGeneric
    
    public var publicLocation : LocationGeneric
    public var publicDataLayer : DataLayerGeneric
    public var publicNetwork : NetworkFetcherGeneric
    
    var forecast = CompleteWeather()
}
