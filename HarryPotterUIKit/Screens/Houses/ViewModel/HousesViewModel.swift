//
//  HousesViewModel.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 30.01.2026.
//

import Foundation

final class HousesViewModel {
    
    func fetchHouses() async throws -> [House] {
        return try await NetworkService.shared.fetch(
                endpoint: .houses)
    }
}
