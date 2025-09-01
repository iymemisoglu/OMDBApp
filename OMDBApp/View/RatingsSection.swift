//
//  Untitled 2.swift
//  OMDBApp
//
//  Created by İlker Memişoğlu on 28.08.2025.
//

import SwiftUI

// MARK: - Ratings Section
struct RatingsSection: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Ratings")
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(movie.ratings, id: \.source) { rating in
                    RatingCard(rating: rating)
                }
            }
            
            if let averageRating = movie.averageRating {
                HStack {
                    Text("Average Rating:")
                        .fontWeight(.medium)
                    Spacer()
                    Text(String(format: "%.1f", averageRating))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
            }
        }
    }
}
