//
//  KeychainManager.swift
//  MVVMUiKit
//
//  Created by Manickam on 02/11/24.
//

import Foundation

final class KeychainManager {
    
    static let shared = KeychainManager()
    
    private init() { }
    
    //MARK: Store data in the Keychain
    func store(key: String, data: Data) -> Bool {
        let query:[String:Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecValueData as String : data
        ]
        
        ///Delete existing data in keychin
        SecItemDelete(query as CFDictionary)
        
        /// Add new item in keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    //MARK: Retrive data from KeyChain
    func retrive(key: String) -> Data? {
        let query:[String:Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String : true,
            kSecMatchLimit as String : kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if  status == errSecSuccess, let data = dataTypeRef as? Data {
            return data
        }
        
        return nil
    }
    
    //MARK: Delete data from KeyChain
    func delete(key: String) -> Bool {
        let query:[String:Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}
