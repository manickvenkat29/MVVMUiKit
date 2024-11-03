//
//  ProductViewModel.swift
//  MVVMUiKit
//
//  Created by Manickam on 03/11/24.
//

import Foundation

protocol ProductListViewModelDelegate: AnyObject {
    func didUpdateProducts()
    func didFailWithError(_ error: String)
}

class ProductListViewModel {
    
    weak var delegate: ProductListViewModelDelegate?
    var products: [Product] = []
    var isloading: Bool = false
    var errorMessage: String?
    
    private var currentPage: Int = 1
    private var isFetching: Bool = false
    private var totalProducts: Int = 0
    private var limt: Int = 10 // Number of products per page
    
    private let productRepoistory: ProductRepositoryProtocol
    
    init(productRepoistory: ProductRepositoryProtocol = ProductRepository()) {
        self.productRepoistory = productRepoistory
    }
    
    //Public method for fetch initial products
    func fetchInitialProducts(){
        currentPage = 1
        products.removeAll()
        fetchProducts(currentPage)
    }
    
    //Public method to fetch next page
    func fetchNextPage(){
        guard !isFetching && products.count < totalProducts else {
            return
        }
        currentPage += 1
        fetchProducts(currentPage)
    }
    
    //Private methods for fetch products with specific page
    private func fetchProducts(_ page: Int) {
       
        isFetching = true

        productRepoistory.fetchProducts(page: page, limit: limt) { [weak self] result in
            guard  let self = self else { return }
            self.isFetching = false
            DispatchQueue.main.async {
                switch result {
                case .success(let productResponse) :
                    self.products.append(contentsOf: productResponse.products)
                    print(self.products)
                    self.totalProducts = productResponse.total
                    self.delegate?.didUpdateProducts()
                case .failure(let error) :
                    self.handleError(error)
                }
            }
        }
    }
    
    private func handleError(_ error: NetworkError) {
            var errorMessage: String
            switch error {
            case .invalidUrl:
                errorMessage = "Invalid URL."
            case .noData:
                errorMessage = "No data received."
            case .decodingError:
                errorMessage = "Failed to decode data."
            case .networkError(let err):
                errorMessage = err.localizedDescription
            default:
                errorMessage = "An unknown error occurred."
            }
            delegate?.didFailWithError(errorMessage)
        }
    
}
