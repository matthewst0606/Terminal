//
//  Directory.swift
//  Terminal++
//
//  Created by Matt on 7/12/26.
//

struct DirectoryEntry: Decodable, Equatable {
    let name: String
    let path: String
    let kind: String
}
