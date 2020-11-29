//
//  MemberDetailRouter.swift
//  BDS
//
//  Created by INVISION on 11/11/2563 BE.
//  Copyright © 2563 Chindanai Peerapattanapaiboon. All rights reserved.
//

import UIKit

class MemberDetailRouter: MemberDetailRouterInterface {
    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        let viewController = UIStoryboard.loadViewController() as MemberDetailViewController
        let presenter: MemberDetailPresenterInterface & MemberDetailInteractorDelegate = MemberDetailPresenter()
        let interactor: MemberDetailInteractorInterface = MemberDetailInteractor()
        let router: MemberDetailRouterInterface = MemberDetailRouter()

        viewController.presenter =  presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter

        router.viewController = viewController
        return viewController
    }
    
    static func createModule(user: User, delegate: MemberJoinViewControllerDelegate) -> UIViewController {
        let viewController = UIStoryboard.loadViewController() as MemberDetailViewController
        let presenter: MemberDetailPresenterInterface & MemberDetailInteractorDelegate = MemberDetailPresenter()
        let interactor: MemberDetailInteractorInterface = MemberDetailInteractor()
        let router: MemberDetailRouterInterface = MemberDetailRouter()

        viewController.presenter =  presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        presenter.delegate = delegate
        presenter.userData = user

        router.viewController = viewController
        return viewController
    }
}
