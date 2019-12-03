//
//  Result.swift
//  BucketList
//
//  Created by Levit Kanner on 03/12/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import Foundation

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable, Comparable {
    let pageid: Int
    let title: String
    let ns: Int
    let terms: [String: [String]]?
    var description: String {
        terms?["description"]?.first ?? "No further information"
    }
    
    static func < (lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
}
