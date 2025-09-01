//
//  Untitled.swift
//  OMDBApp
//
//  Created by İlker Memişoğlu on 28.08.2025.
//
import SwiftUI


// MARK: - Cast and Crew Section
struct CastCrewSection: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Cast & Crew")
            
            VStack(spacing: 8) {
                DetailRow(label: "Director", value: movie.directors.joined(separator: ", "))
                DetailRow(label: "Writer", value: movie.writers.joined(separator: ", "))
                DetailRow(label: "Actors", value: movie.actors.joined(separator: ", "))
            }
        }
    }
}
