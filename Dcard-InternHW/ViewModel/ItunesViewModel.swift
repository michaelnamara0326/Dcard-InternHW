//
//  ItunesViewModel.swift
//  Dcard-InternHW
//
//  Created by Michael Namara on 2023/1/21.
//

import RxSwift
import RxCocoa
import Alamofire
class ItunesViewModel {
    let searchSubject = PublishSubject<[ItunesModel.Result]>()
    let lookupSubject = PublishSubject<ItunesModel.Result>()
    let statusSubject = PublishSubject<SearchStatusView.Status>()
    
    func search(term: String) {
        let completion: (ItunesModel?, String, Error?, Bool) -> Void = { [weak self] data, msg, error, success in
            if success,
               let data = data?.results {
                data.isEmpty ? self?.statusSubject.onNext(.notFound) : self?.searchSubject.onNext(data)
            } else {
                print(error ?? "fetch music info error")
                // statusSubject.onNext(.error(msg: "fetching error"))
            }
        }
        self.statusSubject.onNext(.searching)
        let service = NetworkManager<ItunesRouter>()
        service.requestData(.search(term: term), completion: completion)
    }
    
    func lookUp(trackID: Int) {
        let completion: (ItunesModel?, String, Error?, Bool) -> Void = { [weak self] data, msg, error, success in
            if success,
               let data = data?.results?.first {
                self?.lookupSubject.onNext(data)
            } else {
               print(error ?? "fetch error")
            }
        }
        let service = NetworkManager<ItunesRouter>()
        service.requestData(.lookUp(trackID: trackID), completion: completion)
    }
}
