//
//  MainView.swift
//  DiaryApp
//
//  Created by 윤여진 on 2022/08/21.
//

import UIKit

import Then
import SnapKit

class MainView: BaseView {
    
    let mainImageView = UIImageView().then {
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
    }
    
    let titleTextField = UITextField().then {
        $0.backgroundColor = .white
        $0.attributedPlaceholder = NSAttributedString(string: "제목을 입력해주세용!", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    let dateTextField = UITextField().then {
        $0.backgroundColor = .white
        $0.attributedPlaceholder = NSAttributedString(string: "날짜를 입력하세용!", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    let detailTextView = UITextView().then {
        $0.backgroundColor = .white
        $0.font = .systemFont(ofSize: 15)
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
    }
    
    let imageButton = UIButton().then {
        $0.setImage(UIImage(systemName: "photo"), for: .normal)
        $0.tintColor = Constants.BaseColor.text
        $0.backgroundColor = Constants.BaseColor.point
        $0.layer.cornerRadius = 25
        $0.clipsToBounds = true
        
    }
    
    let sampleButton = UIButton().then {
        $0.backgroundColor = .green
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [mainImageView, titleTextField, dateTextField, detailTextView, imageButton, sampleButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        sampleButton.snp.makeConstraints { make in
            make.trailing.top.equalTo(self.safeAreaLayoutGuide)
            make.width.height.equalTo(50)
        }
        
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(12)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(self.snp.width).multipliedBy(0.75)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(12)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(55)
        }
        
        dateTextField.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(12)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(55)
        }
        
        detailTextView.snp.makeConstraints { make in
            make.top.equalTo(dateTextField.snp.bottom).offset(12)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-12)
        }
        
        imageButton.snp.makeConstraints { make in
            make.trailing.equalTo(mainImageView.snp.trailing).offset(-12)
            make.bottom.equalTo(mainImageView.snp.bottom).offset(-12)
            make.width.height.equalTo(50)
        }
    }
}

