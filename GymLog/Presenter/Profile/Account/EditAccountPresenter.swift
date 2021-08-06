//
//  EditAccountPresenter.swift
//  GymLog
//
//  Created by Kacper P on 18/07/2021.
//

import Foundation


protocol EditAccountPresenterDelegate: class {
    func updateFirstLabel(firstLabel: String)
    func updateSecondLabel(secondLabel: String)
}

protocol EditAccountPresenterChangeDatabaseDelegate: class {
    func changeDataInDataBase(newValue: String)
    func changeUsernameInDatabase()
    func changeEmailInDatabase(newEmail: String, password: String)
}

protocol PasswordConfirmationDelegate: class {
    func showBeforeChangingEmail()
}

protocol EditAccountPresenterUpdatedData: class {
    func passDataToCallBack(changedComponent: String)
    func successfullyChangedData(changedComponent: String)
    func failedChangedData()
    func errorDuringChangeData()
}

class EditAccountPresenter: EditAccountPresenterChangeDatabaseDelegate {
   
    weak var editAccountPresenterDelegate: EditAccountPresenterDelegate?
    weak var passwordConfirmationDelegate: PasswordConfirmationDelegate?
    weak var editAccountPresenterUpdatedData: EditAccountPresenterUpdatedData?
    
    private let editAccountService: EditAccountService
    
    var editAccountModel = EditAccountModels(mainLabel: "", secondLabel: "")

    init(editAccountService: EditAccountService, editAccountPresenterDelegate: EditAccountPresenterDelegate, passwordConfirmationDelegate: PasswordConfirmationDelegate, editAccountPresenterUpdatedData: EditAccountPresenterUpdatedData) {
        
        self.editAccountPresenterDelegate = editAccountPresenterDelegate
        self.editAccountService = editAccountService
        self.passwordConfirmationDelegate = passwordConfirmationDelegate
        self.editAccountPresenterUpdatedData = editAccountPresenterUpdatedData
    }
    
    func getModel() {
        editAccountPresenterDelegate?.updateFirstLabel(firstLabel: editAccountModel.mainLabel)
        editAccountPresenterDelegate?.updateSecondLabel(secondLabel: editAccountModel.secondLabel)
    }

    func changeDataInDataBase(newValue: String) {
      
        switch editAccountModel.mainLabel {
        case Account.username:
            editAccountService.changeUsername(newUsername: newValue)
            editAccountPresenterUpdatedData?.successfullyChangedData(changedComponent: Account.username)
            editAccountPresenterUpdatedData?.passDataToCallBack(changedComponent: Account.username)
        case Account.email:
            passwordConfirmationDelegate?.showBeforeChangingEmail()
        default:
            break
        }
        
    }
   
    func changeEmailInDatabase(newEmail: String, password: String) {
     
        editAccountService.changeEmail(newEmail: newEmail, password: password, completion: { [unowned self] outcome in
            switch outcome {
            case .changed:
                editAccountPresenterUpdatedData?.successfullyChangedData(changedComponent: Account.email)
                editAccountPresenterUpdatedData?.passDataToCallBack(changedComponent: Account.email)
            case .failed:
                editAccountPresenterUpdatedData?.failedChangedData()
            case .error:
                editAccountPresenterUpdatedData?.errorDuringChangeData()
            }
            
        })
    }
    
    func changeUsernameInDatabase() {
        editAccountService.changeUsername(newUsername: editAccountModel.secondLabel)
    }
}

