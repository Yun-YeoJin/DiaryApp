//
//  SelectCollectionViewCell.swift
//  DiaryApp
//
//  Created by 윤여진 on 2022/08/21.
//

import UIKit

import SnapKit
import Then

class SelectCollectionViewCell: BaseCollectionViewCell {
    
    let unsplashImageView = UIImageView().then {
        $0.backgroundColor = .clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        self.addSubview(unsplashImageView)
    }
    
    override func setConstraints() {
        
        unsplashImageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(0)
        }
        
    }
    
}
