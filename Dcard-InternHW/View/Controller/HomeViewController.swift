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
    private let viewModel = ItuneStoreViewModel()
    private var infoModel: ItuneStroeModel?
    private let disposeBag = DisposeBag()
    private var tableViewDataSource: UITableViewDiffableDataSource<Section, Item>?
    private let navigationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "搜尋", attributes: [.foregroundColor: UIColor.customGray, .font: UIFont.PingFangTC(fontSize: 17, weight: .Regular)])
        searchBar.searchTextField.font = UIFont.PingFangTC(fontSize: 17, weight: .Regular)
        searchBar.setImage(UIImage(named: "search_icon"), for: .search, state: .normal)
        searchBar.searchTextField.textColor = .customGray
        return searchBar
    }()
    private lazy var infoTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.isHidden = true
        tableView.backgroundColor = .white
        tableView.register(InfoTableViewCell.self, forCellReuseIdentifier: InfoTableViewCell.cellIdentifier)
        return tableView
    }()
    private let resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("重置", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    private let statusView = SearchStatusView()
    
//  MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.hideKeyboardWhenTappedAround()
        setupUI()
        setupBinding()
        configureDataSource()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationView.addShadow(opacity: 0.16, offset: CGSize(width: 0, height: 2), radius: 2)
    }
    private func setupUI() {
        view.backgroundColor = .customBgColor
        view.addSubviews([statusView, infoTableView, navigationView])
        navigationView.addSubviews([searchBar, resetButton])
        
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(120) // TODO - status bar height + 60
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
    }
    private func setupBinding() {
        self.viewModel.searchSubject.subscribe(onNext: { [unowned self] in
            infoTableView.isHidden = ($0.resultCount == 0)
            infoModel = $0
            applySnapShot()
        }).disposed(by: disposeBag)
        
        self.viewModel.statusSubject.subscribe(onNext: { [unowned self] in
            statusView.status = $0
        }).disposed(by: disposeBag)
        
        self.resetButton.rx.tap.subscribe(onNext: { [unowned self] in
            statusView.status = .initial
            infoTableView.isHidden = true
            searchBar.text = ""
        }).disposed(by: disposeBag)
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
        var snapShot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapShot.appendSections([.main])
        
        if let result = infoModel?.results {
            let items = result.map({ return Item.main($0) })
            snapShot.appendItems(items, toSection: .main)
        }
        
        tableViewDataSource?.apply(snapShot, animatingDifferences: true)
    }

}

//  MARK: - TableView Property
extension HomeViewController {
    private enum Section {
        case main
    }
    private enum Item: Hashable {
        case main(ItuneStroeModel.Result)
    }
}

//  MARK: TableView Delegate
extension HomeViewController: UITableViewDelegate, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("test")
    }
}

//  MARK: - TextField Delegate
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let term = searchBar.text else { return }
        viewModel.search(term: term)
    }
}

