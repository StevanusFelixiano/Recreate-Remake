//
//  ChartRange.swift
//  AcademyStocks
//
//  Created by Stevanus Felixiano on 26/04/26.
//

import Foundation
import XCAStocksAPI

enum ChartTimeRange: CaseIterable {
    case oneDay
    case oneWeek
    case oneMonth
    case threeMonth
    case sixMonth
    case ytd
    case oneYear
    case twoYear
    case fiveYear
    case tenYear
    case all
    
    var title: String {
        switch self {
        case .oneDay: return "1D"
        case .oneWeek: return "1W"
        case .oneMonth: return "1M"
        case .threeMonth: return "3M"
        case .sixMonth: return "6M"
        case .ytd: return "YTD"
        case .oneYear: return "1Y"
        case .twoYear: return "2Y"
        case .fiveYear: return "5Y"
        case .tenYear: return "10Y"
        case .all: return "ALL"
        }
    }
    
    var apiRange: ChartRange {
        switch self {
        case .oneDay: return .oneDay
        case .oneWeek: return .oneWeek
        case .oneMonth: return .oneMonth
        case .threeMonth: return .threeMonth
        case .sixMonth: return .sixMonth
        case .ytd: return .ytd
        case .oneYear: return .oneYear
        case .twoYear: return .twoYear
        case .fiveYear: return .fiveYear
        case .tenYear:
            return .tenYear
            
        case .all:
            return .max
        }
    }
}
