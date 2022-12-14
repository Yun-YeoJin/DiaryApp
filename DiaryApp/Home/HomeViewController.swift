//
//  HomeViewController.swift
//  DiaryApp
//
//  Created by 윤여진 on 2022/08/22.
//

import UIKit
import SnapKit
import Then

//1. import하기
import RealmSwift

class HomeViewController: BaseViewController {
    
    let repository = UserDiaryRepository()
    
    let localRealm = try! Realm() //2.불러주기
    //지연 저장
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.reusableIdentifier)
        view.backgroundColor = .lightGray
        view.rowHeight = 60
        return view
    }()
    
  

    var tasks: Results<UserDiary>! {
        didSet {
            // 화면 갱신은 화면 전환 코드 및 생명 주기 실행 점검 필요!
            tableView.reloadData()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        //3. 접근하기 : Realm 데이터를 정렬해 tasks에 담기
        requestRealm()
        
        fetchDocumentZipFile()
        
        view.addSubview(tableView)
    
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
      
        navigationController?.navigationBar.tintColor = .white
        
        let alignButton = UIBarButtonItem(image: UIImage(systemName: "text.alignleft"), style: .plain, target: self, action: #selector(alignButtonClicked))
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "camera.filters"), style: .plain, target: self, action: #selector(filterButtonClicked))
        
        navigationItem.leftBarButtonItems = [alignButton, filterButton]

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonClicked))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // present, overCurrentContext, overFullScreen -> ViewWillAppear가 실행이 안된다.
        requestRealm()
        //tableView.reloadData() -> 위에서 didSet 해줘서 안해줘도 됨
    }
    
    func requestRealm() {
        //Realm 데이터를 정렬해 tasks에 담기
        tasks = repository.fetch()
    }
    
    @objc func plusButtonClicked() {
 
        let vc = MainViewController()
        transition(vc, transitionStyle: .presentFullNavigation)
        
        
    }
    
    @objc func alignButtonClicked() {
        
        tasks = repository.fetchSort("registDate")
    
        
    }
    
    //Realm filter query, NSPredicate
    @objc func filterButtonClicked() {
        
        tasks = repository.fetchFilter()
            // .filter("diaryTitle = '오늘의 일기761'") <=> String 비교할 때는 작은 따옴표 안에 들어가야함.
        
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        cell.titleLabel.text = tasks[indexPath.row].diaryTitle
        cell.contentsLabel.text = tasks[indexPath.row].contents
        cell.registDateLabel.text = tasks[indexPath.row].diaryDate
        cell.backgroundColor = .lightGray
        cell.diaryImageView.image = loadImageFromDocument("\(tasks[indexPath.row].objectID).jpg")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = MainViewController()
        self.present(vc, animated: true)
        
    }
    
    //참고. TableView의 Editing Mode
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favorite = UIContextualAction(style: .normal, title: "즐겨찾기") { action, view, completionHandler in
            
           
            self.repository.updateFavorite(self.tasks[indexPath.row])
            self.requestRealm()
 
        }
        
        let image = tasks[indexPath.row].favorite ? "star.fill" : "star"
        favorite.image = UIImage(systemName: image)
        favorite.backgroundColor = .systemMint
        
        return UISwipeActionsConfiguration(actions: [favorite])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: "삭제") { action, view, completionHandler in
            
            self.repository.delete(self.tasks[indexPath.row])
        
            self.requestRealm()
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        if editingStyle == .delete {
//
//            try! localRealm.write {
//                localRealm.delete(tasks[indexPath.row])
//            }
//        }
//
//        tableView.reloadData()
//
//    }
}
