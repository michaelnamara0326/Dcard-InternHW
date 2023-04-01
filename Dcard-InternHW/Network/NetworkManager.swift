//
//  NetworkManager.swift
//  Dcard-InternHW
//
//  Created by Michael Namara on 2023/1/23.
//

import Alamofire

struct NetworkManager<Router: RouterType> {
    let reachabilityManager: NetworkReachabilityManager?
    let decoder: JSONDecoder
    
    init(reachabilityManager: NetworkReachabilityManager? = NetworkReachabilityManager.default, decoder: JSONDecoder = JSONDecoder()) {
        self.reachabilityManager = reachabilityManager
        self.decoder = decoder
    }
    
    func requestData<T: Decodable>(_ router: Router, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard (reachabilityManager?.isReachable ?? false) else { // Check user internet first
            return completion(.failure(.disconnectInternet))
        }

        let urlString = router.baseURL + router.path
        AF.request(urlString,
                   method: router.method,
                   parameters: router.param,
                   encoding: router.encoding,
                   headers: router.header) { $0.timeoutInterval = 30 }
            .validate()
            .responseDecodable(of: T.self, decoder: decoder) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(self.transferAFError(error)))
                }
            }
    }
    
    private func transferAFError(_ error: AFError) -> NetworkError {
        switch error {
        case .invalidURL(_):
            return .invalidURL
            
        case .responseValidationFailed(reason: .unacceptableStatusCode(let code)):
            switch code {
            case 400...499:
                return .clientError(code)
            case 500...599:
                return .serverError(code)
            default:
                return .defaultError(error)
            }
            
        case .responseSerializationFailed(reason: .decodingFailed(let error)):
            return .decodingFailed(error)
            
        case .sessionTaskFailed(let error):
            return .requestFailed(error)
            
        default:
            return .defaultError(error)
        }
    }
}


