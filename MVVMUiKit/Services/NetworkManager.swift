//
//  NetworkManager.swift
//  MVVMUiKit
//
//  Created by Manickam on 01/11/24.
//

import Foundation

typealias CompletionHandler<T> = (Result<T, NetworkError>) -> Void


protocol NetworkManagerProtocol {
    func request<T:Codable>(urlString: String, method: HttpMethods, body: [String:Any], completion: @escaping CompletionHandler<T>)
}

class NetworkManager: NetworkManagerProtocol {
    
    static let shared = NetworkManager()
    
    init() {}
    // MARK: Genral method for api request
    func request<T: Codable>(
            urlString: String,
            method: HttpMethods,
            body: [String:Any],
            completion: @escaping CompletionHandler<T>) {
            
            guard let url = URL(string: urlString) else {
                completion(.failure(.invalidUrl))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
                //Check the HTTP methods and handle body accordingly
                switch method {
                case .post, .put :
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: body)
                        request.httpBody = jsonData
                    } catch {
                        completion(.failure(.invalidData))
                        return
                    }
                case .get, .delete:
                    request.httpBody = nil
                }
            // Perform request and pass the result back to the completion handler
            performRequest(with: request, completion: completion)
        }
    
    // MARK: Genral method for perform api request
    func performRequest<T:Codable>(with urlRequest: URLRequest, completion: @escaping CompletionHandler<T>) {
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
        
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            let jsonString = String(data: data, encoding: .utf8)
            print("Response JSON: \(jsonString ?? "")")

            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                print("Decoding Error: \(error)")
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
}

enum NetworkError : Error {
    case invalidData
    case invalidUrl
    case noData
    case decodingError
    case networkError(Error)

}

enum HttpMethods: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}
