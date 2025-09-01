//
//  Untitled.swift
//  OMDBApp
//
//  Created by İlker Memişoğlu on 28.08.2025.
//
import SwiftUI

// MARK: - Movie Detail View
struct MovieDetailView: View {
    let movie: Movie
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var favoritesManager: FavoriteMoviesManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header with poster and basic info
                    MovieHeaderView(movie: movie)
                    
                    // Movie details
                    MovieDetailsSection(movie: movie)
                    
                    // Ratings
                    RatingsSection(movie: movie)
                    
                    // Plot
                    PlotSection(movie: movie)
                    
                    // Cast and crew
                    CastCrewSection(movie: movie)
                    
                    // Additional info
                    AdditionalInfoSection(movie: movie)
                }
                .padding()
            }
            .navigationTitle(movie.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    FavoriteButton(movie: movie)
                        .environmentObject(favoritesManager)
                }
            }
        }
    }
}
