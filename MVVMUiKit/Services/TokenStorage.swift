//
//  TokenStorage.swift
//  MVVMUiKit
//
//  Created by Manickam on 02/11/24.
//

import Foundation
import Security

class TokenStorage {
    
    private enum Keys {
        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
        static let tokenExpiryDate = "tokenExpiryDate"
    }
    
    //MARK: Store tokens securly using keychain
   
    func save(accessToken: String, refreshToken: String, expiresIn: Int){
        guard let accessTokenData = accessToken.data(using: .utf8), let refershTokenData = refreshToken.data(using: .utf8) else {
            return
        }
        // Store access token and refresh token in Keychain
        let statusOfAccessToken = KeychainManager.shared.store(key: Keys.accessToken , data: accessTokenData)
        let statusOfRefreshToken = KeychainManager.shared.store(key: Keys.refreshToken, data: refershTokenData)
        
        
        if statusOfAccessToken && statusOfRefreshToken {
            print("Token Saved Successfuly")
        }
        
        // Calculate expiry date and store it in UserDefaults (you could also use Keychain)
        let expiryDate = Calendar.current.date(byAdding: .second, value: expiresIn, to: Date())
        if let expiryDate = expiryDate {
            UserDefaults.standard.set(expiryDate, forKey: Keys.tokenExpiryDate)
        }
    }
    
    //MARK: Retrieve access token from Keychain
    var accessToken: String? {
        guard let tokendata = KeychainManager.shared.retrive(key: Keys.accessToken), let token = String(data: tokendata, encoding: .utf8) else {
            return nil
        }
        return token
    }
    
    //MARK: Retrive refresh token from Keychain
    var refreshToken: String? {
        guard let tokenData = KeychainManager.shared.retrive(key: Keys.refreshToken), let token = String(data: tokenData, encoding: .utf8) else { return nil }
        return token
    }
    
    //MARK: Retrieve token expiry date from UserDefaults
    var tokenExpiryDate: Date? {
        return UserDefaults.standard.object(forKey: Keys.tokenExpiryDate) as? Date
    }
    
    //MARK: Clear tokens from Keychain and UserDefaults
       func clearTokens() {
           let statusOfDeleteAccessToken = KeychainManager.shared.delete(key: Keys.accessToken)
           let statusOfDeleteRefreshToken = KeychainManager.shared.delete(key: Keys.refreshToken)
           UserDefaults.standard.removeObject(forKey: Keys.tokenExpiryDate)
           
           if statusOfDeleteAccessToken && statusOfDeleteRefreshToken {
               print("Tokens cleared successfully")
           }
       }
}
