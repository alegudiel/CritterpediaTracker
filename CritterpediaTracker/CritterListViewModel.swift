import Foundation
import Combine

enum CritterFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case caught = "Caught"
    case missing = "Missing"
    case availableNow = "Available now"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .all: return "square.grid.3x3"
        case .caught: return "checkmark.circle"
        case .missing: return "circle.dashed"
        case .availableNow: return "clock"
        }
    }
}

@MainActor
final class CritterListViewModel: ObservableObject {
    @Published private(set) var critters: [Critter] = []
    @Published var filter: CritterFilter = .all
    @Published var searchText: String = ""

    let type: CritterType

    init(type: CritterType) {
        self.type = type
        self.critters = CritterDataStore.load(type)
    }

    func filteredCritters(store: CaughtStore) -> [Critter] {
        var result = critters

        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }

        switch filter {
        case .all:
            break
        case .caught:
            result = result.filter { store.isCaught($0, type: type) }
        case .missing:
            result = result.filter { !store.isCaught($0, type: type) }
        case .availableNow:
            result = result.filter { $0.isAvailableNow }
        }
        return result
    }
}
