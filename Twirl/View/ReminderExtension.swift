//
//  ReminderExtension.swift
//  Motive
//
//  Created by Aedan Joyce on 7/27/17.
//  Copyright © 2017 Aedan Joyce. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications
import UserNotificationsUI
extension Reminder {
    func handleTaskPopUp() {
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.frame = window.frame
            blackView.alpha = 0
            window.addSubview(blackView)
            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 250))
            containerView.backgroundColor = UIColor.white
            window.addSubview(containerView)
            setupAllViews(container: containerView, field: taskTextField, button: taskButton, titleSeperator: listSeperator, titleView: taskViewTitle)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRemove)))
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                //self.listCreationContainer.alpha = 1
                //self.taskCreationContainer.transform = self.grow
            }, completion: nil)
            taskTextField.inputAccessoryView = containerView
            taskTextField.becomeFirstResponder()
            taskTextField.addTarget(self, action: #selector(handleButtonColor), for: .editingChanged)
            taskButton.addTarget(self, action: #selector(handleDueDate), for: .touchUpInside)
            }
        
    }
    @objc func handleRemove() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            self.dateContainer.alpha = 0
            self.dateContainer.transform = self.shrink
        }, completion: nil)
        taskTextField.endEditing(true)
        taskTextField.clearsOnBeginEditing = true
        taskButton.isEnabled = false
        dueDateButton.isEnabled = false
        //stepper.value = 0
        stepper.maximumValue = 20160
        reminderSubLabel.text = "At the time of the event"
    }
    
    @objc func handleDueDate() {
        
        handleRemove()
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.frame = window.frame
            blackView.alpha = 0
            window.addSubview(blackView)
            window.addSubview(dateContainer)
            dateContainer.addSubview(dueDateLabel)
            dateContainer.addSubview(datePicker)
            dateContainer.addSubview(reminderLabel)
            dateContainer.addSubview(reminderSubLabel)
            dateContainer.addSubview(stepper)
            dateContainer.addSubview(dateButton)
            dateContainer.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
            dateContainer.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
            dateContainer.heightAnchor.constraint(equalToConstant: window.frame.height/1.5).isActive = true
            dateContainer.widthAnchor.constraint(equalTo: window.widthAnchor, constant: -24).isActive = true
            dueDateLabel.centerXAnchor.constraint(equalTo: dateContainer.centerXAnchor).isActive = true
            dueDateLabel.topAnchor.constraint(equalTo: dateContainer.topAnchor, constant: 12).isActive = true
            datePicker.centerXAnchor.constraint(equalTo: dateContainer.centerXAnchor).isActive = true
            datePicker.topAnchor.constraint(equalTo: dueDateLabel.bottomAnchor, constant: 24).isActive = true
            datePicker.widthAnchor.constraint(equalTo: dateContainer.widthAnchor).isActive = true
            datePicker.heightAnchor.constraint(equalToConstant: 120).isActive = true
            reminderLabel.centerXAnchor.constraint(equalTo: dateContainer.centerXAnchor).isActive = true
            reminderLabel.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 12).isActive = true
            reminderSubLabel.centerXAnchor.constraint(equalTo: dateContainer.centerXAnchor).isActive = true
            reminderSubLabel.topAnchor.constraint(equalTo: reminderLabel.bottomAnchor, constant: 24).isActive = true
            stepper.centerXAnchor.constraint(equalTo: dateContainer.centerXAnchor).isActive = true
            stepper.topAnchor.constraint(equalTo: reminderSubLabel.bottomAnchor, constant: 12).isActive = true
            dateButton.centerXAnchor.constraint(equalTo: dateContainer.centerXAnchor).isActive = true
            dateButton.bottomAnchor.constraint(equalTo: dateContainer.bottomAnchor).isActive = true
            dateButton.widthAnchor.constraint(equalTo: dateContainer.widthAnchor).isActive = true
            dateButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            dateContainer.alpha = 0
            dateContainer.transform = shrink
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRemove)))
            UIView.animate(withDuration: 0.5, delay: 0.7, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.dateContainer.alpha = 1
                self.dateContainer.transform = self.grow
            }, completion: nil)
            for(index,view) in dateContainer.subviews.enumerated() {
                view.layer.opacity = 0
                let delay = 0.065 * Double(index)
                let origin = view.frame.origin.y
                dateButton.layer.opacity = 0
                view.frame.origin.y += 75
                dateButton.frame.origin.y = origin
                UIView.animate(withDuration: 0.7, delay: delay + 0.9, options: .curveEaseInOut, animations: {
                    view.layer.opacity = 1
                    view.frame.origin.y = origin
                }, completion: nil)
            }
            dateButton.addTarget(self, action: #selector(createTaskWithDate), for: .touchUpInside)
            stepper.addTarget(self, action: #selector(stepperValueChanged(stepper:)), for: .valueChanged)
        }
    }
    
    @objc func stepperValueChanged(stepper: UIStepper) {
        stepper.minimumValue = 0
        stepper.maximumValue = 20160
        var value = Int(stepper.value)
        var minutes = 0
        if minutes == 0 {
            reminderSubLabel.text = "At the time of the event"
        }
        for step in 0..<value {
            if step <= 11 {
                minutes += 5
                reminderSubLabel.text = "\(minutes) minutes before"
                if minutes == 60 {
                reminderSubLabel.text = "\(minutes / 60) hour before"
                }
            } else if step <= 12 {
                minutes += 60
                reminderSubLabel.text = "\(minutes / 60) hours before"
            } else if step <= 14 {
               
                if step == 13 {
                minutes += 1320
                reminderSubLabel.text = "\(minutes / 1440) day before"
                } else {
                    minutes += 1440
                    reminderSubLabel.text = "\(minutes / 1440) days before"
                }
                
            } else {
                if step == 15 {
                    minutes += 7200
                    reminderSubLabel.text = "\(minutes / 10080) week before"
                } else {
                    minutes += 10080
                    reminderSubLabel.text = "\(minutes / 10080) weeks before"
                }
                if minutes == 20160 {
                    value = 20160
                }
            }
        }
        print("\(minutes)")
        self.minutes = minutes
    }
    @objc func handleButtonColor() {
        let isTextValid = taskTextField.text?.characters.count ?? 0 > 0
        if isTextValid {
            taskButton.isEnabled = true
            taskButton.tintColor = UIColor.white
            taskButton.backgroundColor = UIColor(red:0.21, green:0.65, blue:1.00, alpha:1.0)
            
        } else {
            taskButton.isEnabled = false
            taskButton.tintColor = UIColor.white
            taskButton.backgroundColor = UIColor(red:0.50, green:0.78, blue:1.00, alpha:1.0)
            
        }
    }
    @objc func createTaskWithDate() {
        let dateFormatter = DateFormatter()
        var date = ""
        var finalString = ""
        var components = Calendar.current.dateComponents([.weekday,.hour,.minute], from: datePicker.date)
        let task = DueDate()
        task.name = taskTextField.text!
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.userInfo = ["primaryKey": task.dateID]
        content.title = "Reminder"
        switch minutes {
        case 0:
            content.body = taskTextField.text!
        case 1...55:
            content.body = taskTextField.text! + " in " + "\(minutes) minutes."
        case 60:
            content.body = taskTextField.text! + " in " + "\(minutes / 60) hour."
        case 120:
            content.body = taskTextField.text! + " in " + "\(minutes / 60) hours."
        case 1440:
            content.body = taskTextField.text! + " tomorrow."
        case 2880:
            content.body = taskTextField.text! + " in " + "\(minutes / 1440) days."
        case 10080:
            content.body = taskTextField.text! + " in " + "\(minutes / 10080) week."
        default:
            content.body = taskTextField.text! + " in " + "\(minutes / 10080) weeks."
        }
        //content.body = taskTextField.text!
        content.sound = UNNotificationSound.default()
        if minutes != 0 {
            components = Calendar.current.dateComponents([.weekday,.hour,.minute], from: datePicker.date.addingTimeInterval(TimeInterval(-60 * minutes)))
        }
            dateFormatter.dateFormat = "MMM d, h:mm a"
            date = dateFormatter.string(from: datePicker.date)
            finalString = date.uppercased()
        task.dueDate = finalString
        content.categoryIdentifier = "actionCategory"
        print("\(task.dateID)")
        let options: UNAuthorizationOptions = [.alert, .sound]
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        //let identifier = "LocalNotification"
        let request = UNNotificationRequest(identifier: task.dateID, content: content, trigger: trigger)
        
        DispatchQueue.global(qos: .background).async { // sends registration to background queue
            center.add(request, withCompletionHandler: {(error) in
                if let error = error {
                    print(error)
                } else {
                    DispatchQueue.main.async {
                        try! self.realm.write {
                            self.realm.add(task)
                            self.updateData()
                            self.handleRemove()
                            self.presentDateAdded()
                        }
                    }
                }
            })
        }        
    }
    



    func presentDateAdded() {
        view.addSubview(dateAddedAlertContainer)
        dateAddedAlertContainer.addSubview(dateAlertLabel)
        dateAddedAlertContainer.addSubview(greypoint)
        dateAddedAlertContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        dateAddedAlertContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        dateAddedAlertContainer.widthAnchor.constraint(equalToConstant: 160).isActive = true
        dateAddedAlertContainer.heightAnchor.constraint(equalToConstant: 55).isActive = true
        //greypoint.centerXAnchor.constraint(equalTo: dateAddedAlertContainer.centerXAnchor).isActive = true
        greypoint.widthAnchor.constraint(equalToConstant: 60).isActive = true
        greypoint.heightAnchor.constraint(equalTo: dateAddedAlertContainer.heightAnchor).isActive = true
        greypoint.centerYAnchor.constraint(equalTo: dateAddedAlertContainer.centerYAnchor).isActive = true
        greypoint.leftAnchor.constraint(equalTo: dateAddedAlertContainer.leftAnchor).isActive = true
        greypoint.addSubview(checkmarkView)
        checkmarkView.centerXAnchor.constraint(equalTo: greypoint.centerXAnchor).isActive = true
        checkmarkView.centerYAnchor.constraint(equalTo: greypoint.centerYAnchor).isActive = true
        //dateAlertLabel.centerXAnchor.constraint(equalTo: dateAddedAlertContainer.centerXAnchor).isActive = true
        dateAlertLabel.centerYAnchor.constraint(equalTo: dateAddedAlertContainer.centerYAnchor).isActive = true
        dateAlertLabel.leftAnchor.constraint(equalTo: greypoint.rightAnchor, constant: 6).isActive = true
        dateAddedAlertContainer.layer.opacity = 0
        let origin = dateAddedAlertContainer.frame.origin.y
        dateAddedAlertContainer.frame.origin.y += 100
        UIView.animate(withDuration: 0.9, delay: 0.5, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.dateAddedAlertContainer.layer.opacity = 1
            self.dateAddedAlertContainer.frame.origin.y = origin
        }, completion: nil)
        perform(#selector(dismissDateAlert), with: nil, afterDelay: 5)
    }
    @objc func dismissDateAlert() {
        UIView.animate(withDuration: 0.9, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.dateAddedAlertContainer.layer.opacity = 0
            self.dateAddedAlertContainer.frame.origin.y -= 75
        }, completion: nil)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.badge])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let primaryKey = userInfo["primaryKey"] as? String {
        switch response.actionIdentifier {
        case "action1":
            print("Key: \(primaryKey)")
            let object = realm.object(ofType: DueDate.self, forPrimaryKey: primaryKey)
            try! self.realm.write {
                self.realm.delete(object!)
                self.updateData()
            }
        default:
            break
        }
        
        
    
      
        }
          completionHandler()
    }
    
}


