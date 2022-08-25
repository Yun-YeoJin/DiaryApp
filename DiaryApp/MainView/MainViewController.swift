//
//  MainViewController.swift
//  DiaryApp
//
//  Created by 윤여진 on 2022/08/21.
//

import UIKit
import Kingfisher
import RealmSwift
import Zip
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
    //MARK: 복구(Restore) 버튼 클릭시
    @objc func restoreButtonClicked() {
        
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        self.present(documentPicker, animated: true)
        
        
    }
    
    //MARK: 백업(Backup) 버튼 클릭시
    @objc func backupButtonClicked() {
        
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
    
}

extension MainViewController: SelectImageDelegate {
    
    //언제 실행이 되면 될까?
    func sendImageData(image: UIImage) {
        mainView.mainImageView.image = image
        print(#function)
    }
}

//MARK: DocumentPickerDelegate
extension MainViewController: UIDocumentPickerDelegate {
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print(#function)
    }
    
    //MARK: Document 선택 시
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let selectedFileURL = urls.first else { //URL의 first를 통해 어떤 파일을 선택했는지
            showAlertMessage(title: "선택하신 파일을 찾을 수 없습니다.")
            return
        }
        //Document 위치 확인
        guard let path = documentDirectoryPath() else {
            showAlertMessage(title: "도큐먼트 위치에 오류가 있습니다")
            return
        }
        
        let sandboxFileURL = path.appendingPathComponent(selectedFileURL.lastPathComponent) //가장 마지막 생성된 것 가져옴
        
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            
            let fileURL = path.appendingPathComponent("SeSACDiary_1.zip")
            
            do { //Zip 파일 해제
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progree: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("unzippedFile: \(unzippedFile)")
                    self.showAlertMessage(title: "복구가 완료되었습니다.")
                })
            } catch {
                showAlertMessage(title: "압축 해제에 실패했습니다.")
            }
            
        } else {
            
            do {
                //파일 앱의 zip -> Document 폴더에 복사
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                
                let fileURL = path.appendingPathComponent("SeSACDiary_1.zip")
                
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progree: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("unzippedFile: \(unzippedFile)")
                    self.showAlertMessage(title: "복구가 완료되었습니다.")
                })
                
            } catch {
                showAlertMessage(title: "압축 해제에 실패했습니다.")
            }
            
        }
    }
    
}
