//
//  SelectView.swift
//  DiaryApp
//
//  Created by 윤여진 on 2022/08/21.
//

import UIKit

import Then
import SnapKit

class SelectView: BaseView {
    
    let searchBar = UISearchBar().then {
        $0.tintColor = .black
    }
    
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        return view
    }()
    // 왜 Then으로 frame이랑 collectionViewLayout 값을 주면 작동을 안할까...?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [searchBar, collectionView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalTo(0)
            make.height.equalTo(44)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.leading.trailing.equalTo(0)
        }
    }

}
