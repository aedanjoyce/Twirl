//
//  CustomMenu.swift
//  Twirl
//
//  Created by Aedan Joyce on 6/16/18.
//  Copyright © 2018 Aedan Joyce. All rights reserved.
//

import UIKit

class Menubar: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    let names = ["Lists", "Reminders"]
    weak var viewManager: HomeView?
    var selectedIndexPath: IndexPath? = IndexPath(item: 0, section: 0)
    private let cellId = "cellId"
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuBarCell
        cell.titleLabel.text = names[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size: CGSize = names[indexPath.row].size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12.0)])
        return CGSize(width: size.width + 30, height: 37)
    }

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.customMidGrey
        cv.dataSource = self
        cv.delegate = self
        layout.scrollDirection = .horizontal
        return cv
    }()
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewManager?.scrollToMenuIndex(menuIndex: indexPath.item)
        selectedIndexPath = indexPath
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedIndexPath = nil
    }
    let addButton: UIButton = {
       let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        button.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(handleCreate), for: .touchUpInside)
       return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.customMidGrey
        addSubview(addButton)
        addButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, centerX: nil, centerY: centerYAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: addButton.leftAnchor, centerX: nil, centerY: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        collectionView.register(MenuBarCell.self, forCellWithReuseIdentifier: cellId)
        let selectedIndexPath = NSIndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: [])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func handleCreate() {
        switch selectedIndexPath?.item {
        case 0:
            viewManager?.createTaskList()
        case 1:
            viewManager?.createReminder()
        default:
            fatalError()
        }
    }
    @objc func createTaskList() {
        
    }
    @objc func createReminder() {
        
    }
    
}
class MenuBarCell: UICollectionViewCell {
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.095, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.backgroundColor = self.isHighlighted ? .selectedGrey : .customMidGrey
                self.titleLabel.textColor = self.isHighlighted ? UIColor.menuPurple : UIColor.customDarkGrey
            }, completion: nil)
        }
    }
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.095, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.backgroundColor = self.isSelected ? .selectedGrey : .customMidGrey
                self.titleLabel.textColor = self.isSelected ? UIColor.menuPurple : UIColor.customDarkGrey
            }, completion: nil)
        }
    }
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.customDarkGrey
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.customMidGrey
        layer.cornerRadius = 15
        addSubview(titleLabel)
        titleLabel.anchor(top: nil, left: nil, bottom: nil, right: nil, centerX: centerXAnchor, centerY: centerYAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension HomeView {
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = NSIndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath as IndexPath, animated: false, scrollPosition: [])
    }
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: [], animated: true)
    }
}
