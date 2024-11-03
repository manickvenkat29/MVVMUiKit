//
//  AuthManager.swift
//  MVVMUiKit
//
//  Created by Manickam on 02/11/24.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    private let tokenStorage = TokenStorage()
    
    private init() {}
    
    //MARK: Fetch the access token
    func getAccessToken() -> String? {
        return tokenStorage.accessToken
    }
    
    //MARK: Check if the token expiry date
    func isAccessTokenExpired() -> Bool {
        guard let expirdate = tokenStorage.tokenExpiryDate else {
            return true
        }
        return   Date() >= expirdate
    }
    
    //MARK: Refresh token if access token is expired
    func refreshTokenIfNeeded(completion: @escaping (Bool)-> Void) {
        guard isAccessTokenExpired() else {
            completion(true) // Token still Valid
            return
        }
        
        guard let refToken = tokenStorage.refreshToken else {
            completion(false) // No refrensh Token stored
            return
        }
        
        //MARK: Refresh Token API Call
        let url = URL(string: "https://dummyjson.com/auth/refresh")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["refreshToken": refToken]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let loginResponse = try JSONDecoder().decode(User.self, from: data)
                
                // Store new access and refresh tokens
                tokenStorage.save(
                    accessToken: loginResponse.accessToken,
                    refreshToken: loginResponse.refreshToken,
                    expiresIn: 30
                )
                
                completion(true)
            } catch {
                completion(false)
            }
        }.resume()
    }
}
