//
//  RouterType.swift
//  Dcard-InternHW
//
//  Created by Michael Namara on 2023/3/29.
//

import Alamofire

protocol RouterType {
    var baseURL: String { get }
    
    var path: String { get }
    
    var method: HTTPMethod { get }
    
    var encoding: ParameterEncoding { get }
    
    var param: [String: Any]? { get }
    
    var header: HTTPHeaders? { get }
}
