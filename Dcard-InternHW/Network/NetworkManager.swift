//
//  NetworkManager.swift
//  Dcard-InternHW
//
//  Created by Michael Namara on 2023/1/23.
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

class NetworkManager<Router: RouterType> {
    let reachability = NetworkReachabilityManager()
    
    func requestData<T: Decodable>(_ router: Router, completion: @escaping (T?, String, Error?, Bool) -> Void) {
        if !reachability!.isReachable {
            print("no internet connect")
        }
        let urlString = router.baseURL + router.path
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        AF.request(urlString,
                   method: router.method,
                   parameters: router.param,
                   encoding: router.encoding)
        .validate()
        .responseDecodable(of: T.self, decoder: decoder) { (response) in
            switch response.result {
            case .success(let data):
                completion(data, "", nil, true)
            case .failure(let error):
                completion(nil, "decoding fail", error, false)
            }
        }
    }
}

