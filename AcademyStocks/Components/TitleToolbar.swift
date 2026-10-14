//
//  TitleToolbar.swift
//  AcademyStocks
//
//  Created by benchandra on 12/04/26.

import SwiftUI

enum SortOption: String, CaseIterable {
    case manual = "Manual"
    case priceChange = "Price Change"
    case percentageChange = "Percentage Change"
    case marketCap = "Market Cap"
    case symbol = "Symbol"
    case name = "Name"
}

enum ShowOption: String, CaseIterable {
    case priceChange = "Price Change"
    case percentageChange = "Percentage Change"
    case marketCap = "Market Cap"
    case currency = "Currency"
}

struct TitleToolbar: ToolbarContent {
    @Binding var editMode: EditMode
    
    @Binding var sortOption: SortOption
    @Binding var showOption: ShowOption
    
    var body: some ToolbarContent {
        
        ToolbarItem(placement: .topBarLeading) {
            VStack(alignment: .leading) {
                Text("Academy Stocks")
                    .font(.title2.bold())
                
                Text(Date.now, format: .dateTime.day().month(.wide))
                    .font(.title2.bold())
                    .foregroundStyle(.secondary)
            }
            .fixedSize()
        }
        .sharedBackgroundVisibility(.hidden)
        
        ToolbarItemGroup(placement: .topBarTrailing) {
            
            if editMode == .active {
                Button {
                    withAnimation {
                        editMode = .inactive
                    }
                } label: {
                    Image(systemName: "checkmark")
                        .font(.body.bold())
                }
                
            } else {
                
                Menu("More", systemImage: "ellipsis") {
                    
                    Button("Edit Watchlist", systemImage: "pencil") {
                        withAnimation {
                            editMode = .active
                        }
                    }
                    
                    Button("New Watchlist", systemImage: "plus") {}
                    
                    Divider()
                    
                    Menu {
                        Picker("Sort Watchlist", selection: $sortOption) {
                            ForEach(SortOption.allCases, id: \.self) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                    } label: {
                        Label {
                            Text("Sort Watchlist By")
                            Text(sortOption.rawValue)
                        } icon: {
                            Image(systemName: "arrow.up.arrow.down")
                        }
                    }
                    
                    Menu {
                        Picker("Watchlist Shows", selection: $showOption) {
                            ForEach(ShowOption.allCases, id: \.self) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                    } label: {
                        Label {
                            Text("Watchlist Shows")
                            Text(showOption.rawValue)
                        } icon: {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                        }
                    }
                    
                    Divider()
                    
                    Button(
                        "Provide Stocks Feedback",
                        systemImage: "exclamationmark.bubble"
                    ) {}
                    
                    Button("Clear Recommendations Data") {}
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        Text("Preview Content")
            .toolbar {
                TitleToolbar(
                    editMode: .constant(.inactive),
                    sortOption: .constant(.manual),
                    showOption: .constant(.priceChange)
                )
            }
    }
}
