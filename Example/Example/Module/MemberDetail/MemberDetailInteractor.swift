//
//  MemberDetailInteractor.swift
//  BDS
//
//  Created by INVISION on 11/11/2563 BE.
//  Copyright © 2563 Chindanai Peerapattanapaiboon. All rights reserved.
//

import Foundation

class MemberDetailInteractor: MemberDetailInteractorInterface {
    weak var presenter: MemberDetailInteractorDelegate?
    private let operationQueue = OperationQueue()
    
    func deleteMember(form: ProfileForm) {
        operationQueue.addOperation(ServiceLocator.shared.userService.deleteMember(form, completionBlock: { [weak self] result in
            switch result {
            case let .success(response):
                print("====>\(response)")
                self?.presenter?.deleteMemberDidSuccess(response: response)
            case let .failure(error):
                self?.presenter?.deleteMemberDidFailed(error: error)
            }
        }))
    }
}
