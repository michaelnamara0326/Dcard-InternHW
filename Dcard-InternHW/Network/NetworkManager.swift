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
    
}

struct NetworkManager<Router: RouterType> {
    
    func requestData<D: Decodable>(_ router: Router, completion: @escaping (D?, String, Error?, Bool) -> Void) {
        let urlString = router.baseURL + router.path
        
        AF.request(urlString,
                   method: router.method,
                   parameters: router.param,
                   encoding: router.encoding)
        .validate()
        .responseDecodable(of: D.self) { (response) in
            switch response.result {
            case .success(let data):
                completion(data, "", nil, true)
            case .failure(let error):
                completion(nil, "Request Failed", error, false)
            }
        }
    }
}

