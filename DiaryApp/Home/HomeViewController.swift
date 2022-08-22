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
    
    let tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    var tasks: Results<UserDiary>!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //3. 접근하기 : Realm 데이터를 정렬해 tasks에 담기
        tasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: "diaryDate", ascending: false) //date를 기준으로 정렬
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star.fill"), style: .plain, target: self, action: #selector(starButtonClicked))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 화면 갱신은 화면 전환 코드 및 생명 주기 실행 점검 필요!
        // present, overCurrentContext, overFullScreen -> ViewWillAppear가 실행이 안된다.
        tasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: "diaryDate", ascending: false)
        tableView.reloadData()
    }
    
    @objc func starButtonClicked() {
        let vc = MainViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = tasks[indexPath.row].diaryTitle
        return cell
    }
    
}
