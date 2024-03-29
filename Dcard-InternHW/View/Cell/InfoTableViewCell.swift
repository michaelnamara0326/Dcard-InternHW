//
//  InfoTableViewCell.swift
//  Dcard-InternHW
//
//  Created by Michael Namara on 2023/1/21.
//

import UIKit
import SDWebImage

class InfoTableViewCell: UITableViewCell {
    private let frameView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let collectionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let infoIcons: [UIImageView] = {
        var imageViews: [UIImageView] = []
        InfoType.allCases.forEach {
            let icon = UIImageView()
            icon.image = $0.property.image
            imageViews.append(icon)
        }
        return imageViews
    }()
    
    private let infoTitles: [UILabel] = {
        var labels: [UILabel] = []
        InfoType.allCases.forEach {
            let label = UILabel()
            label.font = $0.property.font
            label.textColor = .black
            label.textAlignment = .left
            label.numberOfLines = 1
            labels.append(label)
        }
        return labels
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.spacing = 8
        return stackView
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "arrow_right")
        return imageView
    }()
    
    private let separatorView: UIView = {
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
        setupInfoStackView()
        contentView.addSubview(frameView)
        frameView.addSubviews([collectionImageView, infoStackView, arrowImageView, separatorView])
        
        frameView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-8)
        }
        collectionImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8)
            make.height.width.equalTo(100)
        }
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(collectionImageView).offset(8)
            make.leading.equalTo(collectionImageView.snp.trailing).offset(8)
            make.trailing.equalTo(arrowImageView.snp.leading)
            make.bottom.equalTo(collectionImageView).offset(-8)
        }
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalTo(infoStackView)
            make.trailing.equalToSuperview()
            make.height.width.equalTo(16)
        }
        separatorView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    private func setupInfoStackView() {
        for i in 0 ..< InfoType.allCases.count {
            let view = UIView()
            let icon = infoIcons[i]
            let title = infoTitles[i]
            
            view.addSubviews([icon, title])
            infoStackView.addArrangedSubview(view)
            icon.snp.makeConstraints { make in
                make.top.leading.bottom.equalToSuperview()
                make.height.width.equalTo(16)
            }
            title.snp.makeConstraints { make in
                make.top.bottom.trailing.equalToSuperview()
                make.leading.equalTo(icon.snp.trailing).offset(8)
            }
        }
    }
    
    func configure(model: ItunesSearchResultModel) {
        DispatchQueue.main.async {
            self.collectionImageView.sd_setImage(with: model.artworkURL100, placeholderImage: UIImage(named: "defaultImage_icon"))
            self.infoTitles[InfoType.artist.rawValue].text = model.artistName ?? "-"
            self.infoTitles[InfoType.track.rawValue].text = model.trackName ?? "-"
            self.infoTitles[InfoType.collection.rawValue].text = model.collectionName ?? "-"
        }
    }
}
extension InfoTableViewCell {
    enum InfoType: Int, CaseIterable {
        case artist
        case track
        case collection
        
        var property: (image: UIImage?, font: UIFont) {
            switch self {
            case .artist:
                return (UIImage(named: "info_artist"),
                        UIFont.PingFangTC(fontSize: 16, weight: .semibold))
                
            case .track:
                return (UIImage(named: "info_track"),
                        UIFont.PingFangTC(fontSize: 14, weight: .medium))
                
            case .collection:
                return (UIImage(named: "info_collection"),
                        UIFont.PingFangTC(fontSize: 14, weight: .regular))
            }
        }
    }
}
