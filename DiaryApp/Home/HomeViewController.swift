//
//  HomeViewController.swift
//  DiaryApp
//
//  Created by 윤여진 on 2022/08/22.
//

import UIKit
import SnapKit

//1. import하기
import RealmSwift

class HomeViewController: BaseViewController {
    
    let localRealm = try! Realm() //2.불러주기
    //지연 저장
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.backgroundColor = .lightGray
        view.rowHeight = 60
        return view
    }() // 즉시 실행 클로저
    
    var tasks: Results<UserDiary>! {
        didSet {
            // 화면 갱신은 화면 전환 코드 및 생명 주기 실행 점검 필요!
            tableView.reloadData()
            print("Tasks Changed")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //3. 접근하기 : Realm 데이터를 정렬해 tasks에 담기
        requestRealm()
        
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        let alignButton = UIBarButtonItem(image: UIImage(systemName: "text.alignleft"), style: .plain, target: self, action: #selector(alignButtonClicked))
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "camera.filters"), style: .plain, target: self, action: #selector(filterButtonClicked))
        
        navigationItem.leftBarButtonItems = [alignButton, filterButton]
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star.fill"), style: .plain, target: self, action: #selector(starButtonClicked))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // present, overCurrentContext, overFullScreen -> ViewWillAppear가 실행이 안된다.
        requestRealm()
        //tableView.reloadData() -> 위에서 didSet 해줘서 안해줘도 됨
    }
    
    func requestRealm() {
        tasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: "diaryTitle", ascending: false)
    }
    
    @objc func starButtonClicked() {
        let vc = MainViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc func alignButtonClicked() {
        
        tasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: "registDate", ascending: true)
        //tableView.reloadData()
        
    }
    
    //Realm filter query, NSPredicate
    @objc func filterButtonClicked() {
        
        tasks = localRealm.objects(UserDiary.self).filter("diaryTitle CONTAINS[c] '6'")
            // .filter("diaryTitle = '오늘의 일기761'") <=> String 비교할 때는 작은 따옴표 안에 들어가야함.
        
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = tasks[indexPath.row].diaryTitle
        cell.backgroundColor = .lightGray
        return cell
    }
    
    //참고. TableView의 Editing Mode
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favorite = UIContextualAction(style: .normal, title: "즐겨찾기") { action, view, completionHandler in
            
            //realm data update
            try! self.localRealm.write{
                //MARK: 하나의 레코드에서 특정 컬럼 하나만 변경
                self.tasks[indexPath.row].favorite = !self.tasks[indexPath.row].favorite
                
                //MARK: 하나의 테이블에 특정 컬럼 전체 값을 변경
                //self.tasks.setValue(true, forKey: "favorite")
                
                //MARK: 하나의 레코드에서 여러 컬럼들이 변경
                //self.localRealm.create(UserDiary.self, value: ["objectID": self.tasks[indexPath.row].objectID, "diaryContents": "변경 테스트", "diaryTitle": "제목 테스트"], update: .modified)
                
                print("Realm Update Success")
            }
            
            //1. 스와이프한 셀 하나만 ReloadRows 코드를 구현 => 상대적 효율성
            //2. 데이터가 변경되었으니 다시 realmd에서 데이터를 가지고 오기 => didSet 일관적 형태로 갱신
            self.requestRealm()
            
            
        }
        
        let image = tasks[indexPath.row].favorite ? "star.fill" : "star"
        favorite.image = UIImage(systemName: image)
        favorite.backgroundColor = .systemMint
        
        return UISwipeActionsConfiguration(actions: [favorite])
    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//        let favorite = UIContextualAction(style: .normal, title: "즐겨찾기") { action, view, completionHandler in
//
//            print("favorite Button Clicked")
//        }
//
//        let example = UIContextualAction(style: .normal, title: "예시") { action, view, completionHandler in
//
//            print("example Button Clicked")
//        }
//
//        return UISwipeActionsConfiguration(actions: [favorite, example])
//    }
}
