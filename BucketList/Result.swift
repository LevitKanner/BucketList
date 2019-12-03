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

struct Page: Codable {
    let pageId: Int
    let title: String
    let terms: [String: [String]]?
}
