//
//  ItuneStoreViewModel.swift
//  Dcard-InternHW
//
//  Created by Michael Namara on 2023/1/21.
//

import RxSwift
import Alamofire
class ItuneStoreViewModel {
    var searchSubject = PublishSubject<ItuneStroeModel>()
    var lookupSubject = PublishSubject<ItuneStroeModel>()
    var statusSubject = PublishSubject<SearchStatusView.Status>()
    
    func search(term: String) {
        let completion: (ItuneStroeModel?, String, Error?, Bool) -> Void = { [weak self] data, msg, error, success in
            if success, let data = data {
                if data.resultCount == 0 {
                    self?.statusSubject.onNext(.notFound)
                } else {
                    self?.searchSubject.onNext(data)
                }
            } else {
                print(error ?? "fetch music info error")
            }
        }
        self.statusSubject.onNext(.searching)
        let service = NetworkManager<ItunesRouter>()
        service.requestData(.search(term: term), completion: completion)
    }
    func lookUp(trackId: Int) {
        let completion: (ItuneStroeModel?, String, Error?, Bool) -> Void = { [weak self] data, msg, error, success in
            if success, let data = data {
                self?.lookupSubject.onNext(data)
            } else {
               print(error ?? "fetch error")
            }
        }
        let service = NetworkManager<ItunesRouter>()
        service.requestData(.lookUp(traceId: trackId), completion: completion)
    }
}
