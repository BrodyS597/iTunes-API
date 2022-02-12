//
//  AlbumDetails.swift
//  iTunes API
//
//  Created by Brody Sears on 2/12/22.
//

import Foundation

struct TopLevelDictionaryAlbumDetails: Decodable {
    let results: [AlbumDetails]
}

struct AlbumDetails: Decodable {
    private enum CodingKeys: String, CodingKey {
        case title = "trackName"
      // case albumImagePath = "artworkUrl100"
        case albumID = "collectionId"
        case kind
        case trackTimeMillis
    }
    let title: String
 //  let albumImagePath: String?
    let albumID: String
    let kind: String
    let trackTimeMillis: Int
}
