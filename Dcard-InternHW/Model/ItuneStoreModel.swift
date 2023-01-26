//
//  ItuneStroeModel.swift
//  Dcard-InternHW
//
//  Created by Michael Namara on 2023/1/21.
//

import Foundation

struct ItuneStroeModel: Codable, Hashable {
    let resultCount: Int?
    let results: [Result]?
    
    struct Result: Codable, Hashable {
        let trackId: Int?
        let artistName: String?
        let collectionName: String?
        let trackName: String?
        let artistViewUrl: URL?
        let collectionViewUrl: URL?
        let previewUrl: URL?
        let artworkUrl100: URL?
        let releaseDate: Date?
//        var releaseDateFormat:String {
//            let dateFormatter = DateFormatter()
//            dateFormatter.locale = Locale(identifier: "zh_Hant_TW")
//            dateFormatter.dateFormat = "yyyy/MM/dd"
//            return dateFormatter.string(from: releaseDate ?? Date())
//        }
    }
}
