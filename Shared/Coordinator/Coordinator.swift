//
//  Coordinator.swift
//  Weather
//
//  Created by Trey Tartt on 9/15/20.
//

import Foundation
import CoreLocation
import NationalWeatherService
import BackgroundTasks

protocol Coordinatorable : ObservableObject{
    init()
    associatedtype DataLayer : Storable
    var publicDataLayer : DataLayer { get set }
    
    associatedtype Network : NetworkFetchable
    var publicNetwork : Network { get }
    
    associatedtype Location : Locatable
    var publicLocation : Location { get }
    
    var weather : CompleteWeather { get set }
    func receivedNew(location : CLLocation)
    
    var isFetchingWeather : Bool { get set }
    var isFetchingHourlyWeather : Bool { get set }
    var isFetchingLocationDetails : Bool { get set }
    var isFetchingGPSFromZip : Bool { get set }
    
    var isFetching : Bool { get set }
    
    func getGps(fromZip zip : Int)
    
    func runBGTask(withDispatchGroup dpGroup : DispatchGroup, dispatchQueue queue : DispatchQueue, forLocation location : CLLocation)
}

extension Coordinatorable{
    public func runBGTask(withDispatchGroup dpGroup : DispatchGroup, dispatchQueue queue : DispatchQueue, forLocation location : CLLocation){
        queue.async(group: dpGroup) {
            dpGroup.enter()
            self.getZip(forLoction: location, dispatchGroup: dpGroup)
            
            dpGroup.enter()
            self.updateWeather(atLocation: location, dispatchGroup: dpGroup)
            
            dpGroup.enter()
            self.updateHourlyWeather(atLocation: location, dispatchGroup: dpGroup)
        }
    }
    
    internal func receivedNew(location : CLLocation){
        DispatchQueue.main.async {
            self.isFetching = true
        }
        
        weather.latitude = location.coordinate.latitude
        weather.longitdue = location.coordinate.longitude
        
        let queue = WeatherQueues.updateQueue
        let group = DispatchGroup()
        
        queue.async(group: group) {
            group.enter()
            self.getZip(forLoction: location, dispatchGroup: group)
            
            group.enter()
            self.updateWeather(atLocation: location, dispatchGroup: group)
            
            group.enter()
            self.updateHourlyWeather(atLocation: location, dispatchGroup: group)
        }
        
        group.notify(queue: queue) {
            // log to something this task completed
            print("task update completed")
        }
    }
    
    internal func getGps(fromZip zip : Int){
        self.isFetchingGPSFromZip = true
        CLGeocoder().geocodeAddressString("\(zip)") { (placemarks, error) in
            self.isFetchingGPSFromZip = false
            if let _ = error{
                return
            }
            
            if let location = placemarks?.first?.location{
                self.receivedNew(location: CLLocation(latitude: location.coordinate.latitude,
                                                      longitude: location.coordinate.longitude))
            }
        }
    }
    
    private func getZip(forLoction location : CLLocation, dispatchGroup group : DispatchGroup){
        self.isFetchingLocationDetails = true
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            var descString = Constants.locationDesc
            if let error = error {
                print("Failed getting zip code: \(error)")
            }
            if let state = placemarks?.first?.administrativeArea,
               let locality = placemarks?.first?.locality{
                descString = locality + "," + state
                if let zip = placemarks?.first?.postalCode{
                    descString = descString + " - " + zip
                }
                print("finished getting zip")
                group.leave()
            } else {
                print("Failed getting zip code from placemark(s): \(placemarks?.description ?? "nil")")
            }
            self.weather.locationDesc = descString
            self.isFetchingLocationDetails = false
            self.updateFetching()
        }
    }
    
    private func updateWeather(atLocation location:CLLocation, dispatchGroup group : DispatchGroup){
        self.isFetchingWeather = true
        let location = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        publicNetwork.fetchCurrentWeather(forLocation: location) { (weatherReturn) in
            switch weatherReturn{
            case .success(let newWeather):
                do{
                    self.weather.fullForecast = newWeather
                    try DataLayer.save(item: self.weather)
                    #if DEBUG
                    let _ = try DataLayer.getLatest(asType: CompleteWeather.self)
                    #endif
                    print("finished updateWeather")
                    group.leave()
                }catch{
                    assertionFailure("saving failed")
                    print(error)
                }
                self.isFetchingWeather = false
                self.updateFetching()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateHourlyWeather(atLocation location:CLLocation, dispatchGroup group : DispatchGroup){
        self.isFetchingHourlyWeather = true
        let location = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        publicNetwork.fetchHourlyFor(forLocation: location) { (weatherReturn) in
            switch weatherReturn{
            case .success(let newWeather):
                do{
                    self.weather.hourlyForecast = newWeather
                    try DataLayer.save(item: self.weather)
                    #if DEBUG
                    let _ = try DataLayer.getLatest(asType: CompleteWeather.self)
                    #endif
                    print("finished updateHourlyWeather")
                    group.leave()
                }catch{
                    assertionFailure("saving failed")
                    print(error)
                }
                self.isFetchingHourlyWeather = false
                self.updateFetching()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateFetching(){
        let isFetchingSomething = isFetchingWeather || isFetchingHourlyWeather || isFetchingLocationDetails || isFetchingGPSFromZip
        
        if isFetchingSomething && self.isFetching == false{
            DispatchQueue.main.async {
                self.isFetching = true
            }
        }
        
        if !isFetchingSomething && self.isFetching == true{
            DispatchQueue.main.async {
                self.weather.lastFetch = Date()
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
        
        if let _storedWeather = try? DataLayer.getLatest(asType: CompleteWeather.self){
            self.weather = _storedWeather
        }
        
        self.publicLocation.newLocationCompletion = { (newLocation) in
            self.receivedNew(location: newLocation)
        }
    }
    internal var isFetchingWeather: Bool = false
    internal var isFetchingHourlyWeather: Bool = false
    internal var isFetchingLocationDetails: Bool = false
    internal var isFetchingGPSFromZip : Bool = false
    @Published public var isFetching : Bool = false
    
    typealias DataLayer = DataLayerGeneric
    typealias Network = NetworkFetcherGeneric
    typealias Location = LocationGeneric
    
    public var publicLocation : LocationGeneric
    public var publicDataLayer : DataLayerGeneric
    public var publicNetwork : NetworkFetcherGeneric
    
    public var weather = CompleteWeather()
}

class PreviewCoordinator<NetworkFetcherGeneric, DataLayerGeneric, LocationGeneric> : Coordinatorable where NetworkFetcherGeneric:NetworkFetchable, DataLayerGeneric:Storable, LocationGeneric:Locatable{
    
    required init() {
        self.publicNetwork = NetworkFetcherGeneric()
        self.publicDataLayer = DataLayerGeneric()
        self.publicLocation = LocationGeneric(withUpdateLocationHandler: nil)
        
        if let _storedWeather = try? DataLayer.getLatest(asType: CompleteWeather.self){
            self.weather = _storedWeather
        }
        
        MockNetwork().fetchCurrentWeather(forLocation: CLLocation(latitude: 33.031741, longitude: -97.078818)) { (result) in
            switch result{
            case .success(let location):
                DispatchQueue.main.async {
                    self.weather.locationDesc = "Test"
                    self.weather.fullForecast = location
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    internal var isFetchingWeather: Bool = false
    internal var isFetchingHourlyWeather: Bool = false
    internal var isFetchingLocationDetails: Bool = false
    internal var isFetchingGPSFromZip : Bool = false
    @Published public var isFetching : Bool = false
    
    typealias DataLayer = DataLayerGeneric
    typealias Network = NetworkFetcherGeneric
    typealias Location = LocationGeneric
    
    public var publicLocation : LocationGeneric
    public var publicDataLayer : DataLayerGeneric
    public var publicNetwork : NetworkFetcherGeneric
    
    var weather = CompleteWeather()
}
