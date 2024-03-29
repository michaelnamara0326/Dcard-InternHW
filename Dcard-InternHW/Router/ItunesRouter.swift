//
//  ItunesRouter.swift
//  Dcard-InternHW
//
//  Created by Michael Namara on 2023/1/23.
//

import Alamofire

enum ItunesRouter {
    case search(term: String)
    case lookUp(trackID: Int)
}

extension ItunesRouter: RouterType {
    var baseURL: String {
        return "https://itunes.apple.com"
    }
    
    var path: String {
        switch self {
        case .search:
            return "/search"
        case .lookUp:
            return "/lookup"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var encoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var param: [String : Any]? {
        switch self {
        case .search(let term):
            return
                [
                    "term": term,
                    "country": "tw",
                    "entity": "song",
                    "media": "music"
                ]
            
        case .lookUp(let trackId):
            return
                [
                    "id": trackId,
                    "country": "tw"
                ]
        }
    }

    var header: HTTPHeaders? {
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        return headers
    }
    
}
