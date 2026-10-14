//
//  DiscoveyViewModel.swift
//  AcademyStocks
//
//  Created by Stevanus Felixiano on 23/04/26.
//

import SwiftUI
import Combine

@MainActor
final class DiscoveryViewModel: ObservableObject {
    
    enum Market: String, CaseIterable {
        case ihsg = "IHSG"
        case nasdaq = "NASDAQ"
        case sp500 = "S&P 500"
        
        var symbol: String {
            switch self {
            case .ihsg: return "^JKSE"
            case .nasdaq: return "^IXIC"
            case .sp500: return "^GSPC"
            }
        }
    }
    
    // UPGRADE TAB
    enum Tab: String, CaseIterable {
        case gainers = "Top Gainers"
        case losers = "Top Losers"
        case value = "Top Value"
        case volume = "Top Volume"
        case frequency = "Top Frequency"
        case foreignBuy = "Net Foreign Buy"
        case foreignSell = "Net Foreign Sell"
    }
    
    @Published var selectedMarket: Market = .ihsg
    @Published var selectedTab: Tab = .gainers
    
    @Published var chartData: [Double] = []
    
    // ALL DATA
    @Published var gainers: [Stock] = []
    @Published var losers: [Stock] = []
    @Published var topValue: [Stock] = []
    @Published var topVolume: [Stock] = []
    @Published var topFrequency: [Stock] = []
    @Published var foreignBuy: [Stock] = []
    @Published var foreignSell: [Stock] = []
    
    @Published var hasLoaded = false
    
    private let api = YahooAPI()
    
    // MARK: - LOAD
    func load() async {
        await fetchChart()
        loadDummyMovers()
        
        // preload biar smooth
        Task.detached { [api] in
            _ = await api.fetchChart(symbol: "^IXIC")
            _ = await api.fetchChart(symbol: "^GSPC")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.hasLoaded = true
        }
    }
    
    // MARK: - SELECT MARKET
    func selectMarket(_ market: Market) async {
        guard selectedMarket != market else { return }
        
        selectedMarket = market
        
        let data = await api.fetchChart(symbol: market.symbol)
        chartData = data
    }
    
    private func fetchChart() async {
        chartData = await api.fetchChart(symbol: selectedMarket.symbol)
    }
    
    // MARK: CURRENT DATA
    var currentData: [Stock] {
        switch selectedTab {
        case .gainers: return gainers
        case .losers: return losers
        case .value: return topValue
        case .volume: return topVolume
        case .frequency: return topFrequency
        case .foreignBuy: return foreignBuy
        case .foreignSell: return foreignSell
        }
    }
    
    // MARK: DUMMY DATA
    private func loadDummyMovers() {
        
        let sampleUp = [
            Stock(name: "Bank Central Asia", symbol: "BBCA", price: 9200, change: 150, sparklineData: []),
            Stock(name: "Telkom Indonesia", symbol: "TLKM", price: 4100, change: 120, sparklineData: []),
            Stock(name: "Bank Rakyat Indonesia", symbol: "BBRI", price: 5600, change: 90, sparklineData: []),
            Stock(name: "Astra International", symbol: "ASII", price: 6000, change: 80, sparklineData: []),
            Stock(name: "Bank Mandiri", symbol: "BMRI", price: 7000, change: 70, sparklineData: [])
        ]
        
        let sampleDown = [
            Stock(name: "GoTo Gojek Tokopedia", symbol: "GOTO", price: 120, change: -8, sparklineData: []),
            Stock(name: "Bukalapak", symbol: "BUKA", price: 150, change: -6, sparklineData: []),
            Stock(name: "Indofood", symbol: "INDF", price: 6300, change: -100, sparklineData: []),
            Stock(name: "Unilever Indonesia", symbol: "UNVR", price: 3800, change: -90, sparklineData: []),
            Stock(name: "Adaro Energy", symbol: "ADRO", price: 2700, change: -70, sparklineData: [])
        ]
        
        gainers = sampleUp
        losers = sampleDown
        
        // reuse dulu (nanti tinggal ganti API)
        topValue = sampleUp
        topVolume = sampleUp
        topFrequency = sampleUp
        foreignBuy = sampleUp
        foreignSell = sampleDown
    }
    
    // MARK: STATS
    var change: Double {
        guard let first = chartData.first,
              let last = chartData.last else { return 0 }
        return last - first
    }
    
    var percent: Double {
        guard let first = chartData.first,
              let last = chartData.last else { return 0 }
        return ((last - first) / first) * 100
    }
}
