//
//  LocationService.swift
//  BDS
//
//  Created by INVISION on 13/8/2563 BE.
//  Copyright © 2563 Chindanai Peerapattanapaiboon. All rights reserved.
//

import Foundation
private var basePath = "mobile"
class LocationService: BaseService {
    
    func getLocation(form: CurrentCoordinateForm, completionBlock: ((Result<[Location], Error>) -> Void)?) -> Operation {
        let latitude = form.latitude
        let longtitude = form.longtitude
        return apiManager.getOperation(from: "/\(basePath)/nearby/NonHeadquarter/\(longtitude)/\(latitude)", form: Form(), completion: completionBlock)
    }
    
    func getSite(siteId: String,completionBlock: ((Result<Location, Error>) -> Void)?) -> Operation {
        return apiManager.getOperation(from: "/\(basePath)/nearby/GetsiteID/\(siteId)", form: Form(), completion: completionBlock)
    }

    func getSiteWhereStockAvailable(_ form: CheckOrderStockForm, completionBlock: ((Result<[Location], Error>) -> Void)?) -> Operation {
        return apiManager.postOperation(to: "/\(basePath)/order/Checkstockbynearby", form: form, completion: completionBlock)
    }
    
    func getCheckStock(form: CheckStockSentForm ,completionBlock: ((Result<[CheckStock], Error>) -> Void)?) -> Operation {
        let productId = form.productId
        let latitude = form.latitude
        let longtitude = form.longtitude
        return apiManager.getOperation(from: "/\(basePath)/order/CheckstockbyItemID/\(productId)/\(longtitude)/\(latitude)", form: Form(), completion: completionBlock)
    }

}
