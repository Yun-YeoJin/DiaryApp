//
//  FileManager+Extension.swift
//  DiaryApp
//
//  Created by 윤여진 on 2022/08/24.
//

import UIKit

extension UIViewController {
    
    func loadImageFromDocument(_ fileName: String) -> UIImage? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil } //Document 경로
        let fileURL = documentDirectory.appendingPathComponent(fileName) // 세부경로, 이미지 저장할 위치
        
        //이 위치에 있는 이미지를 담는다.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            return UIImage(systemName: "star.fill")
        }
    }
        
        
        func removeImageFromDocument(_ fileName: String) {
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return } //Document 경로
            let fileURL = documentDirectory.appendingPathComponent(fileName) // 세부경로, 이미지 저장할 위치
            
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch let error {
                print(error)
            }
        }
        
        func saveImageToDocument(_ fileName: String, image: UIImage) {
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return } //Document 경로
            let fileURL = documentDirectory.appendingPathComponent(fileName) // 세부경로, 이미지 저장할 위치
            guard let data = image.jpegData(compressionQuality: 0.5) else { return }
            
            do{
                try data.write(to: fileURL)
            } catch let error {
                print("file save error", error)
            }
        }
        
}
