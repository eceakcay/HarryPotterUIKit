//
//  NetworkService.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 19.01.2026.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(endpoint: APIEndpoint) async throws -> T

}

class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    //MARK: - ASYNC AWAİT
    func fetch<T: Decodable>(endpoint: APIEndpoint) async throws -> T {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError("Invalid response")
            }
            
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
            
        } catch let decodingError as DecodingError {
            print("Decoding error: \(decodingError)")
            throw NetworkError.decodingError
        } catch {
            throw error
        }
    }
}
