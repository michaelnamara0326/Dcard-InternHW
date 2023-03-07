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
    let decoder = JSONDecoder()
    
    func requestData<T: Decodable>(_ router: Router, completion: @escaping (T?, NetworkError?) -> Void) {
        let urlString = router.baseURL + router.path
        decoder.dateDecodingStrategy = .iso8601
        
        guard let reachability = reachability,
              reachability.isReachable else { /// Check user internet first
            completion(nil, .disconnectInternet)
            return
        }
        AF.request(urlString,
                   method: router.method,
                   parameters: router.param,
                   encoding: router.encoding,
                   headers: router.header) { $0.timeoutInterval = 30 }
            .validate()
            .responseDecodable(of: T.self, decoder: decoder) { response in
                switch response.result {
                case .success(let data):
                    completion(data, nil)
                case .failure(let error):
                    completion(nil, self.transferAFError(error))
                }
            }
    }
    
    private func transferAFError(_ error: AFError) -> NetworkError {
        switch error {
        case .invalidURL(_):
            return .invalidURL
            
        case .responseValidationFailed(reason: .unacceptableStatusCode(let code)):
            return .serverError(code)
            
        case .responseSerializationFailed(reason: .decodingFailed(let error)):
            return .decodingFailed(error)
            
        case .sessionTaskFailed(let error):
            return .requestFailed(error)
            
        default:
            return .defaultError
        }
    }
}


