//
//  DetailInfoViewController.swift
//  Dcard-InternHW
//
//  Created by Michael Namara on 2023/1/26.
//

import UIKit
import AVKit
import RxSwift

class DetailInfoViewController: UIViewController {
    //  MARK: - Init Property
    private let model: ItunesResultModel
    private let disposeBag = DisposeBag()
    private var isPlaying: Bool = false
    
    //  MARK: - View Property
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
        return button
    }()
    
    private lazy var musicPlayer: AVPlayer = {
        guard let url = model.previewURL else {
            self.showAlert(title: "無法播放音樂", message: "請稍後再試")
            self.playButton.isEnabled = false
            return AVPlayer()
        }
        let player = AVPlayer(url: url)
        return player
    }()

    private lazy var artistInfoView = DetailInfoView(main: "歌手", content: model.artistName ?? "-")
    private lazy var collectionInfoView = DetailInfoView(main: "收錄專輯", content: model.collectionName ?? "-")
    private lazy var trackInfoView = DetailInfoView(main: "歌曲名稱", content: model.trackName ?? "-", moreButtonHide: true)
    private lazy var releaseDateInfoView = DetailInfoView(main: "發行日期", content: model.releaseDate?.customDateFormat(to: "yyyy/MM/dd") ?? "-", moreButtonHide: true)
    
    //  MARK: - View Cycle
    init(model: ItunesResultModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
        configure()
        
        // avoid when phone on silent mode
        try! AVAudioSession.sharedInstance().setCategory(.playback)
    }
    
    //  MARK: - Functions
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubviews([collectionImageView, fadeView, playButton, titleLabel, detailInfoStackView])
        detailInfoStackView.addArrangeSubviews([artistInfoView, collectionInfoView, trackInfoView,  releaseDateInfoView])
        
        collectionImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(view.frame.height / 2)
        }
        fadeView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(collectionImageView)
        }
        playButton.snp.makeConstraints { make in
            make.center.equalTo(collectionImageView)
            make.height.width.equalTo(60)
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
    
    private func setupBinding() {
        let mergeEvent = Observable.merge(
            NotificationCenter.default.rx.notification(.AVPlayerItemDidPlayToEndTime).map({ _ in "Notification"}),
            playButton.rx.tap.map({"Button"}))
        
        mergeEvent.subscribe(onNext: { [weak self] _ in
            self?.handleMusicPlayer()
        }).disposed(by: disposeBag)
    }
    
    private func configure() {
        artistInfoView.delegate = self
        collectionInfoView.delegate = self
        collectionImageView.sd_setImage(with: model.artworkURL100)
    }
    
    private func handleMusicPlayer() {
        if !isPlaying {
            musicPlayer.play()
            playButton.setImage(UIImage(named: "music_pause"), for: .normal)
        } else {
            musicPlayer.pause()
            playButton.setImage(UIImage(named: "music_play"), for: .normal)
        }
        isPlaying.toggle()
    }
}

    //  MARK: - Delegate
extension DetailInfoViewController: moreButtonDelegate {
    func didTapMoreButton(title: String) {
        let url = (title == "歌手") ? model.artistViewURL : model.collectionViewURL
        let vc = PreviewViewController(title: title, url: url)
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
        if isPlaying {
            handleMusicPlayer()
        }
    }
}
