//
//  FavoriteManager.swift
//  OMDBApp
//
//  Created by İlker Memişoğlu on 28.08.2025.
//

import Foundation
import SwiftUI

// MARK: - Favorite Movies Manager
class FavoriteMoviesManager: ObservableObject {
    @Published var favoriteMovies: [Movie] = []
    private let userDefaults = UserDefaults.standard
    private let favoritesKey = "FavoriteMovies"
    
    init() {
        loadFavorites()
    }
    
    func addToFavorites(_ movie: Movie) {
        if !favoriteMovies.contains(where: { $0.id == movie.id }) {
            favoriteMovies.append(movie)
            saveFavorites()
        }
    }
    
    func removeFromFavorites(_ movie: Movie) {
        favoriteMovies.removeAll { $0.id == movie.id }
        saveFavorites()
    }
    
    func toggleFavorite(_ movie: Movie) {
        if isFavorite(movie) {
            removeFromFavorites(movie)
        } else {
            addToFavorites(movie)
        }
    }
    
    func isFavorite(_ movie: Movie) -> Bool {
        return favoriteMovies.contains { $0.id == movie.id }
    }
    
    func getFavoriteMovie(by id: String) -> Movie? {
        return favoriteMovies.first { $0.id == id }
    }
    
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favoriteMovies) {
            userDefaults.set(encoded, forKey: favoritesKey)
        }
    }
    
    private func loadFavorites() {
        if let data = userDefaults.data(forKey: favoritesKey),
           let decoded = try? JSONDecoder().decode([Movie].self, from: data) {
            favoriteMovies = decoded
        }
    }
    
    func clearAllFavorites() {
        favoriteMovies.removeAll()
        saveFavorites()
    }
}

// MARK: - Favorite Button Component
struct FavoriteButton: View {
    let movie: Movie
    @EnvironmentObject var favoritesManager: FavoriteMoviesManager
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                favoritesManager.toggleFavorite(movie)
            }
        }) {
            Image(systemName: favoritesManager.isFavorite(movie) ? "heart.fill" : "heart")
                .foregroundColor(favoritesManager.isFavorite(movie) ? .red : .gray)
                .scaleEffect(favoritesManager.isFavorite(movie) ? 1.1 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: favoritesManager.isFavorite(movie))
        }
    }
}

// MARK: - Empty Favorites View
struct EmptyFavoritesView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart")
                .font(.system(size: 80))
                .foregroundColor(.gray)
            
            Text("No Favorite Movies")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Movies you favorite will appear here")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Text("💡 Tip: Search for movies and tap the heart icon to add them to favorites")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}

// MARK: - Favorites List View
struct FavoritesListView: View {
    let movies: [Movie]
    let onMovieSelected: (Movie) -> Void
    
    var body: some View {
        List {
            ForEach(movies) { movie in
                FavoriteMovieRow(movie: movie) {
                    onMovieSelected(movie)
                }
            }
        }
        .listStyle(PlainListStyle())
    }
}

// MARK: - Favorite Movie Row
struct FavoriteMovieRow: View {
    let movie: Movie
    let onTap: () -> Void
    @EnvironmentObject var favoritesManager: FavoriteMoviesManager
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Poster
                AsyncImage(url: movie.posterURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "film")
                                .foregroundColor(.gray)
                        )
                }
                .frame(width: 60, height: 90)
                .cornerRadius(8)
                
                // Movie Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(movie.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    Text(movie.year)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(movie.primaryGenre)
                        .font(.caption)
                        .foregroundColor(.orange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(4)
                    
                    if let rating = movie.imdbRating {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.caption)
                            Text(String(format: "%.1f", rating))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
                
                // Quick favorite toggle
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        favoritesManager.toggleFavorite(movie)
                    }
                }) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .font(.title3)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

