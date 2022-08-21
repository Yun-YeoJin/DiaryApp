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
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
    }
    
    let imageButton = UIButton().then {
        $0.setTitle("선택하러가기", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.darkGray.cgColor
        $0.clipsToBounds = true
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [mainImageView, titleTextField, dateTextField, detailTextView, imageButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.centerX.equalTo(self)
            make.width.equalTo(UIScreen.main.bounds.width - 60)
            make.height.equalTo(UIScreen.main.bounds.height / 4.5)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(mainImageView.snp.bottom).offset(12)
            make.width.equalTo(mainImageView.snp.width)
            make.height.equalTo((UIScreen.main.bounds.height / 5.5) / 4)
        }
        
        dateTextField.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(titleTextField.snp.bottom).offset(12)
            make.width.equalTo(mainImageView.snp.width)
            make.height.equalTo((UIScreen.main.bounds.height / 5.5) / 4)
        }
        
        detailTextView.snp.makeConstraints { make in
            make.top.equalTo(dateTextField.snp.bottom).offset(20)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
            make.width.equalTo(mainImageView.snp.width)
            make.centerX.equalTo(self)
        }
        
        imageButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(mainImageView).offset(-8)
        }
    }
}
