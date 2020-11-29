//
//  CheckoutRouter.swift
//  BDS
//
//  Created by INVISION on 16/9/2563 BE.
//  Copyright © 2563 Chindanai Peerapattanapaiboon. All rights reserved.
//

import UIKit

class CheckoutRouter: CheckoutRouterInterface {
    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        let viewController = UIStoryboard.loadViewController() as CheckoutViewController
        let presenter: CheckoutPresenterInterface & CheckoutInteractorDelegate = CheckoutPresenter()
        let interactor: CheckoutInteractorInterface = CheckoutInteractor()
        let router: CheckoutRouterInterface = CheckoutRouter()

        viewController.presenter =  presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter

        router.viewController = viewController
        return viewController
    }
    
    static func createModule(siteName: String?, siteDistance: Double?) -> UIViewController {
        let viewController = UIStoryboard.loadViewController() as CheckoutViewController
        let presenter: CheckoutPresenterInterface & CheckoutInteractorDelegate = CheckoutPresenter()
        let interactor: CheckoutInteractorInterface = CheckoutInteractor()
        let router: CheckoutRouterInterface = CheckoutRouter()

        viewController.presenter =  presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        presenter.siteName = siteName
        presenter.siteDistance = siteDistance

        router.viewController = viewController
        return viewController
    }
}
