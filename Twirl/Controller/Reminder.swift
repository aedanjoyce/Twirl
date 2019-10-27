//
//  Reminder.swift
//  Motive
//
//  Created by Aedan Joyce on 7/26/17.
//  Copyright © 2017 Aedan Joyce. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications
class Reminder: UICollectionViewController, UICollectionViewDelegateFlowLayout, UNUserNotificationCenterDelegate {
    var minutes = 0
    private let cellId = "cellId"
    private let headerId = "headerId"
    var dates: Results<DueDate>!
    var dueDate: DueDate?
    //var taskView: TaskView?
    let realm = try! Realm()
    var titleString = ""
    let grow = CGAffineTransform(scaleX: 1, y: 1)
    let shrink = CGAffineTransform(scaleX: 0.7, y: 0.7)
    var isGrantedAccess = false
    let dateAddedAlertContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowRadius = 30
        view.layer.shadowOpacity = 1
        return view
    }()
    let greypoint: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        view.layer.masksToBounds = true
        return view
    }()
    let checkmarkView: UIImageView = {
        let mark = UIImageView(image: #imageLiteral(resourceName: "checkmark"))
        mark.translatesAutoresizingMaskIntoConstraints = false
        return mark
    }()
    let dateAlertLabel: UILabel = {
        let v = UILabel()
        v.text = "Reminder Set"
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        v.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
        return v
    }()
    let dateContainer: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.white
        //container.layer.cornerRadius = 10
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = UIColor.white
        return picker
    }()
    let dateButton: UIButton = {
        let button = UIButton(type: .system)
        //button.backgroundColor = UIColor(red:0.21, green:0.65, blue:1.00, alpha:1.0)
        button.tintColor = UIColor(red:0.21, green:0.65, blue:1.00, alpha:1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        button.layer.masksToBounds = true
        button.isEnabled = true
        return button
    }()
    let taskViewTitle: UILabel = {
        let v = UILabel()
        v.text = "Create a Reminder"
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont.boldSystemFont(ofSize: 18)
        return v
    }()
    let dueDateLabel: UILabel = {
        let v = UILabel()
        v.text = "Due Date"
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.medium)
        v.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
        return v
    }()
    let reminderLabel: UILabel = {
        let v = UILabel()
        v.text = "Remind me"
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.medium)
        v.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
        return v
    }()
    let reminderSubLabel: UILabel = {
        let v = UILabel()
        v.text = "At the time of the event"
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        v.textColor = UIColor.lightGray
        return v
    }()
    let stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.tintColor = UIColor(red:0.21, green:0.65, blue:1.00, alpha:1.0)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        //stepper.wraps = true
        stepper.autorepeat = true
        return stepper
    }()
    let taskTextField: UITextField = {
        let f = UITextField()
        f.textColor = UIColor(red:0.11, green:0.11, blue:0.15, alpha:1.0)
        f.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.light)
        f.translatesAutoresizingMaskIntoConstraints = false
        f.placeholder = "e.g. \"Walk the dogs\""
        f.textAlignment = .center
        f.layer.masksToBounds = true
        return f
    }()
    
    let listSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.97, alpha:1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let taskButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red:0.50, green:0.78, blue:1.00, alpha:1.0)
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        button.layer.masksToBounds = true
        button.isEnabled = false
        return button
    }()
    
        let dueDateButton: UIButton = {
        let button = UIButton(type: .system)
        //button.backgroundColor = UIColor(red:0.50, green:0.78, blue:1.00, alpha:1.0)
        button.tintColor = UIColor(red:0.50, green:0.78, blue:1.00, alpha:1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add a due date", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        button.layer.masksToBounds = true
        button.isEnabled = false
        return button
    }()
    let blackView = UIView()
    let container = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = UIColor.white
        let barView = UIView(frame: UIApplication.shared.statusBarFrame)
        barView.backgroundColor = UIColor.white
        view.addSubview(barView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleTaskPopUp))
        collectionView?.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)
        collectionView?.register(EventCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(EventHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader , withReuseIdentifier: headerId)
          UNUserNotificationCenter.current().delegate = self
        //print("Object:" + object)
        print("Test")
    }
    func createDate() {

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //updateData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
        
    }
    func updateData() {
        self.collectionView?.reloadData()
        dates = realm.objects(DueDate.self)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EventCell
        let blue = UIColor(red:0.21, green:0.65, blue:1.00, alpha:1.0)
        let red = UIColor(red:1.00, green:0.35, blue:0.51, alpha:1.0)
        let pink = UIColor(red:1.00, green:0.60, blue:0.91, alpha:1.0)
        let purple = UIColor(red:0.51, green:0.63, blue:1.00, alpha:1.0)
        let task = dates[indexPath.row]
        //let complete = completedTasks[indexPath.row]
        cell.taskTitleLabel.text = task.name
        cell.dueDate.text = task.dueDate
        cell.optionButton.addTarget(self, action: #selector(handleOptions(sender:)), for: .touchUpInside)
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
    @objc func handleOptions(sender: UIButton) {
        let point : CGPoint = sender.convert(CGPoint.zero, to:collectionView)
        let indexPath = collectionView!.indexPathForItem(at: point)
        if let index = indexPath {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Mark as Complete", style: .default, handler: {(_) in
                print("Perform Completion")
                let objectToDelete = self.dates[index.item]
                try! self.realm.write {
                    self.realm.delete(objectToDelete)
                    self.updateData()
                }
            }))
            alertController.addAction(UIAlertAction(title: "Delete Reminder", style: .destructive, handler: {(_) in
                print("Perform Delete")
                let objectToDelete = self.dates[index.item]
                try! self.realm.write {
                    self.realm.delete(objectToDelete)
                    self.updateData()
                }
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 60)
        return CGSize(width: width, height: 120)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let tasks = dates {
            return tasks.count
        }
        return 0
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! EventHeaderCell
            if let date = dates {
                if date.count == 0 {
                    header.reminderCount.text = "No reminders"
                } else if date.count == 1 {
                    header.reminderCount.text = "\(date.count) reminder"
                } else {
                    header.reminderCount.text = "\(date.count) reminders"
                }
            }
            return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 125)
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 5, bottom: 0, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func addTask(task: DueDate) {
        try! realm.write {
            realm.add(task)
            updateData()
        }
    }
    
    
}
class EventCell: UICollectionViewCell {
    // if indexPath.item / 4 = .25 -> cell should be blue
    let colorIndicator: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    
    let taskTitleLabel: UILabel = {
        let t = UILabel()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.text = "Sample"
        t.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        t.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
        return t
    }()
    let dueDate: UILabel = {
        let t = UILabel()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.text = "JULY 25, 5:45PM"
        t.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.regular)
        t.textColor = UIColor.lightGray
        t.numberOfLines = 2
        return t
    }()
    let seperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.68, green:0.68, blue:0.68, alpha:0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let optionButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(#imageLiteral(resourceName: "dots"), for: .normal)
    return button
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews() {
        backgroundColor = UIColor.white
        addSubview(taskTitleLabel)
        addSubview(seperator)
        addSubview(dueDate)
        addSubview(colorIndicator)
        addSubview(optionButton)
        //layer.cornerRadius = 30
        layer.shadowColor = UIColor(red:0.83, green:0.83, blue:0.83, alpha:1.0).cgColor
        layer.shadowRadius = 10
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero
        colorIndicator.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        colorIndicator.heightAnchor.constraint(equalToConstant: frame.height/5).isActive = true
        colorIndicator.widthAnchor.constraint(equalToConstant: frame.width/4.5).isActive = true
        //colorIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        //taskTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        taskTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        taskTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 40).isActive = true
        // dueDate.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dueDate.topAnchor.constraint(equalTo: taskTitleLabel.bottomAnchor, constant: 6).isActive = true
        dueDate.leftAnchor.constraint(equalTo: taskTitleLabel.leftAnchor).isActive = true
        seperator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        seperator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        seperator.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        optionButton.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        optionButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
    }
}
class EventHeaderCell: UICollectionViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 35, weight: UIFont.Weight.heavy)
        label.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
        label.text = "Reminders"
        return label
    }()
    let reminderCount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews() {
        backgroundColor = UIColor.white
        addSubview(titleLabel)
        addSubview(reminderCount)
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        reminderCount.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor).isActive = true
        reminderCount.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        reminderCount.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
    }
    func setupLabels() {
        
    }
}

