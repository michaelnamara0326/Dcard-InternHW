//
//  NetworkError.swift
//  Dcard-InternHW
//
//  Created by Michael Namara on 2023/4/1.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case disconnectInternet
    case clientError(Int)
    case serverError(Int)
    case decodingFailed(Error)
    case requestFailed(Error)
    case defaultError(Error)
}

extension NetworkError {
    var message: String {
        switch self {
        case .invalidURL:
            return "網址錯誤"
            
        case .disconnectInternet:
            return "無網際網路連線"

        case .clientError(let code):
            return "客戶端錯誤: \(code)"
            
        case .serverError(let code):
            return "伺服器錯誤： \(code)"
            
        case .requestFailed(let error):
            debugPrint(error)
            return "資料請求失敗"
            
        case .decodingFailed(let error):
            debugPrint(error)
            return "資料解碼失敗"
            
        case .defaultError(let error):
            debugPrint(error)
            return "未知錯誤"
        }
    }
}
