//
//  MemberDetailPresenter.swift
//  BDS
//
//  Created by INVISION on 11/11/2563 BE.
//  Copyright © 2563 Chindanai Peerapattanapaiboon. All rights reserved.
//

import Foundation

class MemberDetailPresenter: MemberDetailPresenterInterface {
    weak var view: MemberDetailViewInterface?
    var interactor: MemberDetailInteractorInterface?
    var router: MemberDetailRouterInterface?
    var delegate: MemberJoinViewControllerDelegate?
    
    var userData: User?
    
    func goToProfileDetail() {
        let profile = HealthProfileDetailRouter.createModule(withUniqueId: userData?._id)
        router?.viewController?.navigationController?.pushViewController(profile, animated: true)
    }
    
    func willDeleteMember() {
        let form = ProfileForm(id: userData?._id, memberId: nil, type: nil, profileId: nil, phoneNumber: nil, name: nil, weight: nil, height: nil, behavior: nil, symptom: nil, drugAllergyHistory: nil, congenitalDisease: nil, surgicalHistory: nil, familyHistory: nil, birthdate: nil, address: nil, bmi: nil, fbs: nil, gfr: nil, hr: nil, scr: nil, temp: nil, age: nil, profileImage: nil)
        
        interactor?.deleteMember(form: form)
    }
    
    func navigateBackToMemberJoin() {
        print("navigateBackToMemberJoin")
        if let viewController = router?.viewController as? MemberDetailViewController {
            self.delegate?.fromMemberDetail(viewController)
        }
    }
}

extension MemberDetailPresenter: MemberDetailInteractorDelegate {
    func deleteMemberDidSuccess(response: ApiResponse) {
        router?.viewController?.dismissLoadingDialog()
        navigateBackToMemberJoin()
    }
    
    func deleteMemberDidFailed(error: Error) {
        router?.viewController?.dismissLoadingDialog()
        router?.viewController?.showError(error)
    }
}
