//
//  PreviewViewController.swift
//  Dcard-InternHW
//
//  Created by Michael Namara on 2023/2/6.
//

import UIKit
import WebKit

class PreviewViewController: UIViewController {
    private let navigationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "BTS"
        label.font = UIFont.PingFangTC(fontSize: 16, weight: .Semibold)
        label.numberOfLines = 1
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
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubviews([navigationView, webView])
        navigationView.addSubviews([titleLabel, closeButton])
        
        navigationView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(120)
        }
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            make.leading.equalToSuperview().offset(16)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(closeButton)
            make.centerX.equalToSuperview()
        }
        webView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(2)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    private func loadWebView(_ url: URL?) {
        print(Thread.current.name)
        DispatchQueue.main.async {
            if let url = url {
                self.webView.load(URLRequest(url: url))
            }
        }
    }
    @objc private func closeButtonDidTap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

}
