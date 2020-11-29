//
//  ServiceLocator.swift
// BDS
//
//  Created by Koomrhythm Sajjapipat on 8/18/18.
//  Copyright © 2018 Papapay CO.,LTD. All rights reserved.
//

import Foundation

class ServiceLocator {
    private let apiManager = PPPAPIManager()
    
    var locationService: LocationService {
        return LocationService(apiManager)
    }
    
    class var shared: ServiceLocator {
        struct Static {
            static let instance: ServiceLocator = ServiceLocator()
        }
        return Static.instance
    }
}
