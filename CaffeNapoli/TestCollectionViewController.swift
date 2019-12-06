//
//  TestCollectionViewController.swift
//  CaffeNapoli
//
//  Created by KEEVIN MITCHELL on 12/18/18.
//  Copyright © 2018 Kev1. All rights reserved.
//
/*
import UIKit
import SystemConfiguration
//import Reachability

class TestCollectionViewController: UIViewController{
    let reachability = Reachability()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
       let networkReahcability = SCNetworkReachabilityCreateWithName(nil, Constants.iternetWebsiteString)
        if checkReachability(with: networkReahcability!) {
            print("Start network task.")
            startMonitorConnection()

        } else {
             print("Cannot get out.")
           self.alert(message:"No internet." , title: "OK.")

        }
//        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        
//                let connection = Beyond2021Reachability()
//                        if connection.connectedToNetwork() == true {
//                                        print("Start network task.")
//                                        startMonitorConnection()
//                        } else {
//                                         print("Cannot get out, please retry")
//                                       self.alert(message:"No internet." , title: "OK.")
//                            startMonitorConnection()
//                        }
//
        
        
    }
    
    private func  startMonitorConnection() {
        print("Begining to monitor internet changes")
         NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: nil)
        
        do {
            try reachability?.startNotifier()
        } catch {
            print("Could not start notifier")
        }
    }
   
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .wifi:
            print ("Reachable via Wifi")
                        self.alert(message: "Via Wifi", title: "Reachable")
        case .cellular:
            print ("Reachable via Cellular")
                        self.alert(message: "Via cellular", title: "Reachable")
   
        case .none:
            print ("Network not reachable")
                        self.alert(message: "Please connect to the internet.", title: "Network not reachable")

        }
        
        
    }
    
    deinit {
        self.reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
        
    }
    
   
}
// GlobalStruct.swift
struct Constants {
    static let iternetWebsiteString = "www.google.com"
}
*/
