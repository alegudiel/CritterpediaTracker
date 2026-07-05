import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: CaughtStore
    @State private var selectedType: CritterType?

    private let totals: [CritterType: Int] = [.fish: 80, .bug: 80, .seaCreature: 40]

    var body: some View {
        NavigationSplitView {
            List(CritterType.allCases, selection: $selectedType) { type in
                CategoryCard(
                    type: type,
                    caught: store.caughtCount(for: type),
                    total: totals[type] ?? 0
                )
                .tag(type)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            }
            .listStyle(.plain)
            .navigationTitle("Critterpedia")
            .background(Color(.systemGroupedBackground))
        } detail: {
            if let type = selectedType {
                CritterListView(viewModel: CritterListViewModel(type: type))
                    .id(type)   // fresh view model when switching categories
            } else {
                ContentUnavailableView(
                    "Pick a category",
                    systemImage: "square.grid.3x3",
                    description: Text("Choose fish, bugs, or sea creatures to start tracking.")
                )
            }
        }
    }
}

struct CategoryCard: View {
    let type: CritterType
    let caught: Int
    let total: Int

    private var progress: Double {
        total > 0 ? Double(caught) / Double(total) : 0
    }

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: type.systemImage)
                .font(.system(size: 30))
                .foregroundStyle(type.themeColor)
                .frame(width: 56, height: 56)
                .background(type.backgroundTint, in: RoundedRectangle(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 6) {
                Text(type.title)
                    .font(.headline)
                Text("\(caught) / \(total) caught")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                ProgressView(value: progress)
                    .tint(type.themeColor)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 18))
    }
}

#Preview {
    HomeView()
        .environmentObject(CaughtStore())
}
