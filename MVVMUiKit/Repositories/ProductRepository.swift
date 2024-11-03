//
//  ProductRepository.swift
//  MVVMUiKit
//
//  Created by Manickam on 02/11/24.
//

import Foundation

typealias ProductResult = (Result<ProductResponse, NetworkError>) -> Void

protocol ProductRepositoryProtocol {
    func fetchProducts(page: Int, limit: Int, completion: @escaping ProductResult)
}

class ProductRepository: ProductRepositoryProtocol {
    
    func fetchProducts(page: Int, limit: Int, completion: @escaping ProductResult) {
        let urlString = "https://dummyjson.com/products?limit=\(limit)&skip=\((page - 1) * limit)"
        print("URL String : \(urlString)")
        NetworkManager.shared.request(
            urlString: urlString,
            method: .get,
            body: [:],
            completion: completion)
    }
    
}
