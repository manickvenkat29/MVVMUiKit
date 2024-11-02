//
//  LoginRepository.swift
//  MVVMUiKit
//
//  Created by Manickam on 01/11/24.
//

import Foundation

protocol LoginRepositoryProtocol {
    func login(request: LoginRequest, completion: @escaping LoginResult)
}

class LoginRepository: LoginRepositoryProtocol {

    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func login(request: LoginRequest, completion: @escaping LoginResult) {
        let endpoint = "https://dummyjson.com/auth/login"
        networkManager.post(urlString: endpoint, body: request, completion: completion)
    }
}
