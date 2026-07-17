//
//  Docker.swift
//  Terminal++
//
//  Created by Matt on 7/12/26.
//


struct DockerPsEntry: Decodable, Equatable {
    let container: String
    let id:        String
    let image:     String
    let status:    String
    let ports:     String

    enum CodingKeys: String, CodingKey {
        case container = "Names"
        case id        = "ID"
        case image     = "Image"
        case status    = "Status"
        case ports     = "Ports"
    }
}

