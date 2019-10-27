//
//  TaskView.swift
//  Motive
//
//  Created by Aedan Joyce on 7/18/17.
//  Copyright © 2017 Aedan Joyce. All rights reserved.
//

//import UIKit
//import RealmSwift
//import MessageUI
//import Hero
//
//class TaskView: UICollectionViewController, UICollectionViewDelegateFlowLayout, MFMessageComposeViewControllerDelegate {
//    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    let grow = CGAffineTransform(scaleX: 1, y: 1)
//    let shrink = CGAffineTransform(scaleX: 0.7, y: 0.7)
//    let blue = UIColor(red:0.21, green:0.65, blue:1.00, alpha:1.0)
//    let red = UIColor(red:1.00, green:0.35, blue:0.51, alpha:1.0)
//    var selectedList: TaskList!
//    var tasks: Results<Task>!
//    var completedTasks: Results<Task>!
//    var dueDate: DueDate?
//    weak var homeView: HomeView?
//    private let cellId = "cellId"
//     private let headerId = "headerId"
//    private let completedHeaderId = "completedHeaderId"
//    let blackView = UIView()
//    let container = UIView()
//    let removeButton: UIButton = {
//       let button = UIButton(type: .system)
//        button.setImage(#imageLiteral(resourceName: "Remove"), for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    let taskViewTitle: UILabel = {
//        let v = UILabel()
//        v.text = "Create a Task"
//        v.translatesAutoresizingMaskIntoConstraints = false
//        v.font = UIFont.boldSystemFont(ofSize: 18)
//        return v
//    }()
//    let dueDateTitle: UILabel = {
//        let v = UILabel()
//        v.translatesAutoresizingMaskIntoConstraints = false
//        v.font = UIFont.boldSystemFont(ofSize: 18)
//        v.textAlignment = .center
//        return v
//    }()
//    let taskTextField: UITextField = {
//        let f = UITextField()
//        f.textColor = UIColor(red:0.11, green:0.11, blue:0.15, alpha:1.0)
//        f.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.light)
//        f.translatesAutoresizingMaskIntoConstraints = false
//        f.placeholder = "e.g. 'Get groceries'"
//        f.textAlignment = .center
//        f.layer.masksToBounds = true
//        return f
//    }()
//
//    let listSeperator: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.97, alpha:1.0)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    let taskButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.backgroundColor = UIColor(red:0.50, green:0.78, blue:1.00, alpha:1.0)
//        button.tintColor = UIColor.white
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("Create", for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
//        button.layer.masksToBounds = true
//        button.isEnabled = false
//        return button
//    }()
//
//    let moreDataContainer: UIView = {
//       let v = UIView()
//        v.backgroundColor = UIColor.white
//        v.translatesAutoresizingMaskIntoConstraints = false
//        return v
//    }()
//    let taskTitle: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 35, weight: UIFont.Weight.heavy)
//        label.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
//        return label
//    }()
//    let taskCount: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
//        label.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
//        return label
//    }()
//    let completedTaskCount: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
//        label.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
//       // label.text = "12 Tasks Complete"
//        return label
//    }()
//    let incompleteTaskCount: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
//        label.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
//        //label.text = "10 Tasks Incomplete"
//        return label
//    }()
//    let redIndicator: UIView = {
//       let l = UIView()
//        l.backgroundColor = UIColor.white
//        l.layer.cornerRadius = 5
//        l.translatesAutoresizingMaskIntoConstraints = false
//        l.layer.borderWidth = 2
//        l.layer.borderColor = UIColor(red:1.00, green:0.35, blue:0.51, alpha:1.0).cgColor
//        return l
//    }()
//    let blueIndicator: UIView = {
//        let l = UIView()
//        l.backgroundColor = UIColor.white
//        l.layer.cornerRadius = 5
//        l.translatesAutoresizingMaskIntoConstraints = false
//        l.layer.borderWidth = 2
//        l.layer.borderColor = UIColor(red:0.21, green:0.65, blue:1.00, alpha:1.0).cgColor
//
//        return l
//    }()
//    weak var listCollectionView: ListCollectionView?
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        collectionView?.backgroundColor = UIColor.white
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.backgroundColor = UIColor.white
//        let barView = UIView(frame: UIApplication.shared.statusBarFrame)
//        barView.backgroundColor = UIColor.white
//        view.addSubview(barView)
//        collectionView?.alwaysBounceVertical = true
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        collectionView?.register(TaskCell.self, forCellWithReuseIdentifier: cellId)
//        collectionView?.register(ListHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
//        collectionView?.register(CompletedHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: completedHeaderId)
//        navigationController?.navigationBar.tintColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleTaskPopUp))
//        let moreButton = UIBarButtonItem(image: #imageLiteral(resourceName: "graph-bar"), style: .plain, target: self, action: #selector(handleMore))
//        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleShare))
//        navigationItem.setRightBarButtonItems([addButton,moreButton, shareButton], animated: true)
//        self.hero.isEnabled = true
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.reloadViewData()
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
//            self.homeView?.menuBar.isHidden = true
//            UIApplication.shared.statusBarView?.backgroundColor = UIColor.white
//        }, completion: nil)
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
//            self.homeView?.menuBar.isHidden = false
//            UIApplication.shared.statusBarView?.backgroundColor = UIColor.customMidGrey
//        }, completion: nil)
//        listCollectionView?.updateData()
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TaskCell
//        switch indexPath.section {
//        case 0:
//            let task = tasks[indexPath.row]
//            //let complete = completedTasks[indexPath.row]
//            cell.taskTitleLabel.text = task.name
//            cell.dueDate.text = task.dueDate
//            cell.taskTitleLabel.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
//            cell.dueDate.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
//            cell.deleteButton.addTarget(self, action: #selector(handleOpenDelete(sender:)), for: .touchUpInside)
//            cell.deleteButton.alpha = 1
//            cell.circleIndicator.backgroundColor = UIColor.white
//            cell.circleIndicator.layer.borderColor = UIColor.customMidGrey.cgColor
//        case 1:
//            let task = completedTasks[indexPath.row]
//            cell.taskTitleLabel.text = task.name
//            cell.taskTitleLabel.textColor = UIColor.lightGray
//            cell.dueDate.text = task.dueDate
//            cell.dueDate.textColor = UIColor.lightGray
//            cell.deleteButton.alpha = 0
//            cell.circleIndicator.backgroundColor = UIColor.menuPurple
//            cell.circleIndicator.layer.borderColor = UIColor.menuPurple.cgColor
//        default:
//            fatalError("error")
//        }
//        return cell
//    }
//    @objc func handleOpenDelete(sender: UIButton) {
//
//            let point : CGPoint = sender.convert(CGPoint.zero, to:collectionView)
//            let indexPath = collectionView!.indexPathForItem(at: point)
//            if let index = indexPath {
//                let objectToDelete = self.tasks[index.item]
//                try! realmRef.write {
//                    realmRef.delete(objectToDelete)
//                    self.reloadViewData()
//                }
//            }
//        }
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch section {
//        case 0:
//            if let tasks = tasks {
//                if tasks.count > 0 {
//                   return Int(tasks.count)
//                }
//            }
//            return 0
//        case 1:
//            if let completedTasks = completedTasks {
//                if completedTasks.count > 0 {
//                    return Int(completedTasks.count)
//                }
//            }
//            return 0
//        default:
//            return 0
//        }
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let height: CGFloat = 50
//        let descriptionText = tasks[indexPath.item].name
//        return CGSize(width: view.frame.width, height: height)
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        if section == 0 {
//        return CGSize(width: view.frame.width, height: 125)
//        }
//        if completedTasks.count == 0 {
//            return CGSize(width: view.frame.width, height: 0)
//        }
//        return CGSize(width: view.frame.width, height: 50)
//    }
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//            let section = indexPath.section
//            switch section {
//            case 0:
//                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! ListHeaderCell
//                header.titleLabel.text = selectedList?.name
//
//                if let taskCount = tasks {
//                    if taskCount.count == 1 {
//                        header.taskCountLabel.text = "\(taskCount.count) task"
//                    } else if taskCount.count == 0 {
//                        header.taskCountLabel.text = "No tasks"
//                    } else {
//                        header.taskCountLabel.text = "\(taskCount.count) tasks"
//                    }
//                }
//                return header
//            default:
//                let completedHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: completedHeaderId, for: indexPath) as! CompletedHeader
//                completedHeader.clearButton.addTarget(self, action: #selector(deleteObjects), for: .touchUpInside)
//                return completedHeader
//            }
//    }
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 2
//    }
//    @objc func deleteObjects() {
//        try! realmRef.write {
//            realmRef.delete(completedTasks)
//            self.reloadViewData()
//        }
//    }
//    @objc func handleShare() {
//        guard let listName = selectedList?.name else {return}
//        var finalText = "○ " + listName + "\n---\n" + "\n"
//        var count = 1
//        tasks.forEach { (task) in
//            let text = task.name
//            finalText += "\(count).) " + text + "\n"
//            finalText += "---\n"
//            count += 1
//        }
//        finalText += "\nPowered by Twirl App"
//        if (MFMessageComposeViewController.canSendText()) {
//            let controller = MFMessageComposeViewController()
//            controller.body = finalText
//            controller.messageComposeDelegate = self
//            self.present(controller, animated: true, completion: nil)
//        }
//        print(finalText)
//    }
//    func createTask() {
//        let task = Task()
//        task.name = taskTextField.text!
//        try! realmRef.write {
//            self.selectedList?.tasks.append(task)
//        }
//        self.handleRemove()
//        self.reloadViewData()
//    }
//    func reloadViewData() {
//        completedTasks = self.selectedList.tasks.filter("isCompleted = true")
//        tasks = self.selectedList.tasks.filter("isCompleted = false")
//        safelyUpdateMainThread()
//    }
//    fileprivate func safelyUpdateMainThread() {
//        if !realmRef.isInWriteTransaction {
//            DispatchQueue.main.async {
//                self.collectionView?.reloadData()
//            }
//        }
//    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        reloadViewData()
//    }
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        var taskItem: Task?
//        switch indexPath.section {
//        case 0:
//            taskItem = tasks[indexPath.row]
//        default:
//            taskItem = completedTasks[indexPath.row]
//        }
//        try! realmRef.write {
//            taskItem?.isCompleted = !taskItem!.isCompleted
//        }
//        reloadViewData()
//        }
//    }
//class TaskCell: UICollectionViewCell, UIGestureRecognizerDelegate {
//    let actionView: UIView = {
//       let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = UIColor.red
//        return view
//    }()
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//    }
//
//    let taskTitleLabel: UITextView = {
//        let t = UITextView()
//        t.translatesAutoresizingMaskIntoConstraints = false
//        t.text = "Sample"
//        t.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
//        t.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
//        t.isEditable = false
//        t.isUserInteractionEnabled = false
//        return t
//    }()
//    let dueDate: UILabel = {
//        let t = UILabel()
//        t.translatesAutoresizingMaskIntoConstraints = false
//        t.text = "Due: \nTuesday, July 25, 5:44PM"
//        t.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)
//        t.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
//        t.numberOfLines = 2
//        return t
//    }()
//    let seperator: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor(red:0.68, green:0.68, blue:0.68, alpha:0.2)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    let circleIndicator: UIView = {
//       let view = UIView()
//        view.backgroundColor = UIColor.white
//        view.layer.borderColor = UIColor.customMidGrey.cgColor
//        view.layer.borderWidth = 1
//        return view
//    }()
//    let deleteButton: UIButton = {
//        let button = UIButton()
//        button.setImage(#imageLiteral(resourceName: "cross"), for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    func setupViews() {
//        backgroundColor = UIColor.white
//        addSubview(circleIndicator)
//        circleIndicator.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: centerYAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 25, height: 25)
//        circleIndicator.layer.cornerRadius = 25 / 2
//        addSubview(taskTitleLabel)
//        taskTitleLabel.anchor(top: circleIndicator.topAnchor, left: circleIndicator.rightAnchor, bottom: bottomAnchor, right: rightAnchor, centerX: nil, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
////        let padding = taskTitleLabel.textContainer.lineFragmentPadding
////        taskTitleLabel.textContainerInset = UIEdgeInsetsMake(0, -padding, 0, -padding)
//        addSubview(seperator)
//        seperator.anchor(top: nil, left: nil, bottom: bottomAnchor, right: nil, centerX: centerXAnchor, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width, height: 1)
//    }
//
//
//
//}
//class HeaderCell: UICollectionViewCell {
//    let titleLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 35, weight: UIFont.Weight.heavy)
//        label.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
//        return label
//    }()
//    let taskCountLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
//        label.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
//        return label
//    }()
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    func setupViews() {
//        backgroundColor = UIColor.white
//        addSubview(titleLabel)
//        addSubview(taskCountLabel)
//        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
//        taskCountLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor).isActive = true
//        taskCountLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
//        taskCountLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
//    }
//
//}


