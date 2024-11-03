//
//  LoginRepository.swift
//  MVVMUiKit
//
//  Created by Manickam on 01/11/24.
//

import Foundation

protocol LoginRepositoryProtocol {
    func login(request: LoginRequest, completion: @escaping CompletionHandler<User>)
    
}
class LoginRepository: LoginRepositoryProtocol {
   

    
//    private let networkManager: NetworkManagerProtocol
//    
//    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
//        self.networkManager = networkManager
//    }
    
    func login(request: LoginRequest, completion: @escaping CompletionHandler<User>) {
        
        let endpoint = "https://dummyjson.com/auth/login"
        let postData: [String : Any] = [
            "username" : request.username,
            "password" : request.password,
            "expiresInMins" : request.expiresInMins
        ]
        NetworkManager.shared.request(
                    urlString: endpoint,
                    method: .post,
                    body: postData,
                    completion: completion
                )
    }
    
}
