import Foundation

// MARK: - OMDB API Data Models

// Main movie response model
struct MovieResponse: Codable {
    let title: String
    let year: String
    let rated: String
    let released: String
    let runtime: String
    let genre: String
    let director: String
    let writer: String
    let actors: String
    let plot: String
    let language: String
    let country: String
    let awards: String
    let poster: String
    let ratings: [Rating]
    let metascore: String
    let imdbRating: String
    let imdbVotes: String
    let imdbID: String
    let type: String
    let dvd: String
    let boxOffice: String
    let production: String
    let website: String
    let response: String
    
    // Custom coding keys to handle JSON property names
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case country = "Country"
        case awards = "Awards"
        case poster = "Poster"
        case ratings = "Ratings"
        case metascore = "Metascore"
        case imdbRating = "imdbRating"
        case imdbVotes = "imdbVotes"
        case imdbID = "imdbID"
        case type = "Type"
        case dvd = "DVD"
        case boxOffice = "BoxOffice"
        case production = "Production"
        case website = "Website"
        case response = "Response"
    }
}

// Rating model for different review sources
struct Rating: Codable {
    let source: String
    let value: String
    
    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}

// MARK: - Enhanced Movie Model

// Enhanced movie model with computed properties and convenience methods
struct Movie: Identifiable, Codable {
    let id: String // Using imdbID as the identifier
    let title: String
    let year: String
    let rated: String
    let released: Date?
    let runtime: Int? // in minutes
    let genres: [String]
    let directors: [String]
    let writers: [String]
    let actors: [String]
    let plot: String
    let language: String
    let country: String
    let awards: String
    let posterURL: URL?
    let ratings: [Rating]
    let metascore: Int?
    let imdbRating: Double?
    let imdbVotes: Int?
    let type: MovieType
    let dvd: Date?
    let boxOffice: Double?
    let production: String
    let website: URL?
    let response: Bool
    
    // Computed properties
    var displayYear: String {
        return year
    }
    
    var displayRuntime: String {
        guard let runtime = runtime else { return "Unknown" }
        let hours = runtime / 60
        let minutes = runtime % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    var displayBoxOffice: String {
        guard let boxOffice = boxOffice else { return "N/A" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: boxOffice)) ?? "N/A"
    }
    
    var primaryGenre: String {
        return genres.first ?? "Unknown"
    }
    
    var isReleased: Bool {
        return released != nil
    }
    
    var hasPoster: Bool {
        return posterURL != nil
    }
    
    var averageRating: Double? {
        let validRatings = ratings.compactMap { rating -> Double? in
            if rating.source == "Internet Movie Database" {
                return Double(rating.value.replacingOccurrences(of: "/10", with: ""))
            } else if rating.source == "Rotten Tomatoes" {
                return Double(rating.value.replacingOccurrences(of: "%", with: "")) ?? 0
            } else if rating.source == "Metacritic" {
                return Double(rating.value.replacingOccurrences(of: "/100", with: ""))
            }
            return nil
        }
        
        guard !validRatings.isEmpty else { return nil }
        return validRatings.reduce(0, +) / Double(validRatings.count)
    }
    
    // Custom initializer from MovieResponse
    init(from response: MovieResponse) {
        self.id = response.imdbID
        self.title = response.title
        self.year = response.year
        self.rated = response.rated
        self.released = DateFormatter.omdbDateFormatter.date(from: response.released)
        self.runtime = Int(response.runtime.replacingOccurrences(of: " min", with: ""))
        self.genres = response.genre.components(separatedBy: ", ").map { $0.trimmingCharacters(in: .whitespaces) }
        self.directors = response.director.components(separatedBy: ", ").map { $0.trimmingCharacters(in: .whitespaces) }
        self.writers = response.writer.components(separatedBy: ", ").map { $0.trimmingCharacters(in: .whitespaces) }
        self.actors = response.actors.components(separatedBy: ", ").map { $0.trimmingCharacters(in: .whitespaces) }
        self.plot = response.plot
        self.language = response.language
        self.country = response.country
        self.awards = response.awards
        self.posterURL = URL(string: response.poster)
        self.ratings = response.ratings
        self.metascore = Int(response.metascore)
        self.imdbRating = Double(response.imdbRating)
        self.imdbVotes = Int(response.imdbVotes.replacingOccurrences(of: ",", with: ""))
        self.type = MovieType(rawValue: response.type.lowercased()) ?? .unknown
        self.dvd = DateFormatter.omdbDateFormatter.date(from: response.dvd)
        self.boxOffice = Double(response.boxOffice.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: ""))
        self.production = response.production
        self.website = URL(string: response.website)
        self.response = response.response.lowercased() == "true"
    }
}

// MARK: - Supporting Types

// Movie type enum
enum MovieType: String, CaseIterable, Codable {
    case movie = "movie"
    case series = "series"
    case episode = "episode"
    case game = "game"
    case unknown = "unknown"
    
    var displayName: String {
        switch self {
        case .movie: return "Movie"
        case .series: return "TV Series"
        case .episode: return "TV Episode"
        case .game: return "Video Game"
        case .unknown: return "Unknown"
        }
    }
}

// MARK: - Date Formatter Extension

extension DateFormatter {
    static let omdbDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
}


// MARK: - Search Models

// Search response model
struct MovieSearchResponse: Decodable {
    let search: [MovieSearchResult]
    let totalResults: String
    let response: String
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults = "totalResults"
        case response = "Response"
    }
}

// Search result model
struct MovieSearchResult: Identifiable, Decodable {
    let id: String
    let title: String
    let year: String
    let imdbID: String
    let type: MovieType
    let posterURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case type = "Type"
        case poster = "Poster"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        year = try container.decode(String.self, forKey: .year)
        imdbID = try container.decode(String.self, forKey: .imdbID)
        type = MovieType(rawValue: try container.decode(String.self, forKey: .type).lowercased()) ?? .unknown
        posterURL = URL(string: try container.decode(String.self, forKey: .poster))
        id = imdbID // Using imdbID as the identifier
    }
}

// MARK: - Error Types

enum OMDBError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case movieNotFound
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .movieNotFound:
            return "Movie not found"
        case .decodingError:
            return "Error decoding response"
        }
    }
}

// MARK: - Sample Usage

// Example of how to use the models
extension Movie {
    static let sampleMovie = Movie(from: MovieResponse(
        title: "Guardians of the Galaxy Vol. 2",
        year: "2017",
        rated: "PG-13",
        released: "05 May 2017",
        runtime: "136 min",
        genre: "Action, Adventure, Comedy",
        director: "James Gunn",
        writer: "James Gunn, Dan Abnett, Andy Lanning",
        actors: "Chris Pratt, Zoe Saldaña, Dave Bautista",
        plot: "The Guardians struggle to keep together as a team while dealing with their personal family issues, notably Star-Lord's encounter with his father, the ambitious celestial being Ego.",
        language: "English",
        country: "United States",
        awards: "Nominated for 1 Oscar. 15 wins & 60 nominations total",
        poster: "https://m.media-amazon.com/images/M/MV5BNWE5MGI3MDctMmU5Ni00YzI2LWEzMTQtZGIyZDA5MzQzNDBhXkEyXkFqcGc@._V1_SX300.jpg",
        ratings: [
            Rating(source: "Internet Movie Database", value: "7.6/10"),
            Rating(source: "Rotten Tomatoes", value: "85%"),
            Rating(source: "Metacritic", value: "67/100")
        ],
        metascore: "67",
        imdbRating: "7.6",
        imdbVotes: "802,014",
        imdbID: "tt3896198",
        type: "movie",
        dvd: "N/A",
        boxOffice: "$389,813,101",
        production: "N/A",
        website: "N/A",
        response: "True"
    ))
}

