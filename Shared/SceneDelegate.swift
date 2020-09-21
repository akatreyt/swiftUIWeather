//
//  SceneDelegate.swift
//  delete
//
//  Created by Trey Tartt on 9/21/20.
//

import UIKit
import SwiftUI
import BackgroundTasks
import CoreLocation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView(coordinator: AppEnvironment.Release)
        
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
        
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: WeatherBGTask.refreshWeather.rawValue,
            using: DispatchQueue.global()
        ) { task in
            self.handleAppRefresh(task)
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        scheduleAppRefresh()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        scheduleAppRefresh()
    }
    
    private func handleAppRefresh(_ task: BGTask) {
        do{
            let coord = AppEnvironment.Release
            let dataLayer : Storable.Type = type(of: coord.publicDataLayer)
            let latestWeather = try dataLayer.getLatest(asType: CompleteWeather.self)
            
            guard let lat = latestWeather.latitude,
                  let lng = latestWeather.longitdue else{ return }
            
            let location = CLLocation(latitude: lat, longitude: lng)
            
            let queue = WeatherQueues.updateQueue
            let group = DispatchGroup()
            
            queue.async(group: group) {
                coord.runBGTask(withDispatchGroup: group, dispatchQueue: queue, forLocation: location)
            }
            
            group.notify(queue: queue) {
                task.setTaskCompleted(success: true)
            }
            scheduleAppRefresh()
        }catch{
            print(error)
        }
    }
    
    private func scheduleAppRefresh() {
        do {
            let request = BGProcessingTaskRequest(identifier: WeatherBGTask.refreshWeather.rawValue)
            request.requiresNetworkConnectivity = true
            request.earliestBeginDate = Date(timeIntervalSinceNow: 3600)
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print(error)
        }
    }
}

