//
//  YahooViewModel.swift
//  AcademyStocks
//
//  Created by Stevanus Felixiano on 23/04/26.
//

import Foundation

final class YahooAPI {
    
    func fetchChart(symbol: String) async -> [Double] {
        func request(_ range: String) async -> [Double] {
            guard let url = URL(string: "https://query1.finance.yahoo.com/v8/finance/chart/\(symbol)?range=\(range)&interval=5m") else {
                return []
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoded = try JSONDecoder().decode(YahooResponse.self, from: data)
                
                return decoded.chart.result.first?
                    .indicators.quote.first?
                    .close.compactMap { $0 } ?? []
                
            } catch {
                print(error)
                return []
            }
        }
        
        let oneDay = await request("1d")
        return oneDay.isEmpty ? await request("5d") : oneDay
    }
}
