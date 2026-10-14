//
//  MovingTicker.swift
//  AcademyStocks
//
//  Created by Stevanus Felixiano on 21/04/26.
//
import SwiftUI
import Charts

struct MovingTicker: View {
    
    let stocks: [Stock]
    let onTap: ((String) -> Void)?
    
    init(
        stocks: [Stock],
        onTap: ((String) -> Void)? = nil
    ) {
        self.stocks = stocks
        self.onTap = onTap
    }
    
    var body: some View {
        LoopingScroll(
            itemWidth: 180,
            data: stocks
        ) { stock, _ in
            HStack{
                
                VStack(alignment: .leading, spacing: 1) {
                    Text(stock.symbol)
                        .font(.callout)
                        .fontWeight(.bold)
                    
                    Text(formatPrice(stock.price))
                        .font(.system(size: 17, weight: .bold))
                    
                    Text(formatChange(stock.change))
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(stock.change >= 0 ? .green : .red)
                }
                .padding(.trailing, 15)
                
                Chart {
                    let minVal = stock.sparklineData.min() ?? 0
                    let maxVal = stock.sparklineData.max() ?? 1
                    let range = maxVal - minVal == 0 ? 1 : maxVal - minVal
                    
                    ForEach(0..<stock.sparklineData.count, id: \.self) { i in
                        
                        let value = (stock.sparklineData[i] - minVal) / range
                        let x = Double(i)
                        
                        // Line
                        LineMark(
                            x: .value("x", x),
                            y: .value("y", value * 100)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(stock.change >= 0 ? .green : .red)
                        
                        // Area (gradient)
                        AreaMark(
                            x: .value("x", x),
                            y: .value("y", value * 100)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    (stock.change >= 0 ? Color.green : Color.red).opacity(0.3),
                                    .clear
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    }
                }
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .chartLegend(.hidden)
                .frame(width:70, height: 24)
            }
            .padding(.trailing, 24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8) //
            .contentShape(Rectangle())
            .onTapGesture {
                onTap?(stock.symbol)
            }
        }
        .frame(height: 70)
        
    }
    
    func formatPrice(_ price: Double) -> String {
        String(format: "%.2f", price)
    }
    
    func formatChange(_ change: Double) -> String {
        let sign = change >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.2f", change))"
    }
}

#Preview {
    MovingTicker(stocks: [
        Stock(
            name: "Starbucks",
            symbol: "SBUX",
            price: 98.95,
            change: -1.05,
            sparklineData: [105, 102, 100, 98, 96, 95, 97, 99, 101, 100]
        ),
        Stock(
            name: "Apple",
            symbol: "AAPL",
            price: 189.12,
            change: 2.31,
            sparklineData: [180, 182, 185, 183, 187, 190, 188, 192, 195, 193, 197, 200]
        ),
        Stock(
            name: "Tesla",
            symbol: "TSLA",
            price: 245.33,
            change: -3.22,
            sparklineData: [270, 265, 260, 255, 250, 248, 246, 244, 242, 240, 238]
        ),
        Stock(
            name: "Microsoft",
            symbol: "MSFT",
            price: 410.45,
            change: 1.12,
            sparklineData: [400, 405, 402, 408, 412, 409, 415, 418, 420, 417]
        ),
        Stock(
            name: "Amazon",
            symbol: "AMZN",
            price: 175.22,
            change: -0.88,
            sparklineData: [180, 178, 175, 172, 174, 173, 170, 168, 169, 167]
        ),
        Stock(
            name: "Google",
            symbol: "GOOGL",
            price: 140.67,
            change: 0.45,
            sparklineData: [135, 137, 136, 138, 140, 139, 142, 141, 143, 145]
        ),
        Stock(
            name: "Dow Jones",
            symbol: "Dow Jones",
            price: 49490.67,
            change: 0.45,
            sparklineData: [49000, 49100, 48950, 49200, 49350, 49150, 49400, 49500, 49300, 49600]
        )
    ], onTap: { symbol in
        print("Tapped:", symbol)
    })
    .preferredColorScheme(.dark)
}
