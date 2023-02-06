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
    private var isPlaying: Bool = false
    
    private let collectionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let fadeView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.4
        return view
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
        stackView.spacing = 4
        stackView.distribution = .equalSpacing
        stackView.isUserInteractionEnabled = true
        return stackView
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "music_play"), for: .normal)
        button.addTarget(self, action: #selector(playButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var musicPlayer: AVPlayer = {
        guard let url = model.previewUrl else { return AVPlayer() }
        let player = AVPlayer(url: url)
        return player
    }()

    private lazy var artistView = DetailInfoView(main: "歌手", value: model.artistName ?? "-")
    private lazy var collectionView = DetailInfoView(main: "收錄專輯", value: model.collectionName ?? "-")
    private lazy var trackView = DetailInfoView(main: "歌曲名稱", value: model.trackName ?? "-", moreButtonHide: true)
    private lazy var releaseDateView = DetailInfoView(main: "發行日期", value: model.releaseDate?.customDateFormat(to: "yyyy/MM/dd") ?? "-", moreButtonHide: true)
    
    init(model: ItuneStroeModel.Result) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
        NotificationCenter.default.addObserver(self, selector: #selector(musicPlayerWhenFinish), name: .AVPlayerItemDidPlayToEndTime, object: musicPlayer.currentItem)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubviews([collectionImageView, titleLabel, detailInfoStackView])
        detailInfoStackView.addArrangeSubviews([artistView, collectionView, trackView,  releaseDateView])
        collectionImageView.addSubview(fadeView)
        collectionImageView.insertSubview(playButton, aboveSubview: fadeView)
        
        collectionImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(375)
        }
        fadeView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalToSuperview()
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
        playButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(60)
        }

    }
    private func configure(){
        artistView.delegate = self
        collectionView.delegate = self
        collectionImageView.sd_setImage(with: model.artworkUrl100)
    }
    @objc private func playButtonDidTap(_ sender: UIButton) {
        if !isPlaying {
            musicPlayer.play()
            sender.setImage(UIImage(named: "music_pause"), for: .normal)
        } else {
            musicPlayer.pause()
            sender.setImage(UIImage(named: "music_play"), for: .normal)
        }
        isPlaying.toggle()
    }
    @objc private func musicPlayerWhenFinish(_ notification: Notification) {
        isPlaying = false
        playButton.setImage(UIImage(named: "music_play"), for: .normal)
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
