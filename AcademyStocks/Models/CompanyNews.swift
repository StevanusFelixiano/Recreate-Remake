//
//  CompanyNews.swift
//  AcademyStocks
//
//  Created by Stevanus Felixiano on 21/04/26.
//
import Foundation

struct CompanyNews: Identifiable {
    let id: UUID = UUID()
    let company: String
    let news: [News]
}
