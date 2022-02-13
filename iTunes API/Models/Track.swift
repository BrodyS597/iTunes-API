//
//  AlbumDetails.swift
//  iTunes API
//
//  Created by Brody Sears on 2/12/22.
//

import Foundation

struct TopLevelDictionaryAlbumDetails: Decodable {
    let results: [Track?]
}

struct Track: Decodable {
    private enum CodingKeys: String, CodingKey {
        case title = "trackName"
        case albumID = "collectionId"
        case kind
        case trackTimeMillis
    }
    let title: String?
    let albumID: String
    let kind: String
    let trackTimeMillis: Int
}
