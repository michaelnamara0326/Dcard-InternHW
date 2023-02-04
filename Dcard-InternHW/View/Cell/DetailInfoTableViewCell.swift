//
//  DetailInfoTableViewCell.swift
//  Dcard-InternHW
//
//  Created by Michael Namara on 2023/1/26.
//

import UIKit

class DetailInfoTableViewCell: UITableViewCell {
    private let frameView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let mainTitle: UILabel = {
        let label = UILabel()
        label.text = "Test main"
        label.font = UIFont.PingFangTC(fontSize: 14, weight: .Regular)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let valueTitle: UILabel = {
        let label = UILabel()
        label.text = "Test value"
        label.font = UIFont.PingFangTC(fontSize: 16, weight: .Medium)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "暸解更多", attributes: [.font: UIFont.PingFangTC(fontSize: 14, weight: .Semibold), .foregroundColor: UIColor.customBlue, .underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: UIColor.customBlue ]), for: .normal)
        button.addTarget(DetailInfoTableViewCell.self, action: #selector(moreButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupUI() {
        contentView.addSubview(frameView)
        frameView.addSubviews([mainTitle, valueTitle, moreButton, seperatorView])
        
        frameView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(58)
        }
        
        mainTitle.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.bottom.equalTo(valueTitle.snp.top).offset(-4)
        }
        
        valueTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints { make in
            make.centerY.equalTo(valueTitle)
            make.trailing.equalToSuperview()
        }
        
        seperatorView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    private func configure(model: ItuneStroeModel) {
        
    }
    @objc private func moreButtonDidTap(_ sender: UIButton) {
        print("tap")
    }
}
extension DetailInfoTableViewCell {
    enum Detail: String, CaseIterable {
        case artist = "歌手"
        case track = "歌曲名稱"
        case collection = "專輯"
        case releaseDate = "發行日期"
    }

}
