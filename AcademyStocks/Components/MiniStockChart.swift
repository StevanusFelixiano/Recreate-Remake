//
//  MiniStockChart.swift
//  AcademyStocks
//
//  Created by benchandra on 05/04/26.
//

import SwiftUI
import Charts

struct MiniStockChart: View {
    let stock: Stock
    var body: some View {
        Chart(stock.sparklineData.enumerated(), id: \.offset) { index, price in
            AreaMark(
                x: .value("Time", index),
                yStart: .value("Price", min(price, baseline)),
                yEnd: .value("Price End", price)
            )
            .foregroundStyle(
                LinearGradient(
                    stops: [
                        .init(color: .green.opacity(0.4), location: 0.0),
                        .init(color: .green.opacity(0.3), location: 0.2),
                        .init(color: .green.opacity(0.1), location: 0.4),
                        .init(color: .green.opacity(0.0), location: 1.0),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            
            LineMark(
                x: .value("Time", index),
                y: .value("Price", price)
            )
            .foregroundStyle(.green)
            
            RuleMark(
                y: .value("Threshold", baseline)
            )
            .foregroundStyle(.green.opacity(0.5))
            .lineStyle(StrokeStyle(lineWidth: 1, dash: [2, 2]))
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartYScale(domain: yDomain)
        .frame(width: 60, height: 40)
    }
    
    private var baseline: Double {
        stock.sparklineData.first ?? 0
    }
    
    private var yDomain: ClosedRange<Double> {
        let minVal = stock.sparklineData.min() ?? 0
        let maxVal = stock.sparklineData.max() ?? 1
        return minVal...maxVal
    }
}

#Preview {
    MiniStockChart(
        stock: Stock(
            name: "Apple",
            symbol: "AAPL",
            price: 180,
            change: 1.2,
            sparklineData: [
                6100, 6050, 6000, 6050, 6000, 6050,
                6100, 6050, 6100, 6150, 6200, 6150,
                6150, 6150, 6100, 6150, 6100, 6100
            ]
        )
    )
}
