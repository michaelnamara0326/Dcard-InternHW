//
//  ItunesModel.swift
//  Dcard-InternHW
//
//  Created by Michael Namara on 2023/1/21.
//

import Foundation

struct ItunesResponseModel<T: Codable>: Codable {
    let resultCount: Int
    let results: [T]
}

struct ItunesResultModel: Codable, Hashable {
    //Note: "search" and "lookUp" are using same result model here.
    let trackID: Int?
    let artistName: String?
    let collectionName: String?
    let trackName: String?
    let artistViewURL: URL?
    let collectionViewURL: URL?
    let previewURL: URL?
    let artworkURL100: URL?
    let releaseDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case trackID = "trackId"
        case artistName
        case collectionName
        case trackName
        case artistViewURL = "artistViewUrl"
        case collectionViewURL = "collectionViewUrl"
        case previewURL = "previewUrl"
        case artworkURL100 = "artworkUrl100"
        case releaseDate
    }
}
