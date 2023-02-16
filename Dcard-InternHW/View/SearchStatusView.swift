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
        self.statusImageView.image = status.property.image
        self.statusTitleLabel.text = status.property.title
        self.statusSubTitleLabel.text = status.property.subtitle
    }
}
extension SearchStatusView {
   enum Status {
        case initial
        case notFound
        case searching
        
        var property: (image: UIImage?, title: String, subtitle: String) {
            switch self {
            case .initial:
                return (UIImage(named: "search_init"),
                        "結果將顯示於此",
                        "請於上方搜尋列尋找您喜愛的藝人、歌曲")
                
            case .notFound:
                return (UIImage(named: "search_notFound"),
                        "查無結果",
                        "哎呀，請再重新輸入一次關鍵字")
                
            case .searching:
                return (UIImage(named: "search_searching"),
                        "搜尋中...",
                        "請稍候")
            }
        }
    }
}
