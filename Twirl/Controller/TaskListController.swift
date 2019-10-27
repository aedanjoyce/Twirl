//
//  TaskDetailController.swift
//  Twirl
//
//  Created by Aedan Joyce on 7/12/18.
//  Copyright © 2018 Aedan Joyce. All rights reserved.
//

import UIKit
import RealmSwift
protocol TaskListDelegate {
    func updateData()
}
class TaskListController: UITableViewController, TaskListDelegate {
    var selectedList : TaskList!
    var incompleteTasks : Results<Task>!
    var completedTasks : Results<Task>!
    weak var homeView: HomeView?
    weak var listCollectionView: ListCollectionView?
    lazy var taskCreator: TaskCreator = {
       let tCreator = TaskCreator()
        tCreator.selectedList = self.selectedList
        tCreator.type = TaskType.task
        tCreator.taskListControllerDelegate = self
        return tCreator
    }()
    private let cellId = "cellId"
    private let incompleteHeaderId = "incompleteHeaderId"
    private let completeHeaderId = "completeHeaderId"
    private let footerViewId = "footerViewId"
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = UIColor.white
        let barView = UIView(frame: UIApplication.shared.statusBarFrame)
        barView.backgroundColor = UIColor.white
        view.addSubview(barView)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        tableView.backgroundColor = UIColor.white
        tableView.register(TaskListCell.self, forCellReuseIdentifier: cellId)
        tableView.register(TaskListHeader.self, forHeaderFooterViewReuseIdentifier: incompleteHeaderId)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: footerViewId)
        tableView.register(CompletedHeader.self, forHeaderFooterViewReuseIdentifier: completeHeaderId)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(launchView))
        updateData()
    }
    @objc func launchView() {
        taskCreator.launchView()
    }
    func updateData() {
        completedTasks = self.selectedList.tasks.filter("isCompleted = true")
        incompleteTasks = self.selectedList.tasks.filter("isCompleted = false")
        if !realmRef.isInWriteTransaction {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            //self.homeView?.menuBar.frame.origin.y -= 50
            self.homeView?.menuBar.isHidden = true
            UIApplication.shared.statusBarView?.backgroundColor = UIColor.white
        }, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            //self.homeView?.menuBar.frame.origin.y += 50
            self.homeView?.menuBar.isHidden = false
            UIApplication.shared.statusBarView?.backgroundColor = UIColor.customMidGrey
        }, completion: nil)
        listCollectionView?.updateData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! TaskListCell
        switch indexPath.section {
        case 0:
            let task = incompleteTasks[indexPath.row]
            //let complete = completedTasks[indexPath.row]
            cell.titleLabel.text = task.name
            cell.accessoryType = .none
            cell.titleLabel.textColor = .black
            cell.circleIndicator.backgroundColor = UIColor.white
            cell.circleIndicator.layer.borderColor = UIColor.customMidGrey.cgColor
        case 1:
            let task = completedTasks[indexPath.row]
            cell.titleLabel.text = task.name
            cell.titleLabel.textColor = UIColor.lightGray
            cell.circleIndicator.backgroundColor = UIColor.menuPurple
            cell.circleIndicator.layer.borderColor = UIColor.white.cgColor

        default:
            fatalError("error")
        }

        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if let incomplete = incompleteTasks {
                return Int(incomplete.count)
            }
            return 0
        case 1:
            if let complete = completedTasks {
                return Int(complete.count)
            }
            return 0
        default:
            return 0
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        if completedTasks.count != 0 {
            return 2
        }
        return 1
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: incompleteHeaderId) as! TaskListHeader
        header.titleLabel.text = selectedList.name
        header.backgroundView?.backgroundColor = .white
        header.backgroundView?.tintColor = .white
        header.backgroundColor = .white
        header.contentView.backgroundColor = .white
        header.tintColor = .white
        let count = selectedList.tasks.filter("isCompleted = false").count
        header.taskCountLabel.text = String(count) + " tasks"
        return header
        } else {
            let completeHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: completeHeaderId) as! CompletedHeader
            return completeHeader
        }
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: footerViewId)
        return footer
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
           return determineHeightForRowWith(text: incompleteTasks[indexPath.row].name)
        } else {
           return determineHeightForRowWith(text: completedTasks[indexPath.row].name)
        }
    }
    private func determineHeightForRowWith(text: String) -> CGFloat {
        var height = estimateFrameSize(text: text).height
        if height <= 50 {
            height = 50
        } else {
            height = height + 5
        }
        return CGFloat(height)
    }
    fileprivate func estimateFrameSize(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [kCTFontAttributeName as NSAttributedStringKey: UIFont.systemFont(ofSize: 14, weight: .regular)], context: nil)
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat(125)
        } else {
            if let completedTasks = completedTasks {
                if completedTasks.count == 0 {
                return CGFloat(0)
            }
            }
            return CGFloat(50)
        }
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(1)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var taskItem: Task?
        switch indexPath.section {
        case 0:
            taskItem = incompleteTasks[indexPath.row]
        default:
            taskItem = completedTasks[indexPath.row]
        }
        try! realmRef.write {
            taskItem?.isCompleted = !taskItem!.isCompleted
        }
        updateData()
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
      
        if editingStyle == .delete {
            try! realmRef.write {
                if indexPath.section == 0 {
                realmRef.delete(incompleteTasks[indexPath.row])
                } else {
                realmRef.delete(completedTasks[indexPath.row])
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //let movedObject = self.incompleteTasks[sourceIndexPath.row]
//        self.incompleteTasks.remove(at: sourceIndexPath.row)
//        incompleteTasks.insert(movedObject, at: destinationIndexPath.row)
    }
    
}

class TaskListCell: UITableViewCell {
    let circleIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.borderColor = UIColor.customMidGrey.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    let titleLabel: UITextView = {
       let label = UITextView()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.isEditable = false
        label.isUserInteractionEnabled = false
        return label
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(circleIndicator)
        circleIndicator.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: centerYAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
        circleIndicator.layer.cornerRadius = 20 / 2
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: circleIndicator.rightAnchor, bottom: bottomAnchor, right: rightAnchor, centerX: nil, centerY: nil, paddingTop: 6, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class TaskListHeader: UITableViewHeaderFooterView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 35, weight: .semibold)
        return label
    }()
    let taskCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
        return label
    }()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews() {
        backgroundColor = UIColor.white
        backgroundView?.backgroundColor = .white
        addSubview(titleLabel)
        addSubview(taskCountLabel)
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        taskCountLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor).isActive = true
        taskCountLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        taskCountLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
    }
}
class CompletedHeader: UITableViewHeaderFooterView {
    let completedText: UILabel = {
        let label = UILabel()
        label.text = "COMPLETED"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)
        label.textColor = UIColor.lightGray
        return label
    }()
    let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("CLEAR", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)
        button.titleLabel?.tintColor = UIColor.gray
        button.tintColor = UIColor.gray
        return button
    }()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews() {
        addSubview(completedText)
        addSubview(clearButton)
        backgroundColor = UIColor(red:0.95, green:0.95, blue:0.97, alpha:1.0)
        completedText.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        completedText.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        clearButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        clearButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
    }
}
