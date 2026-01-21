//
//  BooksViewModel.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 21.01.2026.
//

import Foundation

//API' den kitapları çekeceğiz
final class BooksViewModel {

    func fetchBooks() async throws -> [Book] {
        guard let url = APIEndpoint.books.url else {
            throw NetworkError.invalidURL
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode([Book].self, from: data)
        } catch is DecodingError {
            throw NetworkError.decodingError
        } catch {
            throw NetworkError.serverError(error.localizedDescription)
        }
    }
}

