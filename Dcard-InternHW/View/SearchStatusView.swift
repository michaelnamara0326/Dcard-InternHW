//
//  SearchStatusView.swift
//  Dcard-InternHW
//
//  Created by Michael Namara on 2023/1/22.
//

import UIKit
import RxSwift
class SearchStatusView: UIView {
    var status: Status = .initial {
        didSet {
            configure()
        }
    }
    private let statusImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private let statusTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .customBlack
        label.font = UIFont.PingFangTC(fontSize: 20, weight: .Semibold)
        
        return label
    }()
    private let statusSubTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .customBlack
        label.font = UIFont.PingFangTC(fontSize: 14, weight: .Regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
        setupUI()
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        addSubviews([statusImageView, statusTitleLabel, statusSubTitleLabel])
        
        statusImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(120)
        }
        statusTitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(statusImageView)
            make.top.equalTo(statusImageView.snp.bottom).offset(16)
        }
        statusSubTitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(statusImageView)
            make.top.equalTo(statusTitleLabel.snp.bottom).offset(8)
        }
    }
    private func configure() {
        self.statusImageView.image = status.image
        self.statusTitleLabel.text = status.title
        self.statusSubTitleLabel.text = status.subTitle
    }
}
extension SearchStatusView {
    enum Status {
        case initial
        case notFound
        case searching
        
        var image: UIImage? {
            switch self {
            case .initial:
                return UIImage(named:"search_init")
            case .notFound:
                return UIImage(named:"search_notFound")
            case .searching:
                return UIImage(named:"search_searching")
            }
        }
        var title: String {
            switch self {
            case .initial:
                return "結果將顯示於此"
            case .notFound:
                return "查無結果"
            case .searching:
                return "搜尋中..."
            }
        }
        var subTitle: String {
            switch self {
            case .initial:
                return "請於上方搜尋列尋找您喜愛的藝人、歌曲"
            case .notFound:
                return "哎呀，請再重新輸入一次關鍵字"
            case .searching:
                return "請稍候"
            }
        }
    }
}
