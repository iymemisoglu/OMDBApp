//
//  Untitled.swift
//  OMDBApp
//
//  Created by İlker Memişoğlu on 28.08.2025.
//
import SwiftUI

// MARK: - Movie Header View
struct MovieHeaderView: View {
    let movie: Movie
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Poster
            AsyncImage(url: movie.posterURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "film")
                            .foregroundColor(.gray)
                            .font(.largeTitle)
                    )
            }
            .frame(width: 120, height: 180)
            .cornerRadius(12)
            
            // Basic info
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .lineLimit(3)
                
                Text(movie.year)
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                Text(movie.rated)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.2))
                    .foregroundColor(.blue)
                    .cornerRadius(4)
                
                Text(movie.displayRuntime)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if let boxOffice = movie.boxOffice {
                    Text("Box Office: \(movie.displayBoxOffice)")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            
            Spacer()
        }
    }
}
