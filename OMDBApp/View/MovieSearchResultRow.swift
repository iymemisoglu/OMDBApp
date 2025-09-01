//
//  Untitled.swift
//  OMDBApp
//
//  Created by İlker Memişoğlu on 28.08.2025.
//

import SwiftUI


// MARK: - Movie Search Result Row
struct MovieSearchResultRow: View {
    let result: MovieSearchResult
    let onTap: () -> Void
    @EnvironmentObject var favoritesManager: FavoriteMoviesManager
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Poster
                AsyncImage(url: result.posterURL) { image in
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
                    HStack {
                        Text(result.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                            .lineLimit(2)
                        
                        Spacer()
                        
                        // Show favorite indicator if movie is in favorites
                        if let movie = favoritesManager.getFavoriteMovie(by: result.imdbID) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                    }
                    
                    Text(result.year)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(result.type.displayName)
                        .font(.caption)
                        .foregroundColor(.orange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(4)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
