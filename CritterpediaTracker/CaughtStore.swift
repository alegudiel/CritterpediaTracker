import Foundation
import Combine

/// Tracks which critters have been caught. Persisted on-device via UserDefaults.
final class CaughtStore: ObservableObject {
    @Published private(set) var caughtIDs: Set<String> = []

    private let storageKey = "caughtCritterIDs"

    init() {
        if let saved = UserDefaults.standard.array(forKey: storageKey) as? [String] {
            caughtIDs = Set(saved)
        }
    }

    private func key(for type: CritterType, number: Int) -> String {
        "\(type.rawValue)-\(number)"
    }

    func isCaught(_ critter: Critter, type: CritterType) -> Bool {
        caughtIDs.contains(key(for: type, number: critter.number))
    }

    func toggle(_ critter: Critter, type: CritterType) {
        let k = key(for: type, number: critter.number)
        if caughtIDs.contains(k) {
            caughtIDs.remove(k)
        } else {
            caughtIDs.insert(k)
        }
        persist()
    }

    func caughtCount(for type: CritterType) -> Int {
        caughtIDs.filter { $0.hasPrefix("\(type.rawValue)-") }.count
    }

    private func persist() {
        UserDefaults.standard.set(Array(caughtIDs), forKey: storageKey)
    }
}
