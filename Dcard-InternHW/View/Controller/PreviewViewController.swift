//
//  PreviewViewController.swift
//  Dcard-InternHW
//
//  Created by Michael Namara on 2023/2/6.
//

import UIKit
import WebKit

class PreviewViewController: UIViewController {
// MARK: - Init Property
    private let navigationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingMiddle
        label.font = UIFont.PingFangTC(fontSize: 16, weight: .Semibold)
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close_icon"), for: .normal)
        button.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    
// MARK: - View Cycle
    init(title: String?, url: URL?) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = title ?? ""
        loadWebView(url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        navigationView.addShadow(opacity: 0.16, offset: CGSize(width: 0, height: 2), radius: 2)
    }
    
// MARK: - Functions
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubviews([navigationView, webView])
        navigationView.addSubviews([titleLabel, closeButton])
        
        navigationView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(120)
        }
        closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(22)
            make.bottom.equalToSuperview().offset(-12)
            make.height.width.equalTo(24)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(closeButton)
            make.width.equalTo(250)
            make.bottom.equalToSuperview().offset(-12)
            make.centerX.equalToSuperview()
        }
        webView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(2)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func loadWebView(_ url: URL?) {
        if let url = url {
            self.webView.load(URLRequest(url: url))
        }
    }
    
    @objc private func closeButtonDidTap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

}
