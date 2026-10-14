//
//  WatchlistView.swift
//  AcademyStocks
//
//  Created by Stevanus Felixiano on 04/04/26.
//

import SwiftUI

struct WatchlistView: View {

    @State private var newsSheetPresented = true
    @State private var searchText: String = ""
    @State private var isSearching = false
    @State private var showDeleteAlert = false
    @State private var showShareSheet = false
    @State private var editMode: EditMode = .inactive
    @State private var sortOption: SortOption = .manual
    @State private var showOption: ShowOption = .priceChange

    var body: some View {

        NavigationStack {
            List {

                WatchlistMenu(watchlists: [
                    Watchlist(name: "My Symbols"),
                    Watchlist(name: "Tech"),
                    Watchlist(name: "Crypto")
                ],
                selectedWatchlist: Watchlist(name: "My Symbols"))
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())

                Section {
                    ForEach(1..<5) { _ in
                        StockListItem(stock: Stock(
                            name: "PT Astra International Tbk",
                            symbol: "ASII.JK",
                            price: 6075.12,
                            change: +175,
                            sparklineData: [
                                6100, 6050, 6000, 6050, 6000, 6050,
                                6100, 6050, 6100, 6150, 6200, 6150,
                                6150, 6150, 6100, 6150, 6100, 6100
                            ]
                        ))
                            .listRowInsets(
                                EdgeInsets(
                                    top: 12,
                                    leading: 16,
                                    bottom: 12,
                                    trailing: 16
                                )
                            )
                            .listRowBackground(Color.clear)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    showDeleteAlert = true
                                } label: {
                                    Label("Remove", systemImage: "trash")
                                }
                            }
                            .swipeActions(edge: .trailing) {
                                Button {
                                    showShareSheet = true
                                } label: {
                                    Label(
                                        "Share",
                                        systemImage: "square.and.arrow.up"
                                    )
                                }
                                .tint(.orange)
                            }
                            .swipeActions(edge: .trailing) {
                                Button {
//                                    showShareSheet = true
                                } label: {
                                    Label(
                                        "Lists",
                                        systemImage: "list.bullet"
                                    )
                                }
                                .tint(.blue)
                            }
                            .contextMenu {
                                Button(
                                    "Share Symbol",
                                    systemImage: "square.and.arrow.up"
                                ) {}
                                Button("Copy Link", systemImage: "link") {}
                                Button(
                                    "Remove from Watchlist",
                                    systemImage: "trash",
                                    role: .destructive
                                ) {}
                            } preview: {

                                HStack {
                                    Text("ASII.JK")
                                }
                                .frame(width: 400)
                            }
                    }
                    .onDelete { _ in }
                    .onMove { _, _ in }
                }

            }
            .listStyle(.plain)
            .environment(\.editMode, $editMode)
            .toolbar {

                TitleToolbar(
                    editMode: $editMode,
                    sortOption: $sortOption,
                    showOption: $showOption
                )
            }
        }
        .alert("Remove Stock", isPresented: $showDeleteAlert) {
            Button("Remove", role: .destructive) {
                // Handle removal
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(
                "Are you sure you want to remove this stock from your watchlist?"
            )
        }
        .sheet(isPresented: $showShareSheet) {
            let items: [Any] = ["Check out this stock!"]
            ActivityViewController(activityItems: items)
                .presentationDetents([.medium])
        }

    }
}

struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
    }

    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: Context
    ) {}
}

#Preview {
    WatchlistView()
        .preferredColorScheme(ColorScheme.dark)
}
