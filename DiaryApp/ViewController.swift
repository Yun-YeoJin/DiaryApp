//
//  ViewController.swift
//  DiaryApp
//
//  Created by 윤여진 on 2022/08/21.
//

import UIKit

import Zip

class ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    func backupButtonClicked() {
        
        var urlPaths = [URL]()
        
        //MARK: 1. Document 위치에 백업할 파일이 존재하는지 확인
        guard let path = documentDirectoryPath() else {
            showAlertMessage(title: "도큐먼트 위치에 오류가 있습니다")
            return
        }
        // realmFile의 경로를 찾는 과정
        let realmFile = path.appendingPathComponent("default.realm")
        // 경로에 백업 파일이 존재하는지 확인하는 과정
        guard FileManager.default.fileExists(atPath: realmFile.path) else {
            showAlertMessage(title: "백업할 파일이 없습니다.")
            return
        }
        
        urlPaths.append(URL(string: realmFile.path)!)
        
        //백업 파일이 있다면 압축 : URL -> Zip opensourceLibrary 사용
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "SeSACDiary_1") // 파일 이름
            print("Archive Location: \(zipFilePath)")
            
            //ActivityViewController - 성공을 했을 때만 띄워줘야 하기 때문
            showActivityViewController()
            
        }
        catch {
           showAlertMessage(title: "압축에 실패했습니다.")
        }
    }
    
    func showActivityViewController() {
        
        guard let path = documentDirectoryPath() else {
            showAlertMessage(title: "도큐먼트 위치에 오류가 있습니다")
            return
        }
        // realmFile의 경로를 찾는 과정
        let backupFileURL = path.appendingPathComponent("SeSACDiary_1.zip") //별도의 경로를 가져올 때, 확장자까지 작성해야함.
        
        let vc = UIActivityViewController(activityItems: [backupFileURL], applicationActivities: [] )
        self.present(vc, animated: true)
    }
    
    func restoreButtonClicked() {
        
    }

}

