import SwiftUI

// MARK: - Critter Type

enum CritterType: String, CaseIterable, Identifiable {
    case fish
    case bug
    case seaCreature

    var id: String { rawValue }

    var title: String {
        switch self {
        case .fish: return "Fish"
        case .bug: return "Bugs"
        case .seaCreature: return "Sea Creatures"
        }
    }

    /// Bundled JSON file name (without extension)
    var dataFile: String {
        switch self {
        case .fish: return "fish"
        case .bug: return "bugs"
        case .seaCreature: return "seaCreatures"
        }
    }

    var systemImage: String {
        switch self {
        case .fish: return "fish.fill"
        case .bug: return "ant.fill"
        case .seaCreature: return "water.waves"
        }
    }

    /// Critterpedia-inspired theme color per category
    var themeColor: Color {
        switch self {
        case .fish: return Color(red: 0.29, green: 0.56, blue: 0.89)        // blue
        case .bug: return Color(red: 0.45, green: 0.72, blue: 0.30)         // green
        case .seaCreature: return Color(red: 0.20, green: 0.68, blue: 0.71) // teal
        }
    }

    var backgroundTint: Color { themeColor.opacity(0.12) }
}

// MARK: - Critter

struct Critter: Identifiable, Codable, Hashable {
    let number: Int
    let name: String
    let imageURL: String
    let renderURL: String?
    let location: String
    let sellNook: Int
    /// Northern hemisphere months (1 = Jan ... 12 = Dec)
    let monthsNorth: [Int]
    /// Human-readable time, e.g. "9 AM – 4 PM" or "All day"
    let timeNorth: String
    /// Exact active hours (0–23), Northern Hemisphere
    let hoursNorth: [Int]

    var id: Int { number }

    var displayName: String { name.capitalized }

    /// True if available during the current month + hour (Northern Hemisphere)
    var isAvailableNow: Bool {
        let now = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: now)
        guard monthsNorth.contains(month) else { return false }
        let hour = calendar.component(.hour, from: now)
        return hoursNorth.contains(hour)
    }
}

// MARK: - Bundled data loader

enum CritterDataStore {
    /// Loads the bundled JSON catalog for a critter type. Fully offline.
    static func load(_ type: CritterType) -> [Critter] {
        // Try bundle root first (yellow group), then Data/ subdirectory (blue folder reference)
        let url = Bundle.main.url(forResource: type.dataFile, withExtension: "json")
            ?? Bundle.main.url(forResource: type.dataFile, withExtension: "json", subdirectory: "Data")

        guard let url,
              let data = try? Data(contentsOf: url),
              let critters = try? JSONDecoder().decode([Critter].self, from: data) else {
            assertionFailure("Missing or invalid bundled data: \(type.dataFile).json")
            return []
        }
        return critters.sorted { $0.number < $1.number }
    }
}
