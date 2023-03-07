//
//  HomeViewController.swift
//  Dcard-InternHW
//
//  Created by Michael Namara on 2023/1/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    //  MARK: - Init property
    private let viewModel = ItunesViewModel()
    private let disposeBag = DisposeBag()
    private var isLoading = false
    private var totalPage = 1
    private var currentPage = 1
    private let pageItemLimit = 10
    private var searchResults = [ItunesResultModel]() {
        didSet {
            let total = searchResults.count / pageItemLimit
            totalPage = searchResults.count.isMultiple(of: pageItemLimit) ? total : total + 1
        }
    }
    private var tableViewDataSource: UITableViewDiffableDataSource<Section, Item>?
    
    //  MARK: - UI property
    private let navigationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "搜尋", attributes: [.foregroundColor: UIColor.customGray, .font: UIFont.PingFangTC(fontSize: 17, weight: .Regular)])
        searchBar.searchTextField.font = UIFont.PingFangTC(fontSize: 17, weight: .Regular)
        searchBar.setImage(UIImage(named: "search_icon"), for: .search, state: .normal)
        searchBar.searchTextField.textColor = .customGray
        return searchBar
    }()
    
    private lazy var infoTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.isHidden = true
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(InfoTableViewCell.self, forCellReuseIdentifier: InfoTableViewCell.cellIdentifier)
        return tableView
    }()
    
    private let resultsCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .customGray
        label.font = UIFont.PingFangTC(fontSize: 15, weight: .Regular)
        return label
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.layer.cornerRadius = 10
        indicator.hidesWhenStopped = true
        indicator.backgroundColor = UIColor(white: 0.2, alpha: 1)
        return indicator
    }()
    
    private let paginationIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let noMoreDataLabel: UILabel = {
        let label = UILabel()
        label.frame.size.height = 20
        label.numberOfLines = 1
        label.text = "已經沒有更多內容啦"
        label.font = UIFont.PingFangTC(fontSize: 14, weight: .Medium)
        label.textColor = .customBlue
        label.textAlignment = .center
        return label
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("重置", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()

    private let statusView = SearchStatusView()
    
    //  MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        uiBinding()
        viewModelBinding()
        configureDataSource()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationView.addShadow(opacity: 0.16, offset: CGSize(width: 0, height: 2), radius: 2)
    }
    
    //  MARK: - Functions
    private func setupUI() {
        view.backgroundColor = .customBgColor
        view.addSubviews([statusView, infoTableView, navigationView, loadingIndicator])
        navigationView.addSubviews([searchBar, resetButton])
        
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(120)
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(resetButton.snp.leading).offset(-4)
            make.height.equalTo(36)
        }
        resetButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchBar)
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(40)
        }
        statusView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        infoTableView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.bottom.leading.trailing.equalToSuperview()
        }
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalTo(infoTableView)
            make.height.width.equalTo(100)
        }
    }
    
    private func uiBinding() {
        searchBar.rx.searchButtonClicked.subscribe(onNext: { [unowned self] in
            self.searchBar.resignFirstResponder()
            DispatchQueue.main.async {
                self.viewModel.search(term: self.searchBar.text!.replacingOccurrences(of: " ", with: "+"))
                self.reset()
            }
        }).disposed(by: disposeBag)
        
        infoTableView.rx.itemSelected.subscribe(onNext: { [unowned self] indexPath in
            self.viewModel.lookUp(trackID: searchResults[indexPath.row].trackID ?? 0)
        }).disposed(by: disposeBag)
        
        resetButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.reset(resetButton)
        }).disposed(by: disposeBag)
    }
    
    private func viewModelBinding() {
        viewModel.searchSubject.subscribe(onNext: { [unowned self] in
            self.searchResults = $0
            self.resultsCountLabel.text = "搜尋結果數： \($0.count)"
            self.applySnapShot()
        }).disposed(by: disposeBag)
        
        viewModel.lookupSubject.subscribe(onNext: { [unowned self] in
            if let model = $0 {
                let vc = DetailInfoViewController(model: model)
                vc.modalPresentationStyle = .pageSheet
                modalPresentationCapturesStatusBarAppearance = true
                self.present(vc, animated: true)
            } else {
                self.showAlert(title: "該筆歌曲暫無詳細資料", message: "請點選其他作品")
            }
        }).disposed(by: disposeBag)
        
        viewModel.statusSubject.bind(to: statusView.rx.status).disposed(by: disposeBag)

        viewModel.isLoading.bind(to: loadingIndicator.rx.isAnimating).disposed(by: disposeBag)
    }
    
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
    
    private func reset(_ sender: UIButton? = nil) {
        if sender == resetButton {
            searchBar.text = ""
            statusView.status = .initial
        }
        totalPage = 1
        currentPage = 1
        searchResults = []
        infoTableView.isHidden = true
        infoTableView.setContentOffset(.zero, animated: true)
        infoTableView.tableFooterView = self.paginationIndicator
    }
}

    //  MARK: - TableView Diffable DataSource
extension HomeViewController {
    private enum Section {
        case main
    }
    private enum Item: Hashable {
        case main(ItunesResultModel)
    }
}

    //  MARK: - TableView Delegate
extension HomeViewController: UITableViewDelegate, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 16, y: 8, width: tableView.frame.width, height: 20))
        resultsCountLabel.frame = view.frame
        view.addSubview(resultsCountLabel)
        return view
    }

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
}
