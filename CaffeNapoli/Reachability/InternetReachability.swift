//
//  InternetReachability.swift
//  CaffeNapoli
//
//  Created by KEEVIN MITCHELL on 12/19/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import Foundation
import Reachability
import SystemConfiguration

class InternetReachability {
    let reachability = Reachability()
    init() {
        setReachabilityNotifier()
    }
    private func setReachabilityNotifier() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
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
            //            self.alert(message: "Via Wifi", title: "Reacable")
//            delegate?.showWifiAlert()
        case .cellular:
            print ("Reachable via Cellular")
            //            self.alert(message: "Via cellular", title: "Reacable")
//            delegate?.showCellularAlert()
            
        case .none:
            print ("Network not reachable")
            //            self.alert(message: "Please connect to the internet.", title: "Network not reachable")
//            delegate?.showNoConnectionAlert()
        }
    }
        
        deinit {
            self.reachability?.stopNotifier()
            NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
            
        }
    
}


func checkReachability(with reachability: SCNetworkReachability) -> Bool {
//    let reachability = Reachability()
    var flags = SCNetworkReachabilityFlags()
    func isNetworkReacable (with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAuotmatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAuotmatically && !flags.contains(.interventionRequired)
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
        
    }
    
    
    SCNetworkReachabilityGetFlags(reachability, &flags)
    if isNetworkReacable(with: flags){
        print(flags)
        if flags.contains(.isWWAN){
//            UIViewController.alert(message: "Via mobile", title: "Reacable")
            return true
        }
//        self.alert(message: "via wifi", title: "Reachable")
        return  true
    } else if  (!isNetworkReacable(with: flags)) {
//        self.alert(message: "Sorry no connection", title: "Unreachable")
        print(flags)
        return false
    }
    
    //
  
    
    return false
}

