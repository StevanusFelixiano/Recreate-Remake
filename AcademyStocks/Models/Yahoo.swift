//
//  Yahoo.swift
//  AcademyStocks
//
//  Created by Stevanus Felixiano on 23/04/26.
//

import Foundation

struct YahooResponse: Decodable {
    let chart: ChartContainer
}

struct ChartContainer: Decodable {
    let result: [ChartResult]
}

struct ChartResult: Decodable {
    let indicators: Indicators
}

struct Indicators: Decodable {
    let quote: [Quote]
}

struct Quote: Decodable {
    let close: [Double?]
}
