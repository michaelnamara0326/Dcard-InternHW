//
//  DetailInfoViewController.swift
//  Dcard-InternHW
//
//  Created by Michael Namara on 2023/1/26.
//

import UIKit
import AVKit

class DetailInfoViewController: UIViewController {
    private let model: ItuneStroeModel.Result
    private let collectionImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "詳細資訊"
        label.textColor = .customBlack
        label.font = UIFont.PingFangTC(fontSize: 18, weight: .Semibold)
        return label
    }()
    
    private let detailInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.isUserInteractionEnabled = true
        return stackView
    }()
    
    private lazy var avPlayer: AVPlayer = {
        guard let url = model.previewUrl else { return AVPlayer() }
        let player = AVPlayer(url: url)
        return player
    }()

    private lazy var artistView = DetailInfoView(main: "歌手", value: model.artistName ?? "-")
    private lazy var trackView = DetailInfoView(main: "歌曲", value: model.trackName ?? "-")
    private lazy var collectionView = DetailInfoView(main: "收錄專輯", value: model.collectionName ?? "-")
    private lazy var releaseDateView = DetailInfoView(main: "發行日期", value: model.releaseDate?.customDateFormat(to: "yyyy/MM/dd") ?? "-")
    
    init(model: ItuneStroeModel.Result) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubviews([collectionImageView, titleLabel, detailInfoStackView])
        detailInfoStackView.addArrangeSubviews([artistView, trackView, collectionView, releaseDateView])
        
        collectionImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(375)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionImageView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        detailInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-8)
        }

    }
    private func configure(){
        artistView.delegate = self
        trackView.delegate = self
        collectionImageView.sd_setImage(with: model.artworkUrl100)
    }

}
extension DetailInfoViewController {
    enum Detail: String, CaseIterable {
        case artist = "歌手"
        case track = "歌曲名稱"
        case collection = "專輯"
        case releaseDate = "發行日期"
    }
}
extension DetailInfoViewController: moreButtonDelegate {
    func didTapMoreButton() {
        // todo: present preview webview
        print("did tap")
    }
}
