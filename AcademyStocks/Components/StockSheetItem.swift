//
//  StockSheetView.swift
//  AcademyStocks
//
//  Created by Stevanus Felixiano on 22/04/26.
//

import SwiftUI
import XCAStocksAPI

struct StockSheetItem: View {
    
    let tickerSymbol: String
    
    @State private var viewModel: StockChartViewModel
    @State private var selectedRange: ChartTimeRange = .oneDay
    @Environment(\.dismiss) private var dismiss
    
    init(tickerSymbol: String) {
        self.tickerSymbol = tickerSymbol
        _viewModel = State(initialValue: StockChartViewModel(
            stocksApi: XCAStocksAPI(),
            ticker: tickerSymbol
        ))
    }
    
    var sampleStocks: [Stock] {
        [
            Stock(
                name: "Starbucks",
                symbol: "SBUX",
                price: 98.95,
                change: -1.05,
                sparklineData: [105, 102, 100, 98, 96, 95, 97, 99, 101, 100]
            ),
            Stock(
                name: "Apple",
                symbol: "AAPL",
                price: 189.12,
                change: 2.31,
                sparklineData: [180, 182, 185, 183, 187, 190, 188, 192, 195, 193, 197, 200]
            ),
            Stock(
                name: "Tesla",
                symbol: "TSLA",
                price: 245.33,
                change: -3.22,
                sparklineData: [270, 265, 260, 255, 250, 248, 246, 244, 242, 240, 238]
            ),
            Stock(
                name: "Microsoft",
                symbol: "MSFT",
                price: 410.45,
                change: 1.12,
                sparklineData: [400, 405, 402, 408, 412, 409, 415, 418, 420, 417]
            ),
            Stock(
                name: "Amazon",
                symbol: "AMZN",
                price: 175.22,
                change: -0.88,
                sparklineData: [180, 178, 175, 172, 174, 173, 170, 168, 169, 167]
            ),
            Stock(
                name: "Google",
                symbol: "GOOGL",
                price: 140.67,
                change: 0.45,
                sparklineData: [135, 137, 136, 138, 140, 139, 142, 141, 143, 145]
            ),
            Stock(
                name: "Dow Jones",
                symbol: "Dow Jones",
                price: 49490.67,
                change: 0.45,
                sparklineData: [49000, 49100, 48950, 49200, 49350, 49150, 49400, 49500, 49300, 49600]
            )
        ]
    }
    
    var newsList: [News] {
        [
            News(
                source: "Yahoo Finance",
                title: "Mag 7 earnings bonanza and Powell's home stretch: What to watch this week",
                subtitle: "Jerome Powell’s penultimate meeting as Federal Reserve chair and a slate of earnings reports highlight a busy week ahead for investors.",
                time: "14m ago"
            ),
            News(
                source: "Motley Fool",
                title: "The Stock Market Just Did Something It Hasn't Done Since 1999",
                subtitle: "Markets are entering rare territory as investors weigh inflation, rate cuts, and a tech-heavy rally not seen in decades.",
                time: "30m ago"
            ),
            News(
                source: "Motley Fool",
                title: "Forget Tariffs! This Is the Single Greatest Threat to the Stock Market",
                subtitle: "Experts warn that rising interest rates and global instability could pose a larger risk than trade tensions.",
                time: "47m ago"
            ),
            News(
                source: "Bloomberg",
                title: "Stocks Slip as Traders Await Fed Signals on Rate Cuts",
                subtitle: "Investors remain cautious ahead of key economic data and central bank decisions later this week.",
                time: "1h ago"
            ),
            News(
                source: "CNBC",
                title: "Tech Stocks Rally Again as AI Boom Continues",
                subtitle: "Big Tech companies are seeing renewed investor interest as AI-related revenues continue to grow.",
                time: "2h ago"
            ),
            News(
                source: "Reuters",
                title: "Global Markets Mixed Amid Economic Uncertainty",
                subtitle: "Asian markets fall while European stocks remain steady as investors digest economic indicators.",
                time: "3h ago"
            )
        ]
    }
    
    var body: some View {
        VStack(spacing: 0) {
            MovingTicker(
                stocks: sampleStocks
            ) { _ in
                dismiss()
            }
            .background(Color.black)
            
            ScrollView {
                topBar
                header
                rangePicker
                Divider().opacity(1)
                ChartSheetItem(prices: viewModel.prices, range: selectedRange)
                Divider().opacity(0.2)
                StockStatsItem(stockDetail: mockDetail)
                Text("More Data from Yahoo Finance")
                    .font(.subheadline)
                    .foregroundStyle(.blue)
                    .padding(.top, 8)
                    .padding(.bottom, 12)
                    .padding(.leading, -160)
                VStack(alignment: .leading, spacing: 16) {
                    
                    ForEach(newsList) { news in
                        VStack(alignment: .leading, spacing: 6) {
                            
                            Text(news.source)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            Text(news.title)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            
                            Text(news.subtitle)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                            
                            Text(news.time)
                                .font(.caption2)
                                .foregroundStyle(.secondary.opacity(0.7))
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(.ultraThinMaterial)
            )
            .overlay(alignment: .top) {
                grabber
            }
            footer
        }
        .task {
            await viewModel.fetchStockPriceData()
        }
    }
}

extension StockSheetItem {
    var topBar: some View {
        HStack {
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 20, weight: .semibold))
                    .frame(width: 50, height: 40)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
            .foregroundStyle(.primary)
            
            Spacer()
            
            HStack(spacing: 0) {
                
                ShareLink(
                    item: URL(string: "https://finance.yahoo.com/quote/\(tickerSymbol)")!
                ) {
                    Image(systemName: "square.and.arrow.up")
                        .frame(width: 50, height: 40)
                        .font(.system(size: 20, weight: .semibold))
                }
                .foregroundStyle(.primary)
                
                Menu {
                    Button {
                        UIPasteboard.general.string =
                        "https://finance.yahoo.com/quote/\(tickerSymbol)"
                    } label: {
                        Label("Copy Link", systemImage: "link")
                    }
                    
                    Button("Add to Watchlist", systemImage: "plus") {
                        // logic nanti
                    }
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 24, weight: .semibold))
                        .frame(width: 50, height: 40)
                }
                .foregroundStyle(.primary)
            }
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
        }
    }
}

// MARK: - HEADER
extension StockSheetItem {
    
    var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(tickerSymbol)
                    .font(.system(size: 34, weight: .bold))
                
                Text(mockDetail.companyName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Divider()
            HStack(spacing: 8) {
                Text(formatPrice(mockDetail.currentPrice))
                    .font(.title2.bold())
                
                Text(formatChange(mockDetail.change))
                    .foregroundStyle(mockDetail.change >= 0 ? .green : .red)
                
                Text("(\(formatPercent(mockDetail.changePercent)))")
                    .foregroundStyle(mockDetail.change >= 0 ? .green : .red)
            }
            
            Text("At Close")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.secondary)
            
            Text("Jakarta • IDR")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.secondary)
            Divider()
        }
    }
    
    var grabber: some View {
        Capsule()
            .fill(Color.secondary.opacity(0.4))
            .frame(width: 40, height: 5)
            .padding(.top, 6)
    }
}

// MARK: - RANGE PICKER
extension StockSheetItem {
    var rangePicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            
            HStack(spacing: 16) {
                
                ForEach(ChartTimeRange.allCases, id: \.self) { range in
                    
                    let isSelected = selectedRange == range
                    
                    Text(range.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(isSelected ? .white : .secondary)
                        .lineLimit(1)
                        .fixedSize()
                        .padding(.horizontal, 6)
                        .padding(.vertical, 6)
                        .background {
                            if isSelected {
                                Capsule()
                                    .fill(Color.white.opacity(0.15))
                            }
                        }
                        .contentShape(Capsule())
                        .onTapGesture {
                            selectedRange = range
                            
                            Task {
                                await viewModel.changeRange(range)
                            }
                        }
                }
            }
        }
    }
}

// MARK: - FOOTER
extension StockSheetItem {
    
    var footer: some View {
        HStack(alignment: .center) {
            Text("yahoo!finance")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.secondary.opacity(0.8))
            
            Spacer()
            
            Text("Market Closed")
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
        }
        .padding(.top, 12)
        .padding(.horizontal, 12)
        .background(.ultraThinMaterial)
    }
}

// MARK: - FORMAT
extension StockSheetItem {
    
    func formatPrice(_ value: Double) -> String {
        value.formatted(.number.precision(.fractionLength(2)))
    }
    
    func formatChange(_ value: Double) -> String {
        let sign = value >= 0 ? "+" : ""
        return "\(sign)\(value.formatted(.number.precision(.fractionLength(2))))"
    }
    
    func formatPercent(_ value: Double) -> String {
        let sign = value >= 0 ? "+" : ""
        return "\(sign)\(value.formatted(.number.precision(.fractionLength(2))))%"
    }
}

// MARK: - MOCK DATA
extension StockSheetItem {
    
    var mockDetail: StockDetailModel {
        StockDetailModel(
            ticketSymbol: tickerSymbol,
            companyName: "PT Astra International Tbk",
            currentPrice: 85.20,
            previousClose: 84.78,
            change: 0.71,
            changePercent: 0.83,
            openValue: 85.88,
            highValue: 87.19,
            lowValue: 85.57,
            marketCap: 98.35,
            volume: 4644,
            peRatio: 37.46,
            weekHigh52: 117.46,
            weekLow52: 75.50,
            averageDailyVolume: 9468
        )
    }
}

#Preview {
    StockSheetItem(tickerSymbol: "ASII.JK")
        .preferredColorScheme(.dark)
}
