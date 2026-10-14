//
//  SheetChartPoint.swift
//  AcademyStocks
//
//  Created by Stevanus Felixiano on 22/04/26.
//
import Foundation

struct SheetChartPoint: Identifiable{
    let id = UUID()
    let timestamp: Date
    let priceValue: Double
    let volume: Double
}
