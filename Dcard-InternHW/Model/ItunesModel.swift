//
//  ItunesModel.swift
//  Dcard-InternHW
//
//  Created by Michael Namara on 2023/1/21.
//

import Foundation

struct ItunesSearchResultModel: Codable, Hashable {
    let trackID: Int?
    let artistName: String?
    let collectionName: String?
    let trackName: String?
    let artworkURL100: URL?
    
    enum CodingKeys: String, CodingKey {
        case artistName, collectionName, trackName
        case trackID = "trackId"
        case artworkURL100 = "artworkUrl100"
    }
}

struct ItunesLookUpResultModel: Codable {
    let artistName: String?
    let collectionName: String?
    let trackName: String?
    let artistViewURL: URL?
    let collectionViewURL: URL?
    let previewURL: URL?
    let artworkURL100: URL?
    let releaseDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case artistName, collectionName, trackName, releaseDate
        case artistViewURL = "artistViewUrl"
        case collectionViewURL = "collectionViewUrl"
        case previewURL = "previewUrl"
        case artworkURL100 = "artworkUrl100"
    }
}
