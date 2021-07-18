//
//  AccountPresenter.swift
//  GymLog
//
//  Created by Kacper P on 18/07/2021.
//

import Foundation

protocol AccountPresenterDelegate: class {
    func updateDataArray(data: [AccountModelData])
}


class AccountPresenter {
    
    private let accountService: AccountService
    weak var accountPresenterDelegate: AccountPresenterDelegate?
    
    init(accountService: AccountService, accountPresenterDelegate: AccountPresenterDelegate) {
        self.accountService = accountService
        self.accountPresenterDelegate = accountPresenterDelegate
    }
    
    func getDataArray() {
        accountService.getUserInfo { (accountModelData) in
            self.accountPresenterDelegate?.updateDataArray(data: accountModelData)
        }
    }
    
}
