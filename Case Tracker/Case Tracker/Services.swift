
import SwiftUI
struct Services: Codable{

   func fetchData(caseNumber: String, caseName: String) async throws -> RootResponse {
        let token = try await fetchAccessToken()
       guard let url = URL(string: "https://api-int.uscis.gov/case-status/\(caseNumber)") else {
           throw URLError(.badURL)
       }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        var decodedCase = try JSONDecoder().decode(RootResponse.self, from: data)
       print(decodedCase)
        decodedCase.setCaseOwner(caseName)
        decodedCase.setCaseNumber(caseNumber)
        return decodedCase
    }

    private func fetchAccessToken() async throws -> String {
        let tokenURL = URL(string: "https://api-int.uscis.gov/oauth/accesstoken")!
        var request = URLRequest(url: tokenURL)
        request.httpMethod = "POST"

        let bodyParams = [
            "client_id": "liqjBdiGqxp4RmPfNfR6VQr4BzyV01QG",
            "client_secret":"4999B0X6fRp9Wti4",
            "grant_type": "client_credentials"
        ]

        let bodyString = bodyParams
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
        
        request.httpBody = bodyString.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await URLSession.shared.data(for: request)

        struct TokenResponse: Decodable {
            let access_token: String
        }

        do {
            let decoded = try JSONDecoder().decode(TokenResponse.self, from: data)
            return decoded.access_token
        } catch {
            print("Error decoding access token: \(error)")
            throw error
        }

    }
}

