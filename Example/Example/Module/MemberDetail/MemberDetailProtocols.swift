//
//  MemberDetailProtocols.swift
//  BDS
//
//  Created by INVISION on 11/11/2563 BE.
//  Copyright © 2563 Chindanai Peerapattanapaiboon. All rights reserved.
//

import UIKit

protocol MemberDetailPresenterInterface: class {
    var view: MemberDetailViewInterface? { get set }
    var interactor: MemberDetailInteractorInterface? { get set }
    var router: MemberDetailRouterInterface? { get set }
    var delegate: MemberJoinViewControllerDelegate? { get set }
    var userData: User? { get set }
    
    func goToProfileDetail()
    func willDeleteMember()
}

protocol MemberDetailViewInterface: class {
    var presenter: MemberDetailPresenterInterface? { get set }
}

protocol MemberDetailRouterInterface: class {
    var viewController: UIViewController? { get set }
    static func createModule() -> UIViewController
}

protocol MemberDetailInteractorInterface: class {
    var presenter: MemberDetailInteractorDelegate? { get set }
    func deleteMember(form: ProfileForm)
}

protocol MemberDetailInteractorDelegate: class {
    func deleteMemberDidSuccess(response: ApiResponse)
    func deleteMemberDidFailed(error: Error)
}
