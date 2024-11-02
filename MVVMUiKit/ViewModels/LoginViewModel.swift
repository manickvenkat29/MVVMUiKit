//
//  LoginViewModel.swift
//  MVVMUiKit
//
//  Created by Manickam on 01/11/24.
//

import Foundation

protocol LoginViewModelProtocol: AnyObject {
    func didReceiveloginResponse(result: Result<User, Error>)
}

class LoginViewModel {
        
    private let loginNetworkrepo: LoginRepositoryProtocol
    weak var delegate: LoginViewModelProtocol?
    
    init(loginNetworkrepo: LoginRepositoryProtocol = LoginRepository()) {
        self.loginNetworkrepo = loginNetworkrepo
        
    }
    
    func login(username: String, password: String) {
        let request = LoginRequest(username: username, password: password, expiresInMins: 30)
        loginNetworkrepo.login(request: request) { [weak self] result in
            guard let self = self else { return }
            self.delegate?.didReceiveloginResponse(result: result)
        }
    }

}
