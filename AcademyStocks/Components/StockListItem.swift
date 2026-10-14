//
//  StockListItem.swift
//  AcademyStocks
//
//  Created by benchandra on 05/04/26.
//

import SwiftUI
import XCAStocksAPI

struct StockListItem: View {
    let stock: Stock
    @State private var isShowingSheet: Bool = false
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(stock.symbol)
                    .font(.title3)
                    .bold()
                
                Text(stock.name)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            MiniStockChart(stock: stock)
            
            VStack(alignment: .trailing) {
                Text(priceFormatted)
                    .bold()
                
                Text(changeFormatted)
                    .font(.subheadline)
                    .frame(minWidth: 60)
                    .padding(6)
                    .background(
                        changeColor,
                        in: RoundedRectangle(cornerRadius: 6)
                    )
                    .foregroundStyle(.white)
            }
            .padding(.leading, 5)
        }
        .padding(.vertical, 4)
        .onTapGesture {
            isShowingSheet = true
        }
        .sheet(isPresented: $isShowingSheet) {
            StockSheetItem(tickerSymbol: "ASII.JK")
        }
    }
    
    
    private var isPositive: Bool {
        stock.change >= 0
    }
    
    private var changeColor: Color {
        isPositive ? .green : .red
    }
    
    private var priceFormatted: String {
        stock.price.formatted(
            .number.precision(.fractionLength(2))
        )
    }
    
    private var changeFormatted: String {
        stock.change.formatted(
            .number
                .precision(.fractionLength(2))
                .sign(strategy: .always())
        )
    }
}

#Preview {
    StockListItem(stock: Stock(
        name: "PT Astra International Tbk",
        symbol: "ASII.JK",
        price: 6075.12,
        change: +175,
        sparklineData: [
            6100, 6050, 6000, 6050, 6000, 6050,
            6100, 6050, 6100, 6150, 6200, 6150,
            6150, 6150, 6100, 6150, 6100, 6100
        ]
    ))
    .preferredColorScheme(.dark)
}

