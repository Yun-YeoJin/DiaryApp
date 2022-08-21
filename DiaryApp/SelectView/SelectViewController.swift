//
//  SelectViewController.swift
//  DiaryApp
//
//  Created by 윤여진 on 2022/08/21.
//

import UIKit

import Kingfisher
import JGProgressHUD
import Toast

class SelectViewController: BaseViewController {
    
    let hud = JGProgressHUD()
    
    let mainView = SelectView()
    
    var imageList: [String] = []
    var totalPage: Int?
    
    var startPage = 1
    
    var unsplashImage: String?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.searchBar.delegate = self

        mainView.collectionView.register(SelectCollectionViewCell.self, forCellWithReuseIdentifier: SelectCollectionViewCell.reusableIdentifier)
        mainView.collectionView.collectionViewLayout = collectionViewLayout()
        
    }
    //3. NotificationCenter.default.post를 이용한 이미지 값 보내기
    @objc func saveButtonClicked() {
        
        NotificationCenter.default.post(name: .unsplashImage, object: nil, userInfo: ["image": unsplashImage ?? ""])
        navigationController?.popViewController(animated: true)
    }
    

}

extension SelectViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectCollectionViewCell.reusableIdentifier, for: indexPath) as? SelectCollectionViewCell else { return UICollectionViewCell() }
        
        
        
        cell.backgroundColor = .clear
        cell.unsplashImageView.kf.setImage(with: URL(string: imageList[indexPath.item]))
        
        return cell
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let width = (UIScreen.main.bounds.width / 3) - ((layout.minimumInteritemSpacing * 3) - (spacing * 2))
        layout.itemSize = CGSize(width: width, height: width)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        unsplashImage = imageList[indexPath.item]
        self.view.makeToast("\(indexPath.item)번째 사진이 선택되었습니다.", duration: 1, position: .center)
    }
    
}



extension SelectViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let text = searchBar.text {
            
            hud.show(in: mainView)
            
            imageList.removeAll()
            
            unsplashAPIManager.shared.requestUnsplashImage(startPage, text) { list, totalCount in
                self.imageList = list
                self.totalPage = totalCount
                
                DispatchQueue.main.async {
                    self.mainView.collectionView.reloadData()
                    self.hud.dismiss(animated: true)
                }
            }
    
        }

        mainView.endEditing(true)
    }
}

extension SelectViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if imageList.count - 1 == indexPath.item && startPage < (totalPage ?? 2) {
                
                hud.show(in: mainView)
                
                startPage += 1
                
                unsplashAPIManager.shared.requestUnsplashImage(startPage, mainView.searchBar.text ?? "") { list, total in
                    self.imageList.append(contentsOf: list)
                    self.totalPage = total
                    
                    DispatchQueue.main.async {
                        self.mainView.collectionView.reloadData()
                        self.hud.dismiss(animated: true)
                    }
                }
            }
        }
    }
    
}
