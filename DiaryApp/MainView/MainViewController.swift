//
//  MainViewController.swift
//  DiaryApp
//
//  Created by 윤여진 on 2022/08/21.
//

import UIKit
import Kingfisher

//1. Notification Name 설정
extension Notification.Name {
    static let unsplashImage = NSNotification.Name("unsplashImage")
}

class MainViewController: BaseViewController {

    var mainView = MainView()
    
    override func loadView() {
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //2. Notification Observer 추가
        NotificationCenter.default.addObserver(self, selector: #selector(NotificationObserver), name: .unsplashImage, object: nil)
        
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
