//
//  ItunesViewModel.swift
//  Dcard-InternHW
//
//  Created by Michael Namara on 2023/1/21.
//

import RxSwift
import RxCocoa

class ItunesViewModel {
    // MARK: - Observer Property
    let searchSubject = PublishSubject<[ItunesResultModel]>()
    let lookupSubject = PublishSubject<ItunesResultModel?>()
    let statusSubject = PublishSubject<SearchStatus>()
    let isLoading = PublishSubject<Bool>()
    
    // MARK: - ViewModel Functions
    let service = NetworkManager<ItunesRouter>()
    typealias ItunesCompletion<T: Codable> = (ItunesResponseModel<T>?, NetworkError?) -> Void
    
    func search(term: String) {
        let completion: ItunesCompletion<ItunesResultModel> = { [weak self] data, error in
            guard let self = self else { return }
            if let data = data {
                if data.results.isEmpty {
                    self.statusSubject.onNext(.notFound)
                } else {
                    let sortResults = self.sortResults(data.results)
                    self.searchSubject.onNext(sortResults)
                }
            } else {
                let message = NetworkErrorHandling.handleError(error!)
                self.statusSubject.onNext(.apiError(message: message))
            }
        }
        self.statusSubject.onNext(.searching)
        service.requestData(.search(term: term), completion: completion)
    }
    
    func lookUp(trackID: Int) {
        let completion: ItunesCompletion<ItunesResultModel> = { [weak self] data, error in
            guard let self = self else { return }
            self.isLoading.onNext(false)
            if let data = data {
                self.lookupSubject.onNext(data.results.first ?? nil)
            } else {
                // show error alert
                let vc = UIApplication.getTopViewController()
                let title = NetworkErrorHandling.handleError(error!)
                vc?.showAlert(title: title, message: "請稍後再試")
            }
        }
        isLoading.onNext(true)
        service.requestData(.lookUp(trackID: trackID), completion: completion)
    }
    
    private func sortResults(_ results: [ItunesResultModel]) -> [ItunesResultModel] {
        return results.sorted {
            if $0.artistName == $1.artistName {
                return ($0.collectionName ?? "") > ($1.collectionName ?? "")
            } else {
                return ($0.artistName ?? "") > ($1.artistName ?? "")
            }
        }
    }
}
