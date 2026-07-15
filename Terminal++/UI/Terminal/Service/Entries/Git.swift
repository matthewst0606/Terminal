//
//  Git.swift
//  Terminal++
//
//  Created by Matt on 7/12/26.
//

struct GitStatusEntry: Decodable, Equatable {
    let path: String
    let status: String
}

struct GitAddSummary: Decodable, Equatable {
    var added = 0
    var modified = 0
    var deleted = 0
}
