# 2023 Dcard iOS Intern Homework

應徵者： 沈柏帆 (Po-Fan, Shen)

## 基本資訊 Information
- 安裝
 
```
git clone https://github.com/qazwsx19263/Dcard-InternHW.git
pod install
open xcworkspace
```
 
- 開發環境  
  | 名稱  | 版本 |
  |  :--- | ---: |
  | iOS   | 15.0 |
  | Xcode | 14.1 |
  | Swift |  5   |
 
- 套件版本
  | 名稱 | 版本 | 使用原因 |
  | :--- | ---: | ---: |
  | [RxSwift]   | 6.5.0  | 資料綁定、RxCocoa封裝UI元件 |
  | [SDWebImage]| 5.15.0 | Download & Caching URL Image |
  | [Alamofire] | 5.6.4  | 網路層實作 |
  | [SnapKit]   | 5.6.0  | 便捷Auto Layout語法 |  
  
- API 文件  
  https://performance-partners.apple.com/search-api
## 介面設計 UI Design

[Figma](https://www.figma.com/file/0aXmmicKHDjFZt64oTpkl9/Dcard?t=p2b6qgsm86myXi3M-1)
![image](https://user-images.githubusercontent.com/48850203/222737850-fef1e235-36a4-4bbe-b304-e4836587da5d.png)

## 框架 Outline

- 主頁面
  -  負責使用者搜尋功能，並實時顯示搜尋處理狀態。
- 詳細頁面
  -  由使用者點擊任一搜尋結果，以Pop-up視圖的方式預覽作品詳細資訊，方便使用者做退出動作，且該頁面點擊播放按鈕後應可試聽此作品。
- 預覽頁
  -  若使用者想再對其歌手/歌曲進一步了解，在點擊"瞭解更多"按鈕後，跳轉至導覽頁面，並使用Webview加載API所提供之網址。

## 程式架構 Design Pattern

- MVVM


 
## 功能需求 Features

- 列表功能
- [x] 呈現結果於列表
  - 使用UITableview呈現，資料來源透過[UITableViewDiffableSource](https://developer.apple.com/documentation/uikit/uitableviewdiffabledatasource)實作，保留擴充性及維護性，資料已在viewmodel內進行歌手名,專輯名排序。
  ```swift
    private enum Section {
        case main
    }
    private enum Item: Hashable {
        case main(ItunesResultModel)
    }
  ```
  ```swift
    private func configureDataSource() {
          self.tableViewDataSource = UITableViewDiffableDataSource(tableView: infoTableView, cellProvider: { tableView, indexPath, itemIdentifier in
              switch itemIdentifier {
              case .main(let model):
                  let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.cellIdentifier) as! InfoTableViewCell
                  cell.configure(model: model)
                  return cell
              }
          })
     }
    
    private func applySnapShot() {
        var maxIndex = currentPage * pageItemLimit
        if maxIndex >= searchResults.count {
            maxIndex = searchResults.count
            infoTableView.tableFooterView = noMoreDataLabel
        }
        
        var snapShot = NSDiffableDataSourceSnapshot<Section, Item>() 
        let items = searchResults.prefix(upTo: maxIndex).map({ Item.main($0) })
        snapShot.appendSections([.main])
        snapShot.appendItems(items, toSection: .main)
        tableViewDataSource?.apply(snapShot, animatingDifferences: true) {
            self.currentPage += 1
            self.infoTableView.isHidden = false
            self.isLoading = false
            self.paginationIndicator.stopAnimating()
        }
    }
  ```
- [x] 分頁機制
  - 透過searchResults的`didSet`Observer，每當使用者搜尋新關鍵字時，計算回傳結果所需總頁數，目前設定為一頁10筆資料，以及API預設最大回傳上限50筆，亦即目前資料應當不超過五頁。
  ```swift
    private var totalPage = 1
    private var currentPage = 1
    private let pageItemLimit = 10
    private var searchResults = [ItunesResultModel]() {
        didSet {
            let total = searchResults.count / pageItemLimit
            totalPage = searchResults.count.isMultiple(of: pageItemLimit) ? total : total + 1
        }
    }
  ```  
  - 以`是否正撈取` 、 `當前頁數是否已達總頁數`、`資料內容總長度是否大於顯示長度` 、 `是否已達tableview底部` 等機制防止使用者重複撈取及判斷載入新分頁之條件式，此外因Itunes API無做分頁機制，不需重新打API撈資料，在此delay時間執行僅為模擬倘若是有做分頁的API。
  ```swift
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = infoTableView.contentOffset.y
        let contentHeight = infoTableView.contentSize.height
        let tableHeight = infoTableView.frame.height
        let distanceToBottom = contentHeight - offset - tableHeight
        
        if !isLoading && currentPage <= totalPage && contentHeight > tableHeight && distanceToBottom < 0 {
            isLoading = true
            paginationIndicator.startAnimating()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.5 ..< 1.5)) { /// simulate the delay of fetching API
                self.applySnapShot()
            }
        }
    }
  ```
- [x] 點擊後導向詳細頁面
- 詳細頁面
- [x] 取得資料呈現於頁面
- [x] 導連歌手/專輯URL預覽頁
- [x] 播放按鍵
- [x] 返回列表功能
- 預覽頁
- [x] 載入網址
  - 客製頁面，包含關閉及重整按鈕，內嵌WKWebView載入網站內容讓使用者操作，並開啟左右返回手勢。
- [x] 返回詳細頁面

## 網路層及例外處理 Networking & Error Handling
- 考量到整體擴充性，這裡使用protocol協定設計API `RouterType`，方便客製未來其他API Router，保持一定的可讀性及管理性。
```swift
protocol RouterType {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
    var param: [String: Any]? { get }
    var header: HTTPHeaders? { get }
}
```
- 自訂常見網路錯誤Enum
```swift
enum NetworkError: Error {
    case invalidURL
    case disconnectInternet
    case decodingFailed(Error)
    case requestFailed(Error)
    case serverError(Int)
    case defaultError
}

class NetworkErrorHandling {
    static func handleError(_ error: NetworkError) -> String {
        switch error {
        case .invalidURL:
            return "網址錯誤"
        case .disconnectInternet:
            return "無網際網路連線"
        case .requestFailed(let error):
            debugPrint(error)
            return "資料請求失敗"
        case .decodingFailed(let error):
            debugPrint(error)
            return "資料解碼失敗"
        case .serverError(let code):
            return "伺服器錯誤： \(code)"
        case .defaultError:
            return "未知錯誤"
        }
    }
}
```
## 測試 Testing
- 簡易ViewModel測試
  - search(valid / invalid)
  ```swift
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
  ```
  - lookUp(valid / invalid)
  ```swift
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
  ```

**Thanks for reviewing!**

   [RxSwift]: <https://github.com/ReactiveX/RxSwift>
   [SDWebImage]: <https://github.com/SDWebImage/SDWebImage>
   [Alamofire]: <https://github.com/Alamofire/Alamofire>
   [SnapKit]: <https://github.com/SnapKit/SnapKit>

