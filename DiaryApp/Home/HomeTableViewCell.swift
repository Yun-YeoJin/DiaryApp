//
//  HomeTableViewCell.swift
//  DiaryApp
//
//  Created by 윤여진 on 2022/08/24.
//

import UIKit

import SnapKit
import Then

class HomeTableViewCell: BaseTableViewCell {
    
    let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .left
        $0.font = .boldSystemFont(ofSize: 17)
    }
    
    let contentsLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 15)
    }
    
    let registDateLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .left
        $0.font = .boldSystemFont(ofSize: 15)
    }
    
    let diaryImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.clear.cgColor
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [titleLabel, contentsLabel, registDateLabel, diaryImageView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalTo(0)
            make.height.equalTo(20)
        }
        registDateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(0)
            make.height.equalTo(20)
        }
        contentsLabel.snp.makeConstraints { make in
            make.top.equalTo(registDateLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(0)
            make.height.equalTo(20)
        }
        
        diaryImageView.snp.makeConstraints { make in
            make.top.bottom.equalTo(0)
            make.trailing.equalTo(10)
            make.height.width.equalTo(150)
        }
    }
    
}
