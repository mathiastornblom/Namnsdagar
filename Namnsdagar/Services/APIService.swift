//
//  APIService.swift
//  Namnsdagar
//
//  Created by Mathias Törnblom on 2024-05-05.
//

import Foundation

/// Enum defining possible errors that can occur in the APIService.
enum APIServiceError: Error {
    case invalidURL
    case requestFailed(statusCode: Int)
    case decodingError(description: String)
    case noData
    case unknown

    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .requestFailed(let statusCode):
            return "The request failed with status code \(statusCode)."
        case .decodingError(let description):
            return "Failed to decode data: \(description)"
        case .noData:
            return "No data was received from the server."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

/// A service responsible for fetching name day data from the network.
class APIService {
    static let shared = APIService()

    // Dictionary to cache fetched data, using the year as the key.
    private var cache = [String: [NameDay]]()

    /// Fetches name days for a specific year from the API.
    /// - Parameters:
    ///   - year: The year for which to fetch name days.
    ///   - completion: Completion handler returning a result containing an array of NameDay or an error.
    func fetchNameDays(for year: Int, completion: @escaping (Result<[NameDay], Error>) -> Void) {
        let urlString = Constants.apiBaseURL + "\(year)"
        print("URL being requested: \(urlString)")
        
        // Check if data for the year is already cached.
        if let cachedData = cache[urlString] {
            print("Returning cached data for year: \(year)")
            completion(.success(cachedData))
            return
        }

        // Fetch data from the API if not cached
        guard let url = URL(string: urlString) else {
            completion(.failure(APIServiceError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            // Handle network errors
            if let error = error {
                print("Network request failed with error: \(error.localizedDescription)")
                completion(.failure(APIServiceError.requestFailed(statusCode: (error as NSError).code)))
                return
            }

            // Check for any non-2XX HTTP status codes
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                print("HTTP Request failed with status code: \(statusCode)")
                completion(.failure(APIServiceError.requestFailed(statusCode: statusCode)))
                return
            }

            // Print the raw JSON data received for debugging
            if let jsonData = data, let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Received JSON string: \(jsonString)")
            }

            // Safeguard against nil data
            guard let data = data else {
                print("No data received from the server.")
                completion(.failure(APIServiceError.noData))
                return
            }

            do {
                // Attempt to decode the data to the specified model
                let responseData = try JSONDecoder().decode(ApiResponse.self, from: data)
                self?.cache[urlString] = responseData.dagar
                completion(.success(responseData.dagar))
            } catch {
                // If decoding fails, print the error and return a decoding failure
                print("Failed to decode JSON: \(error)")
                completion(.failure(APIServiceError.decodingError(description: error.localizedDescription)))
            }
        }.resume()

    }
}

// Helper structs to parse nested JSON
struct NameDayResponse: Decodable {
    let days: [NameDay]
    
    enum CodingKeys: String, CodingKey {
        case days = "dagar"
    }
}
