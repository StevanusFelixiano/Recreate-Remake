//
//  WatchlistMenu.swift
//  AcademyStocks
//
//  Created by benchandra on 09/04/26.
//

import SwiftUI

struct WatchlistMenu: View {
    let watchlists: [Watchlist]
    let selectedWatchlist: Watchlist

    var body: some View {
        if watchlists.count > 1 {
            Menu {
                ForEach(watchlists, id: \.name) { watchlist in
                    Button(watchlist.name) {
                        // handle selection
                    }
                }

                Divider()

                Button("Manage Watchlist", systemImage: "slider.horizontal.3") {}
                Button("New Watchlist", systemImage: "plus") {}

            } label: {
                HStack(spacing: 4) {
                    Text(selectedWatchlist.name)
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.caption2.weight(.heavy))
                }
                .font(.headline.bold())
            }
            .foregroundStyle(.primary)
            .padding(.horizontal)
            .padding(.top)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview("Multiple Watchlists") {
    WatchlistMenu(
        watchlists: [
            Watchlist(name: "My Symbols"),
            Watchlist(name: "Tech"),
            Watchlist(name: "Crypto")
        ],
        selectedWatchlist: Watchlist(name: "My Symbols")
    )
}
