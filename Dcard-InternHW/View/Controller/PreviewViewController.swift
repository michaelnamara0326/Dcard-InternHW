//
//  PreviewViewController.swift
//  Dcard-InternHW
//
//  Created by Michael Namara on 2023/2/6.
//

import UIKit
import WebKit

class PreviewViewController: UIViewController {
    // MARK: - View Property
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
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close_icon"), for: .normal)
        button.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var reloadButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setImage(UIImage(named: "reload_icon"), for: .normal)
        button.addTarget(self, action: #selector(reloadButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let loadingWebViewIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .medium)
        activity.hidesWhenStopped = true
        activity.color = .customBlue
        return activity
    }()
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()
    
// MARK: - View Cycle
    init(title: String, url: URL?) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = title
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
        navigationView.addSubviews([titleLabel, closeButton, reloadButton, loadingWebViewIndicator])
        
        navigationView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(closeButton).offset(16)
        }
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalToSuperview().offset(22)
            make.height.width.equalTo(24)
        }
        reloadButton.snp.makeConstraints { make in
            make.top.equalTo(closeButton)
            make.trailing.equalToSuperview().offset(-22)
            make.height.width.equalTo(24)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(closeButton)
            make.width.equalTo(250)
            make.centerX.equalToSuperview()
        }
        webView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(3)
            make.leading.trailing.bottom.equalToSuperview()
        }
        loadingWebViewIndicator.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-22)
            make.bottom.equalTo(reloadButton)
            make.height.width.equalTo(reloadButton)
        }
    }
    
    private func loadWebView(_ url: URL?) {
        guard let url = url else {
            self.showAlert(title: "網址錯誤", message: "請稍後再試") {
                self.dismiss(animated: true)
            }
            return
        }
        self.webView.load(URLRequest(url: url, timeoutInterval: 3))
    }
    
    @objc private func closeButtonDidTap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @objc private func reloadButtonDidTap(_ sender: UIButton) {
        self.webView.reload()
    }
}

extension PreviewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        reloadButton.isHidden = true
        loadingWebViewIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        reloadButton.isHidden = false
        loadingWebViewIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let error = error as NSError
        if error.code == -1001 { // request timeout code
            showAlert(title: "請求超時", message: "請稍候再試") {
                self.dismiss(animated: true)
            }
        }
    }
}
