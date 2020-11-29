//
//  CheckoutInteractor.swift
//  BDS
//
//  Created by INVISION on 16/9/2563 BE.
//  Copyright © 2563 Chindanai Peerapattanapaiboon. All rights reserved.
//

import Foundation

class CheckoutInteractor: CheckoutInteractorInterface {
    weak var presenter: CheckoutInteractorDelegate?
    private let operationQueue = OperationQueue()
    
    func fetchOrder() {
        print("@interactor")
        operationQueue.addOperation(ServiceLocator.shared.orderService.getCart(completionBlock: { [weak self] (result) in
            switch result {
            case let .success(response):
                print("success \(String(describing: response))")
                self?.presenter?.fetchOrderDidSuccess(with: response)
                
            case let .failure(error):
                print("error \(String(describing: error))")
                self?.presenter?.fetchOrderDidFail(with: error)
                
            }
        }))
    }
    
    func fetchSiteList(lat: Double, lng: Double) {
        let form = CurrentCoordinateForm(latitude: String(lat), longtitude: String(lng))
        operationQueue.addOperation(ServiceLocator.shared.locationService.getLocation(form: form, completionBlock: { [weak self] result in
            switch result {
            case let .success(response):
                self?.presenter?.fetchSiteListDidSuccess(with: response)

            case let .failure(error):
                print("error \(String(describing: error))")
                self?.presenter?.fetchSiteListDidFail(with: error)
            }
        }))
    }
    
    func fetchAvailableSiteList(withOrder form: CheckOrderStockForm) {        operationQueue.addOperation(ServiceLocator.shared.locationService.getSiteWhereStockAvailable(form, completionBlock: { [weak self] result in
            switch result {
            case let .success(response):
                self?.presenter?.fetchSiteListDidSuccess(with: response)
                
            case let .failure(error):
                print("error \(String(describing: error))")
                self?.presenter?.fetchSiteListDidFail(with: error)
            }
        }))
    }
    
    func updateSiteId(form: OrderForm) {
        operationQueue.addOperation(ServiceLocator.shared.orderService.updateOrder(form, completionBlock: { [weak self] result in
            switch result {
            case let .success(response):
                self?.presenter?.updateOrderDidSuccess(with: response)

            case let .failure(error):
                print("error \(String(describing: error))")
                self?.presenter?.updateOrderDidFail(with: error)
            }
        }))
    }
}
