//
//  MovieSearchView.swift
//  OMDBApp
//
//  Created by İlker Memişoğlu on 28.08.2025.
//

import SwiftUI


// MARK: - Movie Search View

struct MovieSearchView: View {
    @StateObject private var omdbService = OMDBService(apiKey: "4b46434") // Using your API key
    @EnvironmentObject var favoritesManager: FavoriteMoviesManager
    @State private var searchText = ""
    @State private var searchResults: [MovieSearchResult] = []
    @State private var selectedMovie: Movie?
    @State private var showingMovieDetail = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(text: $searchText, onSearch: performSearch)
                    .padding()
                
                // Results
                if omdbService.isLoading {
                    Spacer()
                    ProgressView("Searching movies...")
                        .scaleEffect(1.2)
                    Spacer()
                } else if let error = omdbService.errorMessage {
                    Spacer()
                    ErrorView(error: error) {
                        performSearch()
                    }
                    Spacer()
                } else if searchResults.isEmpty && !searchText.isEmpty {
                    Spacer()
                    EmptyStateView(
                        icon: "film",
                        title: "No Movies Found",
                        message: "Try adjusting your search terms"
                    )
                    Spacer()
                } else if searchResults.isEmpty {
                    Spacer()
                    EmptyStateView(
                        icon: "magnifyingglass",
                        title: "Search for Movies",
                        message: "Enter a movie title to get started"
                    )
                    Spacer()
                } else {
                    MovieSearchResultsList(
                        results: searchResults,
                        onMovieSelected: { result in
                            loadMovieDetail(for: result)
                        }
                    )
                }
            }
            .navigationTitle("Movie Search")
            .sheet(isPresented: $showingMovieDetail) {
                if let movie = selectedMovie {
                    MovieDetailView(movie: movie)
                        .environmentObject(favoritesManager)
                }
            }
        }
    }
    
    private func performSearch() {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        Task {
            do {
                searchResults = try await omdbService.searchMovies(query: searchText)
            } catch {
                print("Search error: \(error)")
            }
        }
    }
    
    private func loadMovieDetail(for result: MovieSearchResult) {
        Task {
            do {
                let movie = try await omdbService.fetchMovie(imdbID: result.imdbID)
                await MainActor.run {
                    selectedMovie = movie
                    showingMovieDetail = true
                }
            } catch {
                print("Error loading movie detail: \(error)")
            }
        }
    }
}
