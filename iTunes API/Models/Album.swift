//
//  Album.swift
//  iTunes API
//
//  Created by Brody Sears on 2/11/22.
//

import Foundation

struct TopLevelDictionaryAlbums: Decodable {
    let results: [Albums]
}

struct Albums: Decodable {
    private enum CodingKeys: String, CodingKey {
        case title = "collectionName"
        case trackCount
        case albumImagePath = "artworkUrl100"
    }
    let title: String
    let trackCount: Int
    let albumImagePath: String?
}