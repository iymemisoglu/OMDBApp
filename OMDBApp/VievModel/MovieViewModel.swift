//
//  MovieViewModel.swift
//  OMDBApp
//
//  Created by İlker Memişoğlu on 21.08.2025.
//

import SwiftUI

class MovieViewModel: ObservableObject {
    @Published var movie: Movie?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let omdbService = OMDBService(apiKey: "your key")
    
    func loadMovie(imdbID: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            movie = try await omdbService.fetchMovie(imdbID: imdbID)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
