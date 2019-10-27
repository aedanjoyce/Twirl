//
//  HomeView.swift
//  Twirl
//
//  Created by Aedan Joyce on 6/15/18.
//  Copyright © 2018 Aedan Joyce. All rights reserved.
//

import UIKit
import RealmSwift
import Hero

protocol HomeViewDelegate {
    func presentAlertController(alertController: UIAlertController)
    func updateData(type: String)
    func pushView(list: TaskList)
}
// Change HomeView to Dashboard
class HomeView: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomeViewDelegate {
    weak var listCollectionView: ListCollectionView?
    func presentAlertController(alertController: UIAlertController) {
        present(alertController, animated: true, completion: nil)
    }
    lazy var taskCreator: TaskCreator = {
       let taskCreator = TaskCreator()
        taskCreator.delegate = self
        return taskCreator
    }()
    func createTaskList() {
        taskCreator.type = TaskType.taskList
        taskCreator.launchView()
    }
    func createReminder() {
        taskCreator.type = TaskType.reminder
        taskCreator.launchView()
    }
    func pushView(list: TaskList) {
        let taskView = TaskListController()
        taskView.selectedList = list
        taskView.homeView = self
        taskView.listCollectionView = self.listCollectionView
        navigationController?.pushViewController(taskView, animated: true)
    }
    func updateData(type: String) {
        if type == TaskType.taskList {
            if let listView = collectionView?.cellForItem(at: IndexPath(item: 0, section: 0)) as? ListCollectionView {
                listView.updateData()
            }
        } else {
            
        }
    }
    private let cellId = "cellId"
    private let reminderCellId = "reminderCellId"
    private let headerId = "headerId"
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.customMidGrey
        view.backgroundColor = .customMidGrey
        collectionView?.backgroundColor = .customMidGrey
        collectionView?.register(ListCollectionView.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(ReminderCollectionView.self, forCellWithReuseIdentifier: reminderCellId)
        navigationController?.navigationBar.shadowImage = UIImage()
        collectionView?.isPagingEnabled = true
        //collectionView?.contentInset = UIEdgeInsetsMake(tot, 0, 0, 0)
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        configureNavBar()
        collectionView?.reloadData()
        
        //self.hero.modalAnimationType = .autoReverse(presenting: .push(direction: .right))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    lazy var menuBar: Menubar = {
        let menuBar = Menubar()
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        menuBar.viewManager = self
        menuBar.backgroundColor = UIColor.customMidGrey
        return menuBar
    }()
    fileprivate func configureNavBar() {
        let navBar = navigationController?.navigationBar
        navigationController?.navigationBar.addSubview(menuBar)
        menuBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            let listCollectionView = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ListCollectionView
            listCollectionView.homeViewDelegate = self
            listCollectionView.homeView = self
            return listCollectionView
        case 1:
            let reminderCollectionView = collectionView.dequeueReusableCell(withReuseIdentifier: reminderCellId, for: indexPath) as! ReminderCollectionView
            reminderCollectionView.homeViewDelegate = self
            return reminderCollectionView
        default:
            fatalError()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = self.navigationController?.navigationBar.frame.height
        let sbHeight = UIApplication.shared.statusBarFrame.height
        let tot = height! + sbHeight + 20
        return CGSize(width: view.frame.width, height: view.frame.height - tot)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
}
extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?,left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, centerX: NSLayoutXAxisAnchor?, centerY: NSLayoutYAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
extension UIColor {
    open class var customLightGrey: UIColor { get{return UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)}}
    open class var customMidGrey: UIColor { get{return UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.0)}}
    open class var customDarkGrey: UIColor { get{return UIColor(red:0.45, green:0.51, blue:0.57, alpha:1.0)}}
    open class var menuPurple: UIColor { get{return UIColor(red:0.29, green:0.49, blue:1.00, alpha:1.0)}}
    open class var selectedGrey: UIColor { get{return UIColor(red:0.89, green:0.89, blue:0.89, alpha:1.0)}}
    open class var chargeGreen: UIColor { get{return UIColor(red:0.34, green:0.91, blue:0.48, alpha:1.0)}}
}
