//
//  StockChartViewModel.swift
//  AcademyStocks
//
//  Created by Stevanus Felixiano on 22/04/26.
//
import SwiftUI
import Foundation
import XCAStocksAPI

@Observable
class StockChartViewModel {
    
    private let stocksApi: XCAStocksAPI
    let ticker: String
    
    var prices: [SheetChartPoint] = []
    private var selectedRange: ChartTimeRange = .oneDay
    
    init(stocksApi: XCAStocksAPI, ticker: String) {
        self.stocksApi = stocksApi
        self.ticker = ticker
    }
    
    func fetchStockPriceData() async {
        do {
            guard let stockPriceData = try await stocksApi.fetchChartData(
                tickerSymbol: ticker,
                range: selectedRange.apiRange
            ) else {
                return
            }
            
            prices = stockPriceData.indicators.map {
                SheetChartPoint(
                    timestamp: $0.timestamp,
                    priceValue: $0.close,
                    volume: 0
                )
            }
        } catch {
            print("error bang. Stock yang kau panggil: \(ticker). Nih error nya: \(error)")
        }
    }
    
    func changeRange(_ newRange: ChartTimeRange) async {
        selectedRange = newRange
        
        do {
            guard let stockPriceData = try await stocksApi.fetchChartData(
                tickerSymbol: ticker,
                range: newRange.apiRange
            ) else { return }
            
            let newPrices = stockPriceData.indicators.map {
                SheetChartPoint(
                    timestamp: $0.timestamp,
                    priceValue: $0.close,
                    volume: 0
                )
            }
            
            withAnimation(.easeInOut(duration: 0.3)) {
                prices = newPrices
            }
            
        } catch {
            print("error bang: \(error)")
        }
    }
}
