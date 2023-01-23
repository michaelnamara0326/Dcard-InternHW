//
//  InfoTableViewCell.swift
//  Dcard-InternHW
//
//  Created by Michael Namara on 2023/1/21.
//

import UIKit

class InfoTableViewCell: UITableViewCell {
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
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
        contentView.addSubviews([albumImageView, infoStackView])
        
    }
    func configure(model: ItuneStroeModel.Result) {
        
    }
}
