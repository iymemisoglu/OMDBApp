//
//  Untitled.swift
//  OMDBApp
//
//  Created by İlker Memişoğlu on 28.08.2025.
//
import SwiftUI

// MARK: - Additional Info Section
struct AdditionalInfoSection: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Additional Information")
            
            VStack(spacing: 8) {
                DetailRow(label: "Awards", value: movie.awards)
                DetailRow(label: "Production", value: movie.production)
                if let website = movie.website {
                    DetailRow(label: "Website", value: website.absoluteString)
                }
            }
        }
    }
}
