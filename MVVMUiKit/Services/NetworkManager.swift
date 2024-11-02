//
//  NetworkManager.swift
//  MVVMUiKit
//
//  Created by Manickam on 01/11/24.
//

import Foundation

typealias LoginResult = (Result<User, Error>) -> Void
protocol NetworkManagerProtocol {
    func post<T:Codable>(urlString: String, body: T, completion: @escaping LoginResult)
}

class NetworkManager: NetworkManagerProtocol {
    func post<T>(urlString: String, body: T, completion: @escaping LoginResult) where T:Encodable, T:Decodable {
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(NetworkError.invalidUrl))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encodeJson = try JSONEncoder().encode(body)
            request.httpBody = encodeJson
            print("payload : \(encodeJson)")
        }catch {
            return completion(.failure(NetworkError.invalidData))
        }
        
        DispatchQueue.global(qos: .background).async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let error = error {
                    return completion(.failure(error))
                }
                
                guard let data = data else {
                    return completion(.failure(NetworkError.noData))
                }
                
                do {
                    let decodeData = try JSONDecoder().decode(User.self, from: data)
                    completion(.success(decodeData))
                }catch {
                    completion(.failure(NetworkError.decodingError))
                }
            }
            task.resume()
        }
    }
}

enum NetworkError : Error {
    case invalidData
    case invalidUrl
    case noData
    case decodingError
}

enum HttpMethods: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}
