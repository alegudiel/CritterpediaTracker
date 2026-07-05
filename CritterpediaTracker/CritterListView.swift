import SwiftUI

struct CritterListView: View {
    @StateObject var viewModel: CritterListViewModel
    @EnvironmentObject var store: CaughtStore
    @State private var selectedCritter: Critter?

    private let columns = [GridItem(.adaptive(minimum: 100), spacing: 12)]

    var body: some View {
        grid
            .navigationTitle(viewModel.type.title)
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.searchText, prompt: "Search by name")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Filter", selection: $viewModel.filter) {
                            ForEach(CritterFilter.allCases) { filter in
                                Label(filter.rawValue, systemImage: filter.systemImage)
                                    .tag(filter)
                            }
                        }
                    } label: {
                        Image(systemName: viewModel.filter == .all
                              ? "line.3.horizontal.decrease.circle"
                              : "line.3.horizontal.decrease.circle.fill")
                    }
                }
            }
            .sheet(item: $selectedCritter) { critter in
                CritterDetailCard(critter: critter, type: viewModel.type)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .background(viewModel.type.backgroundTint.ignoresSafeArea())
    }

    private var grid: some View {
        ScrollView {
            let filtered = viewModel.filteredCritters(store: store)
            if filtered.isEmpty {
                ContentUnavailableView(
                    "Nothing here",
                    systemImage: "magnifyingglass",
                    description: Text("Try a different filter or search term.")
                )
                .padding(.top, 80)
            } else {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(filtered) { critter in
                        CritterCellView(
                            critter: critter,
                            type: viewModel.type,
                            isCaught: store.isCaught(critter, type: viewModel.type)
                        )
                        .onTapGesture { selectedCritter = critter }
                        .onLongPressGesture {
                            withAnimation(.snappy) {
                                store.toggle(critter, type: viewModel.type)
                            }
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct CritterCellView: View {
    let critter: Critter
    let type: CritterType
    let isCaught: Bool

    var body: some View {
        VStack(spacing: 6) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: critter.imageURL)) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFit()
                    case .failure:
                        Image(systemName: "questionmark.circle")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                    default:
                        ProgressView()
                    }
                }
                .frame(height: 64)
                .opacity(isCaught ? 0.45 : 1)

                if isCaught {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.white, type.themeColor)
                        .font(.title3)
                        .offset(x: 6, y: -6)
                }
            }

            Text(critter.displayName)
                .font(.caption.weight(.medium))
                .strikethrough(isCaught, color: .secondary)
                .foregroundStyle(isCaught ? .secondary : .primary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(height: 32)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(
            Color(.secondarySystemGroupedBackground),
            in: RoundedRectangle(cornerRadius: 16)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(isCaught ? type.themeColor.opacity(0.5) : .clear, lineWidth: 1.5)
        )
    }
}
