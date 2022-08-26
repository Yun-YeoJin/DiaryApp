//
//  UserDiaryRepository.swift
//  DiaryApp
//
//  Created by 윤여진 on 2022/08/26.
//

import UIKit

import RealmSwift

class UserDiaryRepository {
    
    let localRealm = try! Realm()
    
    //MARK: 이미지 문서로부터 삭제하기
    func removeImageFromDocument(_ fileName: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return } //Document 경로
        let fileURL = documentDirectory.appendingPathComponent(fileName) // 세부경로, 이미지 저장할 위치
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch let error {
            print(error)
        }
    }
    
    func fetch() -> Results<UserDiary> {
        return localRealm.objects(UserDiary.self).sorted(byKeyPath: "diaryTitle", ascending: false)
    }
    
    func fetchSort(_ sort: String) -> Results<UserDiary> {
        return localRealm.objects(UserDiary.self).sorted(byKeyPath: sort, ascending: true)
    }
    
    func fetchFilter() -> Results<UserDiary> {
        return localRealm.objects(UserDiary.self).filter("diaryTitle CONTAINS[c] '6'")
    }
    
    func updateFavorite(_ item: UserDiary) {
        
        //realm data update
        try! self.localRealm.write{
            
            //MARK: 하나의 레코드에서 특정 컬럼 하나만 변경
            item.favorite = !item.favorite
            //self.task[indexPath.row].favorite = !self.task[indexPath.row].favorite
            item.favorite.toggle()
            
            //MARK: 하나의 테이블에 특정 컬럼 전체 값을 변경
            //self.tasks.setValue(true, forKey: "favorite")
            
            //MARK: 하나의 레코드에서 여러 컬럼들이 변경
            //self.localRealm.create(UserDiary.self, value: ["objectID": self.tasks[indexPath.row].objectID, "diaryContents": "변경 테스트", "diaryTitle": "제목 테스트"], update: .modified)
            
            print("Realm Update Success")
        }
    }
    func delete(_ item: UserDiary) {
        
        removeImageFromDocument("\(item.objectID).jpg")
        //Realm에 있는 정보가 먼저 지워지면 removeImageFromDocument가 실행이 안되기 때문에 순서가 중요하다.
        
        try! self.localRealm.write {
            self.localRealm.delete(item)
        }
    }
}
