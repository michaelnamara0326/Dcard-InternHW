//
//  DetailInfoView.swift
//  Dcard-InternHW
//
//  Created by Michael Namara on 2023/1/29.
//

import UIKit

protocol MoreButtonDelegate: AnyObject {
    func didTapMoreButton(title: String)
}

class DetailInfoView: UIView {
    // MARK: - Init property
    weak var delegate: MoreButtonDelegate?
    
    // MARK: - View property
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customBlack
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont.PingFangTC(fontSize: 14, weight: .regular)
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.font = UIFont.PingFangTC(fontSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "暸解更多", attributes: [.font: UIFont.PingFangTC(fontSize: 14, weight: .semibold), .foregroundColor: UIColor.customBlue, .underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: UIColor.customBlue ]), for: .normal)
        button.addTarget(self, action: #selector(moreButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    // MARK: - View Cycle
    init(title: String, content: String, moreButtonHide: Bool) {
        super.init(frame: .zero)
        titleLabel.text = title
        contentLabel.text = content
        moreButton.isHidden = moreButtonHide
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Function
    private func setupUI() {
        addSubviews([titleLabel, contentLabel, moreButton, seperatorView])
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.bottom.equalTo(contentLabel.snp.top).offset(-4)
        }
        contentLabel.snp.makeConstraints { make in
            if moreButton.isHidden {
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
            } else {
                make.leading.equalToSuperview()
                make.trailing.equalTo(moreButton.snp.leading).offset(-4)
            }
        }
        moreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalTo(contentLabel)
            make.width.equalTo(60)
            make.height.equalTo(25)
        }
        seperatorView.snp.makeConstraints { make in
            make.top.equalTo(moreButton.snp.bottom).offset(4)
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    
    @objc private func moreButtonDidTap(_ sender: UIButton) {
        delegate?.didTapMoreButton(title: titleLabel.text ?? "")
    }
}
