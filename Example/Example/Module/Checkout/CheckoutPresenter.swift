//
//  CheckoutPresenter.swift
//  BDS
//
//  Created by INVISION on 16/9/2563 BE.
//  Copyright © 2563 Chindanai Peerapattanapaiboon. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class CheckoutPresenter: CheckoutPresenterInterface {
    weak var view: CheckoutViewInterface?
    var interactor: CheckoutInteractorInterface?
    var router: CheckoutRouterInterface?
    
    var siteName: String?
    var siteDistance: Double?
    var currentLocation: CLLocation?
    var order: Order?
    
    func willFetchOrder() {
        print("@presenter")
        interactor?.fetchOrder()
    }
    
    func goSiteChange() {
        let siteChangeViewController = SiteChangeRouter.createModule(order: order, delegate: self)
        router?.viewController?.navigationController?.pushViewController(siteChangeViewController, animated: true)
    }
    
    func goChoose() {
        let checkoutChooseViewController = CheckoutChooseRouter.createModule(delegate: self)
        router?.viewController?.present(checkoutChooseViewController, animated: true, completion: nil)
    }
    
    func onSubmitCheckout(withPaymentType type: String) {
        let paymentViewController = PaymentRouter.createModule(orderId: order?.orderId ?? "", paymentType: type, cartType: order?.cartType ?? "")
        router?.viewController?.navigationController?.pushViewController(paymentViewController, animated: true)
    }
}

extension CheckoutPresenter: CheckoutInteractorDelegate {
    
    func fetchOrderDidSuccess(with order: Order) {
        self.order = order
        view?.updateUI()
        
        // Get all site list
        if let loc = currentLocation {
            if self.order?.latitude == nil || self.order?.longitude == nil || self.order?.latitude == 0 || self.order?.longitude == 0 {
                self.order?.latitude  = loc.coordinate.latitude
                self.order?.longitude = loc.coordinate.longitude
            }
            let form = CheckOrderStockForm(fromOrder: self.order)
            interactor?.fetchAvailableSiteList(withOrder: form)
        } else {
            let form = CheckOrderStockForm(fromOrder: self.order)
            interactor?.fetchAvailableSiteList(withOrder: form)
        }
    }
    
    func fetchOrderDidFail(with error: Error) {
        router?.viewController?.dismissLoadingDialog()
        router?.viewController?.showError(error)
    }
    
    func fetchSiteListDidSuccess(with sites: [Location]) {
        router?.viewController?.dismissLoadingDialog()
        
        guard sites.count > 0 else {
            let alert = UIAlertController(title: nil, message: "ไม่พบสาขาที่มีสินค้าตามรายการที่ท่านเลือก", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ตกลง", style: .default, handler: { [weak self] (_) in
                self?.router?.viewController?.navigationController?.popViewController(animated: true)
            }))
            router?.viewController?.present(alert, animated: true)
            return
        }
        
        var form = OrderForm(fromOrder: order)
        
        // ถ้าไม่เคยกำหนด site id เลย
        if order?.siteId == nil {
            let defaultSite = sites.first
            siteName = defaultSite?.siteDesc
            siteDistance = defaultSite?.calculated
            form.siteId = defaultSite?.siteID
            interactor?.updateSiteId(form: form)
        } else {
            // ถ้ากำหนดเป็นสำนักงาน ให้เอาสาขาที่ใกล้ที่สุดสาขาแรก
            if order?.siteId == "9" {
                let defaultSite = sites.first
                siteName = defaultSite?.siteDesc
                siteDistance = defaultSite?.calculated
                form.siteId = defaultSite?.siteID
                interactor?.updateSiteId(form: form)
                
            } else {
                // ถ้ากำหนดสาขาแล้ว และไม่ได้เป็นสำนักงาน เอาสาขานี้ใช่้ได้เลย
                let defaultSite = sites.first { $0.siteID == order?.siteId }
                var form = OrderForm(fromOrder: order)
                
                // ถ้าสาขาที่กำหนดมา เป็นสาขาที่ไม่มีใน list ของสาขา ให้เอาสาขาแรกมาแทน
                if let defaultSite = defaultSite {
                    siteName = defaultSite.siteDesc
                    siteDistance = defaultSite.calculated
                    form.siteId = defaultSite.siteID
                } else {
                    let nearSite = sites.first
                    siteName = nearSite?.siteDesc
                    siteDistance = nearSite?.calculated
                    form.siteId = nearSite?.siteID
                }
            }
        }
        interactor?.updateSiteId(form: form)
        view?.updateSiteLabel()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didupdate location")
        manager.stopUpdatingLocation()
    }
    
    func fetchSiteListDidFail(with error: Error) {
        router?.viewController?.dismissLoadingDialog()
        router?.viewController?.showError(error)
        router?.viewController?.navigationController?.popViewController(animated: true)
    }
    
    func updateOrderDidSuccess(with response: ApiResponse) {
        router?.viewController?.dismissLoadingDialog()
        print("UpdateOrder Success")
    }
    
    func updateOrderDidFail(with error: Error) {
        router?.viewController?.dismissLoadingDialog()
        router?.viewController?.showError(error)
    }
}

extension CheckoutPresenter: CheckoutViewControllerDelegate {
    func onSiteChangeEnd(_ sender: SiteChangeViewController) {
        let name = sender.siteName
        let distance = sender.siteDistance
        router?.viewController?.navigationController?.popViewController(animated: true)
        view?.renderFromSiteChange(siteName: name, siteDistance: distance)
    }
    
    func onChooseEnd(_ sender: CheckoutChooseViewController) {
        let payment = sender.paymentType
        router?.viewController?.dismiss(animated: true, completion: nil)
        view?.savePayment(payment: payment)
    }
}
