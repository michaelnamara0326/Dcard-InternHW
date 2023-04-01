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
    let searchSubject = PublishSubject<[ItunesSearchResultModel]>()
    let lookupSubject = PublishSubject<ItunesLookUpResultModel?>()
    let statusSubject = PublishSubject<SearchStatus>()
    let isLoading = PublishSubject<Bool>()
    
    // MARK: - ViewModel Functions
    typealias ItunesCompletion<T: Codable> = (Result<ItunesResponseModel<T>, NetworkError>) -> Void

    func search(term: String) {
        let completion: ItunesCompletion<ItunesSearchResultModel> = { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                if data.results.isEmpty {
                    self.statusSubject.onNext(.notFound)
                } else {
                    let sortResults = self.sortResults(data.results)
                    self.searchSubject.onNext(sortResults)
                }
            case .failure(let error):
                self.statusSubject.onNext(.apiError(title: error.message))
            }
        }
        self.statusSubject.onNext(.searching)
        let service = NetworkManager<ItunesRouter>()
        service.requestData(.search(term: term), completion: completion)
    }
    
    func lookUp(trackID: Int) {
        let completion: ItunesCompletion<ItunesLookUpResultModel> = { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.lookupSubject.onNext(data.results.first ?? nil)
            case .failure(let error):
                NetwrokErrorHandling.showErrorAlert(error: error)
            }
            self.isLoading.onNext(false)
        }
        self.isLoading.onNext(true)
        let service = NetworkManager<ItunesRouter>()
        service.decoder.dateDecodingStrategy = .iso8601
        service.requestData(.lookUp(trackID: trackID), completion: completion)
    }
    
    private func sortResults(_ results: [ItunesSearchResultModel]) -> [ItunesSearchResultModel] {
        return results.sorted {
            if $0.artistName == $1.artistName {
                return ($0.collectionName ?? "") > ($1.collectionName ?? "")
            } else {
                return ($0.artistName ?? "") > ($1.artistName ?? "")
            }
        }
    }
}
