//
//  ItunesViewModelTests.swift
//  Dcard-InternHWTests
//
//  Created by Michael Namara on 2023/3/7.
//

import XCTest
import RxSwift
@testable import Dcard_InternHW

class ItunesViewModelTests: XCTestCase {
    var viewModel: ItunesViewModel!
    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        viewModel = ItunesViewModel()
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        disposeBag = nil
    }

    func testSearchWithValidTerm() {
        let searchExpectation = expectation(description: "Search completed successfully")
        viewModel.searchSubject.subscribe(onNext: { result in
            XCTAssertFalse(result.isEmpty)
            searchExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.search(term: "周杰倫")
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSearchWithInvalidTerm() {
        let statusExpectation = expectation(description: "Search status updated")
        viewModel.statusSubject.skip(1).subscribe(onNext: { status in
            XCTAssertEqual(status, .notFound)
            statusExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.search(term: "Invalid search term")
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLookUpWithValidTrackID() {
        let lookupExpectation = expectation(description: "Look up completed successfully")
        viewModel.lookupSubject.subscribe(onNext: { result in
            XCTAssertNotNil(result)
            XCTAssertEqual(result?.artistName, "周杰倫")
            XCTAssertEqual(result?.collectionName, "哎呦, 不錯哦")
            XCTAssertEqual(result?.trackName, "美人魚")
            XCTAssertEqual(result?.releaseDate?.customDateFormat(to: "yyyy/MM/dd"), "2014/12/26")
            lookupExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.lookUp(trackID: 944321450)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLookUpWithInvalidTrackID() {
        let lookupExpectation = expectation(description: "Look up completed successfully")
        viewModel.lookupSubject.subscribe(onNext: { result in
            XCTAssertNil(result)
            lookupExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.lookUp(trackID: 0)
        waitForExpectations(timeout: 5, handler: nil)
    }
}
