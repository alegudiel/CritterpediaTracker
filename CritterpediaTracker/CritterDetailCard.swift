import SwiftUI

struct CritterDetailCard: View {
    let critter: Critter
    let type: CritterType
    @EnvironmentObject var store: CaughtStore

    private let monthLabels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                               "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

    private var isCaught: Bool { store.isCaught(critter, type: type) }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                header

                infoRow(icon: "clock.fill", title: "Time (North)", value: critter.timeNorth)
                infoRow(icon: "mappin.and.ellipse", title: "Location", value: critter.location)
                if critter.sellNook > 0 {
                    infoRow(icon: "b.circle.fill", title: "Sell price",
                            value: "\(critter.sellNook.formatted()) Bells")
                }

                monthsSection

                if critter.isAvailableNow {
                    Label("Available right now!", systemImage: "sparkles")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(type.themeColor)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(type.backgroundTint, in: Capsule())
                }

                catchButton
            }
            .padding(24)
        }
        .background(Color(.systemGroupedBackground))
    }

    // MARK: - Sections

    private var header: some View {
        VStack(spacing: 8) {
            AsyncImage(url: URL(string: critter.renderURL ?? critter.imageURL)) { phase in
                if case .success(let image) = phase {
                    image.resizable().scaledToFit()
                } else {
                    ProgressView()
                }
            }
            .frame(height: 130)
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(type.backgroundTint, in: RoundedRectangle(cornerRadius: 24))

            Text(critter.displayName)
                .font(.title2.weight(.bold))
            Text("#\(critter.number) · \(type.title)")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }

    private func infoRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(type.themeColor)
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.body.weight(.medium))
            }
            Spacer()
        }
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14))
    }

    private var monthsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Months (Northern Hemisphere)")
                .font(.caption)
                .foregroundStyle(.secondary)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 6),
                      spacing: 8) {
                ForEach(1...12, id: \.self) { month in
                    let active = critter.monthsNorth.contains(month)
                    Text(monthLabels[month - 1])
                        .font(.caption.weight(active ? .semibold : .regular))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            active ? type.themeColor : Color(.tertiarySystemGroupedBackground),
                            in: RoundedRectangle(cornerRadius: 8)
                        )
                        .foregroundStyle(active ? .white : .secondary)
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14))
    }

    private var catchButton: some View {
        Button {
            withAnimation(.snappy) {
                store.toggle(critter, type: type)
            }
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        } label: {
            Label(
                isCaught ? "Caught! Tap to unmark" : "Mark as caught",
                systemImage: isCaught ? "checkmark.circle.fill" : "circle"
            )
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
        }
        .buttonStyle(.borderedProminent)
        .tint(isCaught ? .green : type.themeColor)
    }
}
