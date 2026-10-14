//
//  LoopingScroll.swift
//  AcademyStocks
//
//  Created by Stevanus Felixiano on 23/04/26.
//

import SwiftUI
import Combine

struct LoopingScroll<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    
    var spacing: CGFloat = 8
    var scrollingSpeed: CGFloat = 0.7
    var itemWidth: CGFloat
    var data: Data
    
    @ViewBuilder var content: (_ item: Data.Element, _ isRepeated: Bool) -> Content
    
    @State private var scrollPosition: ScrollPosition = .init()
    @State private var containerWidth: CGFloat = 0
    @State private var currentOffset: CGFloat = 0
    @State private var repeatingCount: Int = 0
    
    var body: some View {
        ScrollView(.horizontal) {
            
            HStack(spacing: spacing) {
                
                HStack(spacing: spacing) {
                    ForEach(data) { item in
                        content(item, false)
                            .frame(width: itemWidth)
                    }
                }
                
                // repeated
                HStack(spacing: spacing) {
                    ForEach(0..<repeatingCount, id: \.self) { index in
                        
                        let actualIndex = index % data.count
                        let itemIndex = data.index(data.startIndex, offsetBy: actualIndex)
                        
                        content(data[itemIndex], true)
                            .frame(width: itemWidth)
                    }
                }
            }
        }
        .scrollPosition($scrollPosition)
        .scrollIndicators(.hidden)
        
        // measure container
        .onScrollGeometryChange(for: CGFloat.self) {
            $0.containerSize.width
        } action: { _, newValue in
            
            let safeValue: Int = 2
            let neededCount = (newValue / (itemWidth + spacing)).rounded()
            
            repeatingCount = Int(neededCount) + safeValue
            containerWidth = newValue
        }
        
        // track offset
        .onScrollGeometryChange(for: CGFloat.self) {
            $0.contentOffset.x + $0.contentInsets.leading
        } action: { _, newValue in
            
            currentOffset = newValue
            guard repeatingCount > 0 else { return }
            
            let contentWidth = CGFloat(data.count) * (itemWidth + spacing)
            if newValue > contentWidth {
                var transaction = Transaction()
                transaction.scrollPositionUpdatePreservesVelocity = true
                
                withTransaction(transaction) {
                    scrollPosition.scrollTo(x: newValue - contentWidth)
                }
            }
            
            if newValue < 0 {
                var transaction = Transaction()
                transaction.scrollPositionUpdatePreservesVelocity = true
                
                withTransaction(transaction) {
                    scrollPosition.scrollTo(x: contentWidth + newValue)
                }
            }
        }
        
        // auto scroll
        .onReceive(
            Timer.publish(every: 0.016, on: .main, in: .default).autoconnect()
        ) { _ in
            guard containerWidth > 0 else { return }
            scrollPosition.scrollTo(x: currentOffset + scrollingSpeed)
        }
    }
}
