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

protocol SelectImageDelegate {
    func sendImageData(image: UIImage)
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonClicked))
        
        print("Realm 저장위치=\n\(Realm.Configuration.defaultConfiguration.fileURL!)\n")
         
    }
    
    @objc func cancelButtonClicked() {
        
        dismiss(animated: true)
    
    }
    
    @objc func saveButtonClicked() {
        
        guard let title = mainView.titleTextField.text else {
            showAlertMessage(title: "제목을 입력해주세요", buttonTitle: "확인")
            return
        }
        
        let task = UserDiary(diaryTitle: title, contents: mainView.detailTextView.text!, diaryDate: "\(mainView.dateTextField.text ?? "")", registDate: Date(), photo: nil) // => Record를 추가하는 과정
        
        do {
            try localRealm.write {
                localRealm.add(task)
            }
        } catch let error {
            print(error)
        }
        
        if let image = mainView.mainImageView.image {
            saveImageToDocument("\(task.objectID).jpg", image: image)
        }

        dismiss(animated: true)
        
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
        mainView.restoreButton.addTarget(self, action: #selector(restoreButtonClicked), for: .touchUpInside)
        mainView.backupButton.addTarget(self, action: #selector(backupButtonClicked), for: .touchUpInside)
    }

    
    
    @objc func imageButtonClicked() {
        
        let vc = SelectViewController()
        vc.delegate = self
        transition(vc, transitionStyle: .presentNavigation)
        
    }
    
    @objc func restoreButtonClicked() {
        
    }
    
    @objc func backupButtonClicked() {
        
    }


}

extension MainViewController: SelectImageDelegate {
    
    //언제 실행이 되면 될까?
    func sendImageData(image: UIImage) {
        mainView.mainImageView.image = image
        print(#function)
    }
}
