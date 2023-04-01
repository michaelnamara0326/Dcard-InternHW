//
//  ResponseModel.swift
//  Dcard-InternHW
//
//  Created by Michael Namara on 2023/3/30.
//

import Foundation

struct ItunesResponseModel<T: Codable>: Codable {
    let resultCount: Int
    let results: [T]
}

/*
 
 Remain scalability for other API response model
 
*/
