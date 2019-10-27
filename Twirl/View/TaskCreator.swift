//
//  TaskCreator.swift
//  Twirl
//
//  Created by Aedan Joyce on 6/16/18.
//  Copyright © 2018 Aedan Joyce. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
struct TaskType {
    static let reminder = "Reminder"
    static let taskList = "List"
    static let task = "Task"
}
class TaskCreator: UIView {
    var delegate: HomeViewDelegate?
    var taskListControllerDelegate: TaskListDelegate?
    var selectedList: TaskList!
    let whiteView = UIView()
    var type: String? {
        didSet {
            if type == TaskType.taskList {
                listViewTitle.text = "Create a List"
                listButton.addTarget(self, action: #selector(handleCreateTaskList), for: .touchUpInside)
                listNameField.placeholder = "e.g. \"Shopping\""
            } else if type == TaskType.reminder {
                listViewTitle.text = "Create a Reminder"
                listButton.addTarget(self, action: #selector(handleDueDate), for: .touchUpInside)
                listNameField.placeholder = "e.g. \"Get groceries\""
            } else if type == TaskType.task {
                listViewTitle.text = "Create a Task"
                listButton.addTarget(self, action: #selector(handleCreateTask), for: .touchUpInside)
                listNameField.placeholder = "e.g. \"Walk the dog\""
            }
        }
    }
    @objc func handleCreateTaskList() {
        let listName = listNameField.text!
        let list = TaskList()
        list.name = listName
        try! realmRef.write {
            realmRef.add(list)
            self.handleRemove()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.delegate?.pushView(list: list)
        }
    }
    @objc func handleCreateReminder() {
        
    }
    @objc func handleDueDate() {
        
    }
    @objc func handleCreateTask() {
            let task = Task()
            task.name = listNameField.text!
            try! realmRef.write {
                self.selectedList.tasks.append(task)
            }
            self.handleRemove()
            taskListControllerDelegate?.updateData()
        print("complete")
    }
    let blackView = UIView()
    let container = UIView()
    let containerView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.white
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    let listViewTitle: UILabel = {
        let v = UILabel()
        v.text = "Create a List"
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont.boldSystemFont(ofSize: 18)
        return v
    }()
    let listCreationContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.white
        v.layer.cornerRadius = 5
        return v
    }()
    let listNameField: UITextField = {
        let f = UITextField()
        f.textColor = UIColor(red:0.11, green:0.11, blue:0.15, alpha:1.0)
        f.font = UIFont(name: "Avenir", size: 25)
        f.translatesAutoresizingMaskIntoConstraints = false
        f.placeholder = "e.g. \"Shopping\""
        f.textAlignment = .center
        f.layer.masksToBounds = true
        
        return f
    }()
    let titleSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.97, alpha:1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red:0.50, green:0.78, blue:1.00, alpha:1.0)
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        button.layer.masksToBounds = true
        button.isEnabled = false
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func launchView() {
        if let window = UIApplication.shared.keyWindow {
            
            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: window.frame.width, height: 250))
            containerView.backgroundColor = UIColor.white
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.layer.cornerRadius = 10
            if #available(iOS 11.0, *) {
                containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            }
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.frame = window.frame
            blackView.alpha = 0
            window.addSubview(blackView)
            window.addSubview(containerView)
            setupAllViews(container: containerView, field: listNameField, button: listButton, titleSeperator: titleSeperator, titleView: listViewTitle)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleNoTask)))
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                containerView.alpha = 1
            }, completion: nil)
            listNameField.inputAccessoryView = containerView
            listNameField.becomeFirstResponder()
            //listNameField.canBecomeFirstResponder
            listNameField.addTarget(self, action: #selector(handleButtonColor), for: .editingChanged)
        }
    }
    func setupAllViews(container: UIView, field: UITextField, button: UIButton, titleSeperator: UIView, titleView: UILabel) {
        container.addSubview(titleView)
        container.addSubview(field)
        container.addSubview(titleSeperator)
        container.addSubview(button)
        titleView.anchor(top: container.topAnchor, left: nil, bottom: nil, right: nil, centerX: container.centerXAnchor, centerY: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        titleSeperator.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        titleSeperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        titleSeperator.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        titleSeperator.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 12).isActive = true
        button.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        button.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        field.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        field.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        field.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
    }
    func seperatorHelper(seperator: UIView, parent: UIView) {
        seperator.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        seperator.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
    }
    func handleRemove() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            //self.listCreationContainer.alpha = 0
        }, completion: nil)
        endEditing(true)
        listNameField.endEditing(true)
        listNameField.clearsOnBeginEditing = true
        listButton.isEnabled = false
        whiteView.alpha = 0
        for(index,view) in whiteView.subviews.enumerated() {
            view.layer.opacity = 0
        }
        delegate?.updateData(type: type!)
    }
    @objc func handleNoTask() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            //self.listCreationContainer.alpha = 0
        }, completion: nil)
        endEditing(true)
        listNameField.endEditing(true)
        listNameField.clearsOnBeginEditing = true
        listButton.isEnabled = false
        delegate?.updateData(type: type!)
    }
    @objc func handleButtonColor() {
        let isTextValid = listNameField.text?.count ?? 0 > 0
        if isTextValid {
            listButton.isEnabled = true
            listButton.tintColor = UIColor.white
            listButton.backgroundColor = UIColor(red:0.21, green:0.65, blue:1.00, alpha:1.0)
        } else {
            listButton.isEnabled = false
            listButton.tintColor = UIColor.white
            listButton.backgroundColor = UIColor(red:0.50, green:0.78, blue:1.00, alpha:1.0)
            
        }
    }
    
    func setupListViews() {
        listCreationContainer.addSubview(listViewTitle)
        listViewTitle.centerXAnchor.constraint(equalTo: listCreationContainer.centerXAnchor).isActive = true
        listViewTitle.topAnchor.constraint(equalTo: listCreationContainer.topAnchor, constant: 12).isActive = true
        
        
    }
}
