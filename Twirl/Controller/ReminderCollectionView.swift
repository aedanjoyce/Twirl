//
//  ReminderCollectionView.swift
//  Twirl
//
//  Created by Aedan Joyce on 6/16/18.
//  Copyright © 2018 Aedan Joyce. All rights reserved.
//

import UIKit
import RealmSwift
import EventKit
import ViewAnimator
class ReminderCollectionView: TwirlCollectionViewBase, UICollectionViewDataSource {
    var reminders = [EventReminder]()
    private let cellId = "cellId"
    private let headerId = "headerId"
    private let sectionHeaderId = "sectionHeaderId"
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return reminders.firstIndex(where: { (event) -> Bool in
                let date = Date()
                let calendar = Calendar.current
                let minutes = calendar.component(.minute, from: date)
                return (calendar.component(.minute, from: event.startDate) > minutes)
            }) ?? 0
        case 1:
            return reminders.filter({ (event) -> Bool in
                NSCalendar.current.isDateInToday(event.startDate) == true
            }).count
        case 2:
            return reminders.filter({ (event) -> Bool in
                NSCalendar.current.isDateInTomorrow(event.startDate) == true
            }).count
        default:
            return 0
        }
        //return reminders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ReminderCell
        cell.eventReminder = reminders[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! EventHeaderCell
        
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionHeaderId, for: indexPath) as! SectionHeader
        switch indexPath.section {
        case 0:
            header.upNextLabel.isHidden = false
            header.seperator.isHidden = true
            header.titleLabel.text = "Reminders"
            header.taskCountLabel.text = "\(reminders.count) reminders"
            return header
        case 1:
            sectionHeader.titleLabel.text = "Later Today"
            return sectionHeader
        case 2:
            sectionHeader.titleLabel.text = "Tomorrow"
            return sectionHeader
        default:
            fatalError("Error")
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
        return CGSize(width: frame.width, height: 165)
        } else {
        return CGSize(width: frame.width, height: 50)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width - 20, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.delaysContentTouches = false
        collectionView.register(ReminderCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(EventHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sectionHeaderId)
        requestCalendarAuth()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func requestCalendarAuth() {
        let eventStore = EKEventStore()
        
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            self.fetchCalendarData()
        case .denied:
            print("Access denied")
        case .notDetermined:
            eventStore.requestAccess(to: .event, completion: { (granted: Bool, NSError) -> Void in
                if granted {
                    self.fetchCalendarData()
                }else{
                    print("Access denied")
                }
            })
        default:
            print("Case Default")
        }
    }
    func fetchCalendarData() {
        let calendars = EKEventStore().calendars(for: .event)
        calendars.forEach { (calendar) in
            let oneMonthAgo = NSDate(timeIntervalSinceNow: -30*24*3600)
            let oneMonthAfter = NSDate(timeIntervalSinceNow: +30*24*3600)
            
            let predicate = EKEventStore().predicateForEvents(withStart: oneMonthAgo as Date, end: oneMonthAfter as Date, calendars: [calendar])
            
            let events = EKEventStore().events(matching: predicate)
            events.forEach({ (event) in
                if event.calendar.title != "US Holidays" {
                reminders.append(EventReminder(event: event))
                }
            })
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.performBatchUpdates({
                    UIView.animate(views: self.collectionView.orderedVisibleCells, animations: [AnimationType.from(direction: .bottom, offset: 30.0)])
                }, completion: nil)
            }
            
            
            
        }
    }
}
class ReminderCell: UICollectionViewCell {
    var eventReminder: EventReminder? {
        didSet {
            self.calendarTitle.text = eventReminder?.calendarTitle
            self.eventTitle.text = eventReminder?.eventTitle
            self.dueDate.text = eventReminder?.timeFrame
            
            switch eventReminder?.calendarTitle {
            case "Work":
            self.calendarTitle.textColor = UIColor(red:0.93, green:0.40, blue:0.51, alpha:1.0)
            self.container.backgroundColor = UIColor(red:0.93, green:0.40, blue:0.51, alpha:0.3)
            case "Home":
            self.calendarTitle.textColor = UIColor(red:0.53, green:0.63, blue:0.97, alpha:1.0)
            self.container.backgroundColor = UIColor(red:0.53, green:0.63, blue:0.97, alpha:0.3)
            default:
            self.calendarTitle.textColor = UIColor(red:0.35, green:0.65, blue:0.97, alpha:1.0)
            self.container.backgroundColor = UIColor(red:0.35, green:0.65, blue:0.97, alpha:0.3)
            }
        }
    }
    let calendarTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    let container = UIView()
    let eventTitle: UILabel = {
       let label = UILabel()
       label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
       return label
    }()
    let dueDate: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.customDarkGrey
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        layer.cornerRadius = 5
        layer.borderColor = UIColor.customMidGrey.cgColor
        layer.borderWidth = 1
        layer.shadowColor = UIColor.customLightGrey.cgColor
        layer.shadowRadius = 3
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero
        
        addSubview(calendarTitle)
        calendarTitle.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 12, paddingLeft: 18, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        addSubview(container)
        container.anchor(top: calendarTitle.topAnchor, left: calendarTitle.leftAnchor, bottom: calendarTitle.bottomAnchor, right: calendarTitle.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0, paddingLeft: -6, paddingBottom: 0, paddingRight: -6, width: 0, height: 20)
        container.layer.cornerRadius = 10
        addSubview(eventTitle)
        eventTitle.anchor(top: calendarTitle.bottomAnchor, left: calendarTitle.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 6, paddingLeft: -6, paddingBottom: 0, paddingRight: 0, width: frame.width - 12, height: 0)
        addSubview(dueDate)
        dueDate.anchor(top: eventTitle.bottomAnchor, left: eventTitle.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class EventReminder: NSObject {
    let calendarTitle: String
    let timeFrame: String
    let eventTitle: String
    let startDate: Date
    init(event: EKEvent) {
        self.calendarTitle = event.calendar.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        self.timeFrame = dateFormatter.string(from: event.startDate) + " - " + dateFormatter.string(from: event.endDate)
        self.eventTitle = event.title
        self.startDate = event.startDate
    }

    
}

class SectionHeader: UICollectionViewCell {
    let titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(titleLabel)
        titleLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: centerYAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
