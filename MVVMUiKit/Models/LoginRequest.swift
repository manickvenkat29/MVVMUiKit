//
//  LoginRequest.swift
//  MVVMUiKit
//
//  Created by Manickam on 01/11/24.
//

import Foundation

struct LoginRequest: Codable {
    let username: String
    let password: String
    let expiresInMins: Int
}
