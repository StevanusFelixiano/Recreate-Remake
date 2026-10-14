//
//  TabBarView.swift
//  AcademyStocks
//
//  Created by Stevanus Felixiano on 20/04/26.
//

import SwiftUI

enum TabItem {
    case watchlist
    case discovery
    case news
    case search
}

struct TabBarView: View {
    
    @State private var searchText = ""
    @FocusState private var isFocused: Bool
    @State private var selectedTab: TabItem = .watchlist
    
    var body: some View {
        TabView(selection: $selectedTab) {

            Tab("Watchlist", systemImage: "list.bullet", value: .watchlist) {
                WatchlistView()
            }

            Tab("Discovery", systemImage: "globe", value: .discovery) {
                DiscoveryView()
            }

            Tab("News", systemImage: "newspaper", value: .news) {
                NewsView()
            }

            Tab(value: .search, role: .search) {
                ZStack {

                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            
                            Text("Search")
                                .font(.title.bold())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 16)
                        }
                        .padding(.top)
                    }
                    
                    VStack {
                        Spacer()
                        
                        HStack(spacing: 12) {
                            Button {
                                selectedTab = .watchlist
                            } label: {
                                Image(systemName: "house")
                                    .font(.system(size: 18, weight: .semibold))
                                    .frame(width: 36, height: 36)
                                    .background(.ultraThinMaterial)
                                    .clipShape(Circle())
                                    .foregroundColor(.gray)
                            }
                            
                            HStack(spacing: 8) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                
                                TextField("Stocks", text: $searchText)
                                    .focused($isFocused)
                                
                                if !searchText.isEmpty {
                                    Button {
                                        searchText = ""
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding(12)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        isFocused = true
                    }
                }
                .toolbar(.hidden, for: .tabBar)
            }
        }
    }
}

#Preview {
    TabBarView()
        .preferredColorScheme(ColorScheme.dark)
}
