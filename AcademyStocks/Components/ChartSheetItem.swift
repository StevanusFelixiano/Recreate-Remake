//
//  ChartSheetItem.swift
//  AcademyStocks
//
//  Created by Stevanus Felixiano on 22/04/26.
//

import SwiftUI
import Charts

struct ChartSheetItem: View {
    
    let prices: [SheetChartPoint]
    let range: ChartTimeRange
    
    private var axisStride: AxisMarkValues {
        switch range {
            
        case .oneDay:
            return .automatic(desiredCount: 6)
            
        case .oneWeek:
            return .stride(by: .day) // oke
            
        case .oneMonth:
            return .stride(by: .day, count: 5) // 🔥 tiap 5 hari
            
        case .threeMonth:
            return .stride(by: .month)
            
        case .sixMonth:
            return .stride(by: .month)
            
        case .ytd, .oneYear:
            return .stride(by: .month, count: 2)
            
        case .twoYear:
            return .stride(by: .month, count: 5)
            
        case .fiveYear:
            return .stride(by: .year, count: 2)
            
        case .tenYear:
            return .stride(by: .year, count: 4)
            
        case .all:
            return .stride(by: .year, count: 7)
        }
    }
    
    private var sorted: [SheetChartPoint] {
        prices.sorted { $0.timestamp < $1.timestamp }
    }
    
    private var filtered: [SheetChartPoint] {
        sorted.filter {
            let hour = Calendar.current.component(.hour, from: $0.timestamp)
            return hour != 13 && hour != 14
        }
    }
    
    private var minY: Double {
        (filtered.map(\.priceValue).min() ?? 0) * 0.995
    }
    
    private var maxY: Double {
        (filtered.map(\.priceValue).max() ?? 1) * 1.005
    }
    
    private var isPositive: Bool {
        guard let first = filtered.first?.priceValue,
              let last = filtered.last?.priceValue else { return true }
        return last >= first
    }
    
    var body: some View {
        
        let color = isPositive ? Color.green : Color.red
        
        Chart {
            
            //AREA
            ForEach(filtered) { item in
                AreaMark(
                    x: .value("Index", item.timestamp),
                    yStart: .value("Min", minY),
                    yEnd: .value("Price", item.priceValue)
                )
            }
            .interpolationMethod(.catmullRom)
            .foregroundStyle(
                LinearGradient(
                    colors: [
                        color.opacity(0.4),
                        color.opacity(0.05)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            
            // LINE
            ForEach(filtered) { item in
                LineMark(
                    x: .value("Time", item.timestamp),
                    y: .value("Price", item.priceValue)
                )
            }
            .interpolationMethod(.catmullRom)
            .lineStyle(StrokeStyle(lineWidth: 2))
            .foregroundStyle(color)
            
            //MID LINE
            if let min = filtered.map(\.priceValue).min(),
               let max = filtered.map(\.priceValue).max() {
                
                let mid = (min + max) / 2
                
                RuleMark(y: .value("Mid", mid))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [4]))
                    .foregroundStyle(.gray.opacity(0.3))
            }
        }
        
        .chartPlotStyle { plotArea in
            plotArea
                .background(Color.clear)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.white.opacity(0.9))
                }
        }
        .chartXScale(range: .plotDimension(startPadding: 0, endPadding: 16))
        //X AXIS (TIME)
        .chartXAxis {
            
            AxisMarks(values: axisStride) { (value: AxisValue) in
                
                AxisGridLine()
                    .foregroundStyle(.gray.opacity(0.2))
                
                AxisValueLabel {
                    if let date = value.as(Date.self) {
                        
                        switch range {
                            
                        case .oneDay:
                            Text("\(Calendar.current.component(.hour, from: date))")
                            
                        case .oneWeek:
                            Text(date, format: .dateTime.weekday(.abbreviated))
                            
                        case .oneMonth:
                            Text(date, format: .dateTime.day())
                            
                        case .threeMonth, .sixMonth:
                            Text(date, format: .dateTime.month(.abbreviated))
                            
                        case .ytd, .oneYear, .twoYear:
                            Text(date, format: .dateTime.month(.abbreviated))
                            
                        case .fiveYear, .tenYear, .all:
                            Text(date, format: .dateTime.year())
                        }
                    }
                }
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.white)
            }
        }
        
        .chartYAxis {
            AxisMarks(position: .trailing, values: .automatic(desiredCount: 4)) { value in
                
                AxisGridLine()
                    .foregroundStyle(.gray.opacity(0.1))
                
                AxisValueLabel {
                    if let price = value.as(Double.self) {
                        Text(price.formatted(.number.precision(.fractionLength(0))))
                    }
                }
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.white.opacity(0.85))
            }
        }
        .chartYScale(domain: minY...maxY)
        .frame(maxWidth: .infinity)
        .frame(height: 250)
    }
}

#Preview {
    ChartSheetItem(
        prices: [
            SheetChartPoint(
                timestamp: Date().addingTimeInterval(-3600 * 6),
                priceValue: 6400,
                volume: 0
            ),
            SheetChartPoint(
                timestamp: Date().addingTimeInterval(-3600 * 5),
                priceValue: 6420,
                volume: 0
            ),
            SheetChartPoint(
                timestamp: Date().addingTimeInterval(-3600 * 4),
                priceValue: 6380,
                volume: 0
            ),
            SheetChartPoint(
                timestamp: Date().addingTimeInterval(-3600 * 3),
                priceValue: 6450,
                volume: 0
            ),
            SheetChartPoint(
                timestamp: Date().addingTimeInterval(-3600 * 2),
                priceValue: 6479,
                volume: 0
            ),
            SheetChartPoint(
                timestamp: Date().addingTimeInterval(-3600),
                priceValue: 6460,
                volume: 0
            ),
            SheetChartPoint(
                timestamp: Date(),
                priceValue: 6480,
                volume: 0
            )
        ],
        range: .oneDay
    )
    .preferredColorScheme(.dark)
}
