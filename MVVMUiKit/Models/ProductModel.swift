//
//  Product.swift
//  MVVMUiKit
//
//  Created by Manickam on 02/11/24.
//

import Foundation
// MARK: - ProductResponse
struct ProductResponse: Codable {
    let products: [Product]
    let total, skip, limit: Int
}

// MARK: - Product
struct Product: Codable {
    let id: Int
    let title, description: String
    let category: String
    let price, discountPercentage, rating: Double
    let stock: Int
    let tags: [String]
    let brand: String?
    let sku: String
    let weight: Int
    let dimensions: Dimensions
    let warrantyInformation, shippingInformation: String
    let availabilityStatus: String
    let reviews: [Review]
    let returnPolicy: String
    let minimumOrderQuantity: Int
    let meta: Meta
    let images: [String]
    let thumbnail: String
}

//enum AvailabilityStatus: String, Codable {
//    case inStock = "In Stock"
//    case lowStock = "Low Stock"
//}
//
//enum Category: String, Codable {
//    case beauty = "beauty"
//    case fragrances = "fragrances"
//    case furniture = "furniture"
//    case groceries = "groceries"
//}

// MARK: - Dimensions
struct Dimensions: Codable {
    let width, height, depth: Double
}

// MARK: - Meta
struct Meta: Codable {
    let createdAt, updatedAt: Date
    let barcode: String
    let qrCode: String
    enum CodingKeys: String, CodingKey {
            case createdAt, updatedAt, barcode, qrCode
    }
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            barcode = try container.decode(String.self, forKey: .barcode)
            qrCode = try container.decode(String.self, forKey: .qrCode)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            
            let createdAtString = try container.decode(String.self, forKey: .createdAt)
            let updatedAtString = try container.decode(String.self, forKey: .updatedAt)
            
            if let parsedCreatedAt = formatter.date(from: createdAtString),
               let parsedUpdatedAt = formatter.date(from: updatedAtString) {
                createdAt = parsedCreatedAt
                updatedAt = parsedUpdatedAt
            } else {
                throw DecodingError.dataCorruptedError(forKey: .createdAt, in: container, debugDescription: "Date string does not match format expected by formatter.")
            }
        }
}

// MARK: - Review
struct Review: Codable {
    let rating: Int
    let comment: String
    let date: Date
    let reviewerName, reviewerEmail: String
    
    enum CodingKeys: String, CodingKey {
            case rating, comment, date, reviewerName, reviewerEmail
        }
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            rating = try container.decode(Int.self, forKey: .rating)
            comment = try container.decode(String.self, forKey: .comment)
            reviewerName = try container.decode(String.self, forKey: .reviewerName)
            reviewerEmail = try container.decode(String.self, forKey: .reviewerEmail)
            
            let dateString = try container.decode(String.self, forKey: .date)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            
            if let parsedDate = formatter.date(from: dateString) {
                date = parsedDate
            } else {
                throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "Date string does not match format expected by formatter.")
            }
        }
}
