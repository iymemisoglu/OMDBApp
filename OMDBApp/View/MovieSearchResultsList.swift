//
//  Untitled.swift
//  OMDBApp
//
//  Created by İlker Memişoğlu on 28.08.2025.
//


import SwiftUI

// MARK: - Movie Search Results List
struct MovieSearchResultsList: View {
    let results: [MovieSearchResult]
    let onMovieSelected: (MovieSearchResult) -> Void
    
    var body: some View {
        List(results) { result in
            MovieSearchResultRow(result: result) {
                onMovieSelected(result)
            }
        }
        .listStyle(PlainListStyle())
    }
}
