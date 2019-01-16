//
//  AppDelegate.swift
//  Todoey
//
//  Created by Gideon Ubaldo on 1/12/19.
//  Copyright © 2019 Gideon Ubaldo. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    //this is the very first thing that gets called
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("did finish launching")
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        do{
            _ = try Realm()
        }catch{
            print("Error initialising new realm, \(error)")
        }
        return true
    }
}

