//
//  DiscoveryView.swift
//  AcademyStocks
//
//  Created by Stevanus Felixiano on 22/04/26.
//

//
//  DiscoveryView.swift
//  AcademyStocks
//

import SwiftUI
import Charts

struct DiscoveryView: View {
    
    @StateObject private var vm = DiscoveryViewModel()
    @Namespace private var tabAnimation
    var placeholderChart: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.white.opacity(0.05))
            .frame(height: 220)
    }
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 20) {
                
                // HEADER + CHART
                VStack(alignment: .leading, spacing: 12) {
                    
                    header
                    
                    Group {
                        if vm.hasLoaded {
                            chart
                        } else {
                            placeholderChart
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.05))
                )
                
                Divider()
                    .overlay(Color.white.opacity(1))
                
                tabBar
                
                //LIST
                VStack(spacing: 16) {
                    ForEach(currentData, id: \.symbol) { stock in
                        stockRow(stock)
                    }
                }
            }
            .padding(.horizontal)
        }
        .background(Color.black.ignoresSafeArea())
        .task {
            await vm.load()
        }
    }
}

extension DiscoveryView {
    
    var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            HStack(spacing: 6) {
                
                Text(vm.selectedMarket.rawValue)
                    .font(.title.bold())
                
                Menu {
                    ForEach(DiscoveryViewModel.Market.allCases, id: \.self) { market in
                        Button {
                            selectMarket(market)
                        } label: {
                            if vm.selectedMarket == market {
                                Label(market.rawValue, systemImage: "checkmark")
                            } else {
                                Text(market.rawValue)
                            }
                        }
                    }
                } label: {
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)
                }
            }
            .foregroundStyle(.primary)
            
            HStack(spacing: 8) {
                
                Text(formatPrice(vm.chartData.last))
                    .font(.title2.bold())
                
                Text(formatChange(vm.change))
                    .foregroundStyle(vm.change >= 0 ? .green : .red)
                
                Text("(\(formatPercent(vm.percent)))")
                    .foregroundStyle(vm.change >= 0 ? .green : .red)
            }
        }
    }
}

extension DiscoveryView {
    
    var tabBar: some View {
        ScrollViewReader { proxy in
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    
                    ForEach(DiscoveryViewModel.Tab.allCases, id: \.self) { tab in
                        
                        VStack(spacing: 6) {
                            
                            Text(tab.rawValue)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(
                                    vm.selectedTab == tab
                                    ? .primary
                                    : .secondary
                                )
                            
                            if vm.selectedTab == tab {
                                Capsule()
                                    .fill(.primary)
                                    .frame(height: 2)
                                    .matchedGeometryEffect(id: "TAB", in: tabAnimation)
                            } else {
                                Color.clear.frame(height: 2)
                            }
                        }
                        .id(tab)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                vm.selectedTab = tab
                            }
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
            .onChange(of: vm.selectedTab) { _, newValue in
                withAnimation {
                    proxy.scrollTo(newValue, anchor: .center)
                }
            }
        }
    }
}

extension DiscoveryView {
    
    var chart: some View {
        
        let data = Array(vm.chartData.enumerated())
        
        return Chart {
            
            // AREA
            ForEach(data, id: \.offset) { index, value in
                AreaMark(
                    x: .value("Index", index),
                    yStart: .value("Min", minY),
                    yEnd: .value("Price", value)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(areaGradient)
            }
            
            // LINE
            ForEach(data, id: \.offset) { index, value in
                LineMark(
                    x: .value("Index", index),
                    y: .value("Price", value)
                )
                .interpolationMethod(.catmullRom)
                .lineStyle(StrokeStyle(lineWidth: 2))
                .foregroundStyle(vm.change >= 0 ? .green : .red)
            }
            
            // MID LINE
            if let min = vm.chartData.min(),
               let max = vm.chartData.max() {
                
                let mid = (min + max) / 2
                
                RuleMark(y: .value("Mid", mid))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                    .foregroundStyle(.gray.opacity(0.5))
            }
        }
        .id(vm.chartData.count)
        .frame(height: 220)
        .chartXAxis(.hidden)
        .chartYAxis {
            AxisMarks(position: .trailing) { _ in
                AxisValueLabel()
                    .foregroundStyle(.gray)
                    .font(.caption2)
            }
        }
        .chartYScale(domain: minY...maxY)
    }
    
    var areaGradient: LinearGradient {
        LinearGradient(
            colors: [
                (vm.change >= 0 ? Color.green : Color.red).opacity(0.4),
                (vm.change >= 0 ? Color.green : Color.red).opacity(0.05)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

extension DiscoveryView {
    
    var minY: Double {
        guard let min = vm.chartData.min() else { return 0 }
        return min * 0.995
    }
    
    var maxY: Double {
        guard let max = vm.chartData.max() else { return 1 }
        return max * 1.005
    }
}

extension DiscoveryView {
    
    func stockRow(_ stock: Stock) -> some View {
        HStack {
            
            VStack(alignment: .leading, spacing: 2) {
                Text(stock.symbol)
                    .font(.headline)
                
                Text(stock.name)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(formatPrice(stock.price))
                    .font(.headline)
                
                Text(formatChange(stock.change))
                    .foregroundStyle(stock.change >= 0 ? .green : .red)
            }
        }
    }
    
    var currentData: [Stock] {
        vm.currentData
    }
}

extension DiscoveryView {
    func selectMarket(_ market: DiscoveryViewModel.Market) {
        Task {
            await vm.selectMarket(market)
        }
    }
}

extension DiscoveryView {
    
    func formatPrice(_ value: Double?) -> String {
        guard let value else { return "-" }
        
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: value)) ?? "-"
    }
    
    func formatChange(_ value: Double) -> String {
        let sign = value >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.2f", value))"
    }
    
    func formatPercent(_ value: Double) -> String {
        let sign = value >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.2f", value))%"
    }
}

#Preview {
    DiscoveryView()
        .preferredColorScheme(.dark)
}
