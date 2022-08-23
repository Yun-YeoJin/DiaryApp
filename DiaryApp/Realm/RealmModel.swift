//
//  RealmModel.swift
//  DiaryApp
//
//  Created by 윤여진 on 2022/08/22.
//

import UIKit
import RealmSwift

// UserDiary: 테이블 이름
// @Persisted : 컬럼

class UserDiary: Object {
    
    @Persisted var diaryTitle: String //제목(필수)
    @Persisted var contents: String?//내용(옵션)
    @Persisted var diaryDate: String //작성 날짜(필수)
    @Persisted var registDate = Date() //등록 날짜(필수)
    @Persisted var favorite: Bool //즐겨찾기(필수)
    @Persisted var photo: String?//사진String(옵션)
    
    //PK(primary key) : Int, UUID(16byte), ObjectID(12byte)
    @Persisted(primaryKey: true) var objectID: ObjectId
    
    convenience init(diaryTitle: String, contents: String, diaryDate: String, registDate: Date, photo: String?) {
        self.init()
        self.diaryTitle = diaryTitle
        self.contents = contents
        self.diaryDate = diaryDate
        self.registDate = registDate
        self.favorite = false
        self.photo = photo
    }
    
}
