//
//  Untitled.swift
//  OMDBApp
//
//  Created by İlker Memişoğlu on 28.08.2025.
//
import SwiftUI

struct MovieFavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoriteMoviesManager
    @State private var selectedMovie: Movie?
    @State private var showingMovieDetail = false
    @State private var showingClearConfirmation = false
    
    var body: some View {
        NavigationView {
            Group {
                if favoritesManager.favoriteMovies.isEmpty {
                    EmptyFavoritesView()
                } else {
                    FavoritesListView(
                        movies: favoritesManager.favoriteMovies,
                        onMovieSelected: { movie in
                            selectedMovie = movie
                            showingMovieDetail = true
                        }
                    )
                }
            }
            .navigationTitle("Favorites")
            .toolbar {
                if !favoritesManager.favoriteMovies.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Clear All") {
                            showingClearConfirmation = true
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .sheet(isPresented: $showingMovieDetail) {
                if let movie = selectedMovie {
                    MovieDetailView(movie: movie)
                        .environmentObject(favoritesManager)
                }
            }
            .alert("Clear All Favorites", isPresented: $showingClearConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Clear All", role: .destructive) {
                    withAnimation {
                        favoritesManager.clearAllFavorites()
                    }
                }
            } message: {
                Text("Are you sure you want to remove all your favorite movies? This action cannot be undone.")
            }
        }
    }
}

struct MovieDiscoverView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "star.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.yellow)
                
                Text("Discover")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Discover new movies and trending content")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .navigationTitle("Discover")
        }
    }
}
