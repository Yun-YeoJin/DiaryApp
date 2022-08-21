//
//  ReusableProtocol.swift
//  DiaryApp
//
//  Created by 윤여진 on 2022/08/21.
//

import UIKit

protocol ReusableProtocol {
    static var reusableIdentifier: String { get }
}

extension UIViewController: ReusableProtocol {
    static var reusableIdentifier: String {
        String(describing: self)
    }
}

extension UITableViewCell: ReusableProtocol {
    static var reusableIdentifier: String {
        String(describing: self)
    }
}

extension UICollectionViewCell: ReusableProtocol {
    static var reusableIdentifier: String {
        String(describing: self)
    }
}
