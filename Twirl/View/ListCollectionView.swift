//
//  ListCollectionView.swift
//  Twirl
//
//  Created by Aedan Joyce on 6/16/18.
//  Copyright © 2018 Aedan Joyce. All rights reserved.
//

import UIKit
import RealmSwift
import Hero
import ViewAnimator
protocol ListCollectionDelegate {
    func deleteList(list: TaskList)
}
class ListCollectionView: TwirlCollectionViewBase, UICollectionViewDataSource, ListCollectionDelegate {
    func deleteList(list: TaskList) {
        try! realmRef.write {
            realmRef.delete(list)
            self.updateData()
        }
    }
    
    private let cellId = "cellId"
    private let headerId = "headerId"
    weak var homeView: HomeView?
    //weak var viewRef: TaskView?
    var listRef: TaskList?
    var lists: Results<TaskList>!
    func updateData() {
        lists = realmRef.objects(TaskList.self)
        DispatchQueue.main.async {
            self.homeView?.collectionView?.reloadData()
            self.collectionView.reloadData()
            self.collectionView.performBatchUpdates({
            UIView.animate(views: self.collectionView.orderedVisibleCells, animations: [AnimationType.from(direction: .bottom, offset: 30.0)])
                
            }, completion: nil)
        }
        isInitialLoadComplete = true
        print("update data complete")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lists.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: frame.width, height: 125)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! ListHeaderCell
        if let taskCount = lists {
            if taskCount.count == 1 {
                header.taskCountLabel.text = "\(taskCount.count) list"
            } else {
                header.taskCountLabel.text = "\(taskCount.count) lists"
            }
            if taskCount.count == 0 {
                header.taskCountLabel.text = "\(0) lists"
            }
        }
        return header
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ListCell
        let list = lists[indexPath.row]
        cell.listCollectionDelegate = self
        cell.list = list
        cell.taskNameLabel.text = list.name
        cell.optionButton.addTarget(self, action: #selector(handleOptions(sender:)), for: .touchUpInside)
        if list.tasks.filter("isCompleted = false").count == 1 {
            cell.taskCount.text = "\(list.tasks.filter("isCompleted = false").count) task"
        } else if list.tasks.filter("isCompleted = false").count == 0 {
            cell.taskCount.text = "No tasks"
        }
        else {
            cell.taskCount.text = "\(list.tasks.filter("isCompleted = false").count) tasks"
        }
        let blue = UIColor(red:0.21, green:0.65, blue:1.00, alpha:1.0)
        let red = UIColor(red:1.00, green:0.35, blue:0.51, alpha:1.0)
        let pink = UIColor(red:1.00, green:0.60, blue:0.91, alpha:1.0)
        let purple = UIColor(red:0.51, green:0.63, blue:1.00, alpha:1.0)
        switch indexPath.row % 4 {
        case 0:
            cell.colorIndicator.backgroundColor = blue
        case 1:
            cell.colorIndicator.backgroundColor = red
        case 2:
            cell.colorIndicator.backgroundColor = pink
        case 3:
            cell.colorIndicator.backgroundColor = purple
            
        default:
            print("nil")
        }
        
        return cell
    }
    
    var isInitialLoadComplete = false
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        homeView?.listCollectionView = self
        print("called")
        if isInitialLoadComplete {
        let listToPresent = lists[indexPath.row]
        homeViewDelegate?.pushView(list: listToPresent)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ListCell else {return}
        cell.backgroundColor = .customMidGrey
    }
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ListCell else {return}
        cell.backgroundColor = .white
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width - 20, height: 80)
    }
    @objc func handleOptions(sender: UIButton) {
        let point : CGPoint = sender.convert(CGPoint.zero, to:collectionView)
        let indexPath = collectionView.indexPathForItem(at: point)
        if let index = indexPath {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Delete List", style: .destructive, handler: {(_) in
                print("Perform Delete")
                let objectToDelete = self.lists[index.item]
                try! realmRef.write {
                    realmRef.delete(objectToDelete)
                    self.updateData()
                }
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            homeViewDelegate?.presentAlertController(alertController: alertController)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.delaysContentTouches = false
        collectionView.register(ListHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: cellId)
        updateData()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
