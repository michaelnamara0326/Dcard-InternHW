//
//  DetailInfoView.swift
//  Dcard-InternHW
//
//  Created by Michael Namara on 2023/1/29.
//

import UIKit


protocol moreButtonDelegate {
    func didTapMoreButton()
}
class DetailInfoView: UIView {
    var delegate: moreButtonDelegate?
    var mainText: String?
    var valueText: String?
    private let frameView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let mainTitle: UILabel = {
        let label = UILabel()
        label.textColor = .customBlack
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont.PingFangTC(fontSize: 14, weight: .Regular)
        return label
    }()
    
    private let valueTitle: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont.PingFangTC(fontSize: 16, weight: .Medium)
        return label
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "暸解更多", attributes: [.font: UIFont.PingFangTC(fontSize: 14, weight: .Semibold), .foregroundColor: UIColor.customBlue, .underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: UIColor.customBlue ]), for: .normal)
        button.addTarget(self, action: #selector(moreButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    init(main: String, value: String) {
        self.mainText = main
        self.valueText = value
        super.init(frame: .zero)
        
        setupUI()
        configure()
    }
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//        configure()
//    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        addSubviews([mainTitle, valueTitle, moreButton, seperatorView])
        
        mainTitle.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.bottom.equalTo(valueTitle.snp.top).offset(-4)
        }
        valueTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalTo(seperatorView.snp.top).offset(-8)
        }
        moreButton.snp.makeConstraints { make in
            make.centerY.bottom.equalTo(valueTitle)
            make.trailing.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(25)
        }
        seperatorView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    private func configure() {
        mainTitle.text = mainText
        valueTitle.text = valueText
    }
    @objc private func moreButtonDidTap(_ sender: UIButton) {
        delegate?.didTapMoreButton()
    }
}
