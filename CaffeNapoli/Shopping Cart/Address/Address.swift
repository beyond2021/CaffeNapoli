//
//  Address.swift
//  CaffeNapoli
//
//  Created by Kev1 on 1/25/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import UIKit
import Contacts
struct Address {
    var Street: String?
    var City: String?
    var State: String?
    var Zip: String?
    var FirstName: String?
    var LastName: String?
    
    init() {
    }
    //
    func createShippingAddressFromRef(address: CNContact!) -> Address {
        if let address = address.value as? CNPostalAddress {
            
            let city = address.city
            ...
        }
        
        var shippingAddress: CNContact = Address()
        
        shippingAddress.
        
        shippingAddress.FirstName = ABRecordCopyValue(address, kABPersonFirstNameProperty)?.takeRetainedValue() as? String
        shippingAddress.LastName = ABRecordCopyValue(address, kABPersonLastNameProperty)?.takeRetainedValue() as? String
        
        let addressProperty : ABMultiValueRef = ABRecordCopyValue(address, kABPersonAddressProperty).takeUnretainedValue() as ABMultiValueRef
        if let dict : NSDictionary = ABMultiValueCopyValueAtIndex(addressProperty, 0).takeUnretainedValue() as? NSDictionary {
            shippingAddress.Street = dict[String(kABPersonAddressStreetKey)] as? String
            shippingAddress.City = dict[String(kABPersonAddressCityKey)] as? String
            shippingAddress.State = dict[String(kABPersonAddressStateKey)] as? String
            shippingAddress.Zip = dict[String(kABPersonAddressZIPKey)] as? String
        }
        
        return shippingAddress
    }
    
    
}
