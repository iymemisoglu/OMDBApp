//
//  WebService.swift
//  OMDBApp
//
//  Created by İlker Memişoğlu on 27.08.2025.
//

import Foundation


// MARK: - API Service

// Service class for fetching movie data from OMDB API
class OMDBService: ObservableObject {
    private let apiKey: String
    private let baseURL = "https://www.omdbapi.com/"
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func fetchMovie(imdbID: String) async throws -> Movie {
        await MainActor.run {
            self.isLoading = true
            self.errorMessage = nil
        }
        guard let url = URL(string: "\(baseURL)?i=\(imdbID)&apikey=\(apiKey)") else {
            throw OMDBError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw OMDBError.invalidResponse
            }
            let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
            guard movieResponse.response.lowercased() == "true" else {
                throw OMDBError.movieNotFound
            }
            let movie = Movie(from: movieResponse)
            await MainActor.run { self.isLoading = false }
            return movie
        } catch {
            await MainActor.run {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
            }
            throw error
        }
    }
    
    func searchMovies(query: String) async throws -> [MovieSearchResult] {
        await MainActor.run {
            self.isLoading = true
            self.errorMessage = nil
        }
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)?s=\(encodedQuery)&apikey=\(apiKey)") else {
            throw OMDBError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw OMDBError.invalidResponse
            }
            let searchResponse = try JSONDecoder().decode(MovieSearchResponse.self, from: data)
            guard searchResponse.response.lowercased() == "true" else {
                throw OMDBError.movieNotFound
            }
            let results = searchResponse.search
            await MainActor.run { self.isLoading = false }
            return results
        } catch {
            await MainActor.run {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
            }
            throw error
        }
    }
}

