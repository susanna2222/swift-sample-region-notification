//
//  AppDelegate.swift
//  swift-sample-region-notification
//
//  Created by Liling Chen on 2019/08/20.
//  Copyright © 2019 CCBJI. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate{

    var window: UIWindow?
    
    let locationManager = CLLocationManager()
    let notificationCenter = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        setupUserNotificationCenter()
        setupLocationManager()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK : Location Manager
    
    func setupLocationManager(){
        
        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways{
            // Request to get alwayls location authorization
            locationManager.requestAlwaysAuthorization()
        }
        
        // set delegate for location manager
        locationManager.delegate = self
        
        // setup attributes of location manager
        locationManager.distanceFilter = 1
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.showsBackgroundLocationIndicator = true
    }
    
    // MARK : Notification
    
    func setupUserNotificationCenter(){
        
        notificationCenter.delegate = self
        
        // request to receive notification
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge, .carPlay], completionHandler: { (granted, error) in
            
            if (error != nil) {
                print("Notification Authorization Error: " + error!.localizedDescription)
            }else{
                print("Notification Authorization Granted: " + granted.description)
                self.setupLocalNotificationByRegion()
            }
        })
    }
    
    //
    func setupLocalNotificationByRegion(){
        
        if !isAllowReceiveNotification() {
            return
        }
        
        // setup notification content
        let content = UNMutableNotificationContent()
        content.title = "Tokyo Tower"
        content.body = "Welcome to Tokyo Tower, A symbol of Japan's post-war rebirth as a major economic power!"
        content.badge = 0
        content.sound = UNNotificationSound.default
        
        // setup trigger by region
        let center = CLLocationCoordinate2D(latitude: 35.658626, longitude: 139.745471)
        let region = CLCircularRegion(center: center, radius: 30, identifier: "SampleRegion")
        region.notifyOnEntry = true
        region.notifyOnExit = false
        
        // setup notification trigger
        let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
        
        // setup notification request
        let request = UNNotificationRequest(identifier: "SampleRequest", content: content, trigger: trigger)
        
        // add request to notification center
        notificationCenter.add(request, withCompletionHandler: {error in
            
            if(error != nil){
                print("RequestLocationNotification ERROR: " + error!.localizedDescription)
            }else{
                print("RequestLocationNotification: " + request.identifier)
            }
        })
    }
    
    func isAllowReceiveNotification() -> Bool{
        
        var isAllow = true
        
        notificationCenter.getNotificationSettings { (settings) in
            // Do not schedule notifications if not authorized.
            
            if (settings.authorizationStatus != .authorized || settings.alertSetting != .enabled){
                isAllow = false
            }
        }
        
        return isAllow
    }
    
    // called if app is running in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // show alert while app is running in foreground
        return completionHandler(UNNotificationPresentationOptions.alert)
    }
    
}
