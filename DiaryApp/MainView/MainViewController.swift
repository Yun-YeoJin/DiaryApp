//
//  MainViewController.swift
//  DiaryApp
//
//  Created by 윤여진 on 2022/08/21.
//

import UIKit
import Kingfisher
import RealmSwift

//1. Notification Name 설정
extension Notification.Name {
    static let unsplashImage = NSNotification.Name("unsplashImage")
}

class MainViewController: BaseViewController {

    let localRealm = try! Realm() //Realm 테이블에 데이터를 CRUD할 때, Realm 테이블 경로에 접근
    let mainView = MainView()
    
    override func loadView() {
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //2. Notification Observer 추가
        NotificationCenter.default.addObserver(self, selector: #selector(NotificationObserver), name: .unsplashImage, object: nil)
        
        print("Realm is located at:", localRealm.configuration.fileURL!)
        
        navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "목록", style: .plain, target: self, action: #selector(listButtonClicked))
        
    }
    
    @objc func listButtonClicked() {
    
    
    }
    
    @objc func saveButtonClicked() {
        let task = UserDiary(diaryTitle: "\(mainView.titleTextField.text ?? "")", contents: "\(mainView.detailTextView.text ?? "")", diaryDate: "\(mainView.dateTextField.text ?? "")", registDate: Date(), photo: nil) // => Record를 추가하는 과정
        
        try! localRealm.write {
            localRealm.add(task) // => Create 하는 과정
            print("Realm Succeed")
            self.dismiss(animated: true)
        }
        
        let vc = HomeViewController()
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true)
        
    }
     
    //4. Notification Observer의 이미지 전달 받기
    @objc func NotificationObserver(_ notification: Notification) {
        
        if let image = notification.userInfo?["image"] as? String {
            self.mainView.mainImageView.kf.setImage(with: URL(string: image))
        }
        
    }
    
    override func configureUI() {
    
        navigationItem.title = "윤기사의 일기장"
        mainView.imageButton.addTarget(self, action: #selector(imageButtonClicked), for: .touchUpInside)
       

    }

    
    
    @objc func imageButtonClicked() {
        
        let vc = SelectViewController()
        
        navigationController?.pushViewController(vc, animated: true)
        
    }


}
