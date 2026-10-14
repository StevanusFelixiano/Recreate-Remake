//
//  Stock.swift
//  AcademyStocks
//
//  Created by Stevanus Felixiano on 19/04/26.
//
import Foundation

struct Stock: Identifiable {
    let id = UUID()
    let name: String
    let symbol: String
    let price: Double
    let change: Double
    let sparklineData: [Double]
}

struct StockDetailModel: Identifiable {
    let id: UUID = UUID()
    let ticketSymbol: String
    let companyName: String
    let currentPrice: Double
    let previousClose: Double
    let change: Double
    let changePercent: Double
    let openValue: Double
    let highValue: Double
    let lowValue: Double
    let marketCap: Double
    let volume: Int
    let peRatio: Double
    let weekHigh52: Double
    let weekLow52: Double
    let averageDailyVolume: Int
}
