//
//  User.swift
//  MVVMUiKit
//
//  Created by Manickam on 01/11/24.
//

import Foundation

//MARK: User Data
struct User: Codable {
    let accessToken, refreshToken: String
    let id: Int
    let username, email, firstName, lastName: String
    let gender: String
    let image: String
    
    var fullname: String {
        return firstName + lastName
    }
}

struct Temperatures: Codable {
    
}
