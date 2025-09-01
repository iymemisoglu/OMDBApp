//
//  Untitled.swift
//  OMDBApp
//
//  Created by İlker Memişoğlu on 28.08.2025.
//
import SwiftUI

// MARK: - Plot Section
struct PlotSection: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Plot")
            
            Text(movie.plot)
                .font(.body)
                .lineSpacing(4)
        }
    }
}
