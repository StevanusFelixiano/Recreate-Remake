//
//  News.swift
//  AcademyStocks
//
//  Created by Stevanus Felixiano on 21/04/26.
//

import Foundation

struct News: Identifiable {
    let id = UUID()
    let source: String
    let title: String
    let subtitle: String
    let time: String
}
