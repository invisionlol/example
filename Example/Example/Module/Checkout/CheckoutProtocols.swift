//
//  CheckoutProtocols.swift
//  BDS
//
//  Created by INVISION on 16/9/2563 BE.
//  Copyright © 2563 Chindanai Peerapattanapaiboon. All rights reserved.
//

import UIKit
import CoreLocation

protocol CheckoutPresenterInterface: class {
    var view: CheckoutViewInterface? { get set }
    var interactor: CheckoutInteractorInterface? { get set }
    var router: CheckoutRouterInterface? { get set }
    
    var siteName: String? { get set }
    var siteDistance: Double? { get set }
    var currentLocation: CLLocation? { get set }
    var order: Order? { get set }
    
    func willFetchOrder()
    func goSiteChange()
    func goChoose()
    func onSubmitCheckout(withPaymentType type: String)
}

protocol CheckoutViewInterface: class {
    var presenter: CheckoutPresenterInterface? { get set }
    
    func updateSiteLabel()
    func renderFromSiteChange(siteName: String, siteDistance: Double)
    func savePayment(payment: String)
    func updateUI()
}

protocol CheckoutRouterInterface: class {
    var viewController: UIViewController? { get set }
    static func createModule() -> UIViewController
    static func createModule(siteName: String?, siteDistance: Double?) -> UIViewController
}

protocol CheckoutInteractorInterface: class {
    var presenter: CheckoutInteractorDelegate? { get set }
    
    func fetchOrder()
    func fetchSiteList(lat: Double, lng: Double)
    func updateSiteId(form: OrderForm)
    func fetchAvailableSiteList(withOrder form: CheckOrderStockForm)
}

protocol CheckoutInteractorDelegate: class {
    func fetchOrderDidSuccess(with order: Order)
    func fetchOrderDidFail(with error: Error)
    func fetchSiteListDidSuccess(with sites: [Location])
    func fetchSiteListDidFail(with error: Error)
    func updateOrderDidSuccess(with response: ApiResponse)
    func updateOrderDidFail(with error: Error)
}

protocol CheckoutViewControllerDelegate: class {
    func onSiteChangeEnd(_ sender: SiteChangeViewController)
    func onChooseEnd(_ sender: CheckoutChooseViewController)
}
