//
//  NewsView.swift
//  AcademyStocks
//
//  Created by Stevanus Felixiano on 20/04/26.
//
import SwiftUI

struct NewsView: View {
    
    let news: [News] = [
        News(
            source: "Yahoo Finance",
            title: "Stock market today: Dow, S&P 500, and Nasdaq futures inch up amid Apple CEO change and Iran uncertainty",
            subtitle: "US stock futures edged higher as investors reacted to leadership changes at Apple and rising geopolitical tensions in the Middle East.",
            time: "1h ago"
        ),
        News(
            source: "Zacks",
            title: "Dick's Sporting Goods (DKS) Rises As Market Takes a Dip: Key Facts",
            subtitle: "Dick's Sporting Goods shares climbed despite broader market weakness, supported by strong earnings expectations and retail demand.",
            time: "2h ago"
        ),
        News(
            source: "Zacks",
            title: "Array Technologies, Inc. (ARRY) Suffers a Larger Drop Than the General Market: Key Insights",
            subtitle: "Array Technologies declined more than the overall market as investors reacted to sector-wide pressure and earnings concerns.",
            time: "2h ago"
        )
    ]
    
    var companyNews: [CompanyNews] {
        [
            CompanyNews(company: "Dow Jones", news: news),
            CompanyNews(company: "S&P 500", news: news)
        ]
    }
    
    var body: some View {
        VStack(spacing: 6) {
            MovingTicker(stocks: stocksData)
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Business News")
                            .font(.largeTitle.bold())
                        
                        Text("From Yahoo Finance")
                            .foregroundStyle(.secondary)
                    }
                    
                    Divider().overlay(Color.primary.opacity(0.1))
                    
                    ForEach(companyNews) { company in
                        
                        VStack(alignment: .leading, spacing: 2) {
                            
                            Text(company.company)
                                .font(.title.bold())
                            
                            HStack(spacing: 16) {
                                Text("49,442.56")
                                    .font(.title2.bold())
                                Text("-4.87")
                                    .foregroundStyle(.red)
                            }
                            
                            Text("At Close")
                                .foregroundStyle(.secondary)
                                .padding(.bottom, 8)
                            
                            VStack(alignment: .leading, spacing: 20) {
                                ForEach(company.news) { item in
                                    newsItem(item)
                                }
                            }
                            .padding(.top, 16)
                            .padding(.bottom, 16)
                            
                            Divider().overlay(Color.primary.opacity(0.1))
                            
                            HStack {
                                Spacer()
                                Text("MORE \(company.company)")
                                    .foregroundStyle(.secondary)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                            }
                            .font(.subheadline.bold())
                            .padding(.top,12)
                        }
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(.ultraThinMaterial)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.white.opacity(0.06))
                )
                .padding(.bottom, 20)
            }
            .clipShape(RoundedRectangle(cornerRadius: 28))
        }
    }
    
    func newsItem(_ item: News) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Text(item.source)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(item.title)
                .font(.headline)
                .foregroundStyle(.primary)
            
            Text(item.subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            
            Text(item.time)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    var stocksData: [Stock] {[
        Stock(name: "Starbucks", symbol: "SBUX", price: 98.95, change: -1.05, sparklineData: [100, 99, 98, 99, 97, 98, 96]),
        Stock(name: "Apple", symbol: "AAPL", price: 189.12, change: 2.31, sparklineData: [180, 182, 185, 187, 188, 189, 190]),
        Stock(name: "Tesla", symbol: "TSLA", price: 245.33, change: -3.22, sparklineData: [260, 255, 250, 248, 246, 245, 244]),
        Stock(name: "Microsoft", symbol: "MSFT", price: 410.45, change: 1.12, sparklineData: [400, 402, 405, 407, 409, 410, 411]),
        Stock(name: "Amazon", symbol: "AMZN", price: 175.22, change: -0.88, sparklineData: [180, 178, 177, 176, 175, 175, 174]),
        Stock(name: "Google", symbol: "GOOGL", price: 140.67, change: 0.45, sparklineData: [135, 136, 137, 138, 139, 140, 141])
    ]
    }
}

#Preview {
    NewsView()
        .preferredColorScheme(.dark)
}
