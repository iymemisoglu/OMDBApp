//
//  ContentView.swift
//  OMDBApp
//
//  Created by İlker Memişoğlu on 21.08.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var favoritesManager = FavoriteMoviesManager()
    
    var body: some View {
        TabView {
            MovieSearchView()
                .environmentObject(favoritesManager)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            MovieFavoritesView()
                .environmentObject(favoritesManager)
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
            
            MovieDiscoverView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Discover")
                }
        }
        .accentColor(.orange)
    }
}



// MARK: - Date Formatter Extension
extension DateFormatter {
    static let movieDisplayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


