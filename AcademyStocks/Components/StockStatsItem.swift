//
//  StockDetailView.swift
//  AcademyStocks
//
//  Created by Stevanus Felixiano on 22/04/26.
//
import SwiftUI

struct StockStatsItem: View {
    let stockDetail: StockDetailModel
    
    var body: some View {
        HStack {
            ForEach(columns.indices, id: \.self) { index in
                VStack(spacing: 6){
                    ForEach(columns[index], id: \.label) { items in
                        StockDetailRow(label: items.label, value: items.value)
                    }
                }
                .font(.caption)
                Divider()
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    private var columns: [[StockDetailItem]] {
        [
            [
                StockDetailItem(label: "Open", value: stockDetail.openValue),
                StockDetailItem(label: "High", value: stockDetail.highValue),
                StockDetailItem(label: "Low", value: stockDetail.lowValue)
            ],
            [
                StockDetailItem(label: "Vol", value: 123),
                StockDetailItem(label: "P/E", value: stockDetail.peRatio),
                StockDetailItem(label: "Mkt Cap", value: stockDetail.marketCap)
            ],
            [
                StockDetailItem(label: "52W H", value: 85.88),
                StockDetailItem(label: "52W L", value: 85.88),
                StockDetailItem(label: "Avg Vol", value: 85.88)
            ],
        ]
    }
}

struct StockDetailRow: View {
    let label: String
    let value: Double
    
    var body: some View {
        HStack {
            Text(label).foregroundColor(.gray)
            Spacer()
            Text(value, format: .number)
        }
    }
}

struct StockDetailItem {
    let label: String
    let value: Double
}

#Preview {
    StockStatsItem(
        stockDetail: StockDetailModel(
            ticketSymbol: "ASII.JK",
            companyName: "PT Astra International Tbk",
            currentPrice: 86.52,
            previousClose: 84.78,
            change: 0.71,
            changePercent: 3,
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
    )
    .padding()
}
