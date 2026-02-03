//
//  AIService.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 2.02.2026.
//

import Foundation

struct AICompareResult: Decodable {
    let winner: String
    let reason: String
}

final class AIService {
    
    static let shared = AIService()
    private init() {}
    
    private var apiKey: String {
        guard let key = Bundle.main.object(
            forInfoDictionaryKey: "GEMINI_API_KEY"
        ) as? String else {
            fatalError("❌ GEMINI_API_KEY not found in Info.plist")
        }
        return key
    }
    
    func compareCharacters(left: CharacterModel, right: CharacterModel) async throws -> AICompareResult {
        
        let prompt = """
        Compare these two Harry Potter characters in a duel:
        
        1. \(left.fullName) (House: \(left.hogwartsHouse.rawValue), Patronus: \(left.patronus ?? "None"))
        2. \(right.fullName) (House: \(right.hogwartsHouse.rawValue), Patronus: \(right.patronus ?? "None"))
        
        Decide the winner based on magical ability and lore.
        
        Respond strictly with a JSON object containing:
        - "winner": The full name of the winner.
        - "reason": A short, fun explanation (max 2 sentences).
        """
        
        let urlString = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=\(apiKey)"
        
        guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
        
        let requestBody: [String: Any] = [
            "contents": [
                ["parts": [["text": prompt]]]
            ],
            "generationConfig": [
                "response_mime_type": "application/json"
            ]
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Hata durumunda konsola detaylı bilgi basalım
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            if let errorText = String(data: data, encoding: .utf8) {
                print("❌ AI API Error: \(errorText)")
            }
            throw NetworkError.serverError("AI Error: \(httpResponse.statusCode)")
        }
        
        return try parseGeminiResponse(data)
    }
    
    private func parseGeminiResponse(_ data: Data) throws -> AICompareResult {
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let candidates = json["candidates"] as? [[String: Any]],
              let content = candidates.first?["content"] as? [String: Any],
              let parts = content["parts"] as? [[String: Any]],
              let text = parts.first?["text"] as? String,
              let jsonData = text.data(using: .utf8)
        else {
            throw NetworkError.decodingError
        }
        
        do {
            let result = try JSONDecoder().decode(AICompareResult.self, from: jsonData)
            return result
        } catch {
            print("Decoding Error: \(error)")
            throw NetworkError.decodingError
        }
    }
}
