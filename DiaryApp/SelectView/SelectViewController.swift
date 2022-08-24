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
    
    var selectImage: UIImage?
    var selectIndexPath: IndexPath?
    
    var delegate: SelectImageDelegate?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.BaseColor.background
        
        navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(saveButtonClicked))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(closeButtonClicked))
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.searchBar.delegate = self
        
        mainView.collectionView.register(SelectCollectionViewCell.self, forCellWithReuseIdentifier: SelectCollectionViewCell.reusableIdentifier)
        mainView.collectionView.collectionViewLayout = collectionViewLayout()
        
  
         
        //서버 통신하기 전에 interaction 막기 - 통신 중에
        //view.isUserInteractionEnabled = false
        //mainView.collectionView.isUserInteractionEnabled = false
    }
    
    //3. NotificationCenter.default.post를 이용한 이미지 값 보내기
    @objc func saveButtonClicked() {
        
        //NotificationCenter.default.post(name: .unsplashImage, object: nil, userInfo: ["image": unsplashImage ?? ""])
        
        guard let selectImage = selectImage else {
            showAlertMessage(title: "사진을 선택해주세요", buttonTitle: "OK")
            return
        }
        
        delegate?.sendImageData(image: selectImage)
        
        dismiss(animated: true)
    }
    @objc func closeButtonClicked() {
        
        dismiss(animated: true)
        
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
        
        cell.layer.borderWidth = selectIndexPath == indexPath ? 4 : 0
        cell.layer.borderColor = selectIndexPath == indexPath ? UIColor.yellow.cgColor : nil
        
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
    
    // isUserInteractionEnabled & JGprogressHHUD Loading 이용
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? SelectCollectionViewCell else { return }
        selectImage = cell.unsplashImageView.image
        
        selectIndexPath = indexPath
        collectionView.reloadData()
        
        //unsplashImage = imageList[indexPath.item]
        self.view.makeToast("\(indexPath.item)번째 사진이 선택되었습니다.", duration: 1, position: .center)
    }
    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        print(#function)
//        selectIndexPath = nil
//        selectImage = nil
//        collectionView.reloadData()
//
//    }
    
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
