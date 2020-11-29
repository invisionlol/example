//
//  LocationForm.swift
//  BDS
//
//  Created by INVISION on 13/8/2563 BE.
//  Copyright © 2563 Chindanai Peerapattanapaiboon. All rights reserved.
//
import Foundation

struct LocationForm: Codable {
    let id: String
    let siteID: String
    let siteDesc: String
    let siteCat: String
    let siteCatID: Int
    let siteStatus: Int
    let siteAddress: String
    let siteTel: String
    let sitePharmacistName: String
    let siteArea1EmpID: String
    let siteArea2EmpID: String
    let sitePharmacistEmpID: String
    let areaID: Int
    let sitePharmacistCitizenID: String
    let siteLatitude: Double
    let siteLongitude: Double

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case siteID = "site_id"
        case siteDesc = "site_desc"
        case siteCat = "site_cat"
        case siteCatID = "site_cat_id"
        case siteStatus = "site_status"
        case siteAddress = "site_address"
        case siteTel = "site_tel"
        case sitePharmacistName = "site_pharmacist_name"
        case siteArea1EmpID = "site_area1_emp_id"
        case siteArea2EmpID = "site_area2_emp_id"
        case sitePharmacistEmpID = "site_pharmacist_EmpID"
        case areaID = "area_id"
        case sitePharmacistCitizenID = "site_pharmacist_CitizenID"
        case siteLatitude = "site_latitude"
        case siteLongitude = "site_longitude"
    }
}
