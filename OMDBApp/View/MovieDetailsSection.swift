//
//  Untitled.swift
//  OMDBApp
//
//  Created by İlker Memişoğlu on 28.08.2025.
//
import SwiftUI

// MARK: - Movie Details Section
struct MovieDetailsSection: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Details")
            
            VStack(spacing: 8) {
                DetailRow(label: "Genre", value: movie.genres.joined(separator: ", "))
                DetailRow(label: "Language", value: movie.language)
                DetailRow(label: "Country", value: movie.country)
                if let released = movie.released {
                    DetailRow(label: "Released", value: DateFormatter.movieDisplayFormatter.string(from: released))
                }
                if let dvd = movie.dvd {
                    DetailRow(label: "DVD", value: DateFormatter.movieDisplayFormatter.string(from: dvd))
                }
            }
        }
    }
}
