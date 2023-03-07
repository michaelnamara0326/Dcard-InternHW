//
//  NetworkErrorHandling.swift
//  Dcard-InternHW
//
//  Created by Michael Namara on 2023/3/5.
//

import Foundation


enum NetworkError: Error {
    case invalidURL
    case disconnectInternet
    case decodingFailed(Error)
    case requestFailed(Error)
    case serverError(Int)
    case defaultError
}

class NetworkErrorHandling {
    static func handleError(_ error: NetworkError) -> String {
        switch error {
        case .invalidURL:
            return "網址錯誤"
        case .disconnectInternet:
            return "無網際網路連線"
        case .requestFailed(let error):
            debugPrint(error)
            return "資料請求失敗"
        case .decodingFailed(let error):
            debugPrint(error)
            return "資料解碼失敗"
        case .serverError(let code):
            return "伺服器錯誤： \(code)"
        case .defaultError:
            return "未知錯誤"
        }
    }
}
