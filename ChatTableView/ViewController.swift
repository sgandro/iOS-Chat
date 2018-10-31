//
//  ViewController.swift
//  ChatTableView
//
//  Created by Alessandro Perna on 19/10/2018.
//  Copyright © 2018 Alessandro Perna. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var keyboardConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonSend:UIButton!
    @IBOutlet weak var textContentConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtMessageView: UITextView!

    var dataSource:[[String:Any]] = [["received":true,"nickname":"Mario","message":"Ciao Giorgio e benvenuto","sendDate":NSDate()],
                                     ["received":false,"nickname":"Giorgio","message":"Grazie!! :-)","sendDate":NSDate()]]{
        didSet{
            moveOnLastMessage()
        }
    }
    
    static let padding:CGFloat = 40.0
    static let maxLineInTextContent:CGFloat = 6.0
    static let minTextContentHeight:CGFloat = 28.0
    static let maxTextContentChars:Int = 640

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleCollectionViewTap(_:)))
        tap.numberOfTapsRequired = 1
        self.collectionView.addGestureRecognizer(tap)
        
        buttonSend.isEnabled = false
    
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name:UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name:UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        
    }
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        
        //recalculate the collection view layout when the view layout changes
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
        
        
        
        
    }


    @objc internal func handleCollectionViewTap(_ tap: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    fileprivate func configureCollectionView(){
        
        collectionView.register(ChatCellSend.nibName, forCellWithReuseIdentifier: ChatCellSend.identifier)
        collectionView.register(ChatCellReceive.nibName, forCellWithReuseIdentifier: ChatCellReceive.identifier)
    }

    //MARK: - Keyboards Notifications
    
    @objc func keyboardWillShow(notification: Notification){
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber) as? TimeInterval  ?? 0.0
            let curve: UIView.AnimationOptions = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber).map { UIView.AnimationOptions(rawValue: UInt(truncating: $0)) } ?? UIView.AnimationOptions.curveLinear
            
            self.keyboardConstraint.constant = keyboardSize.size.height - (self.tabBarController?.tabBar.frame.height ?? 0)
            
            UIView.animate(withDuration: duration, delay: 0.0, options: curve, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        
    }
    
    @objc func keyboardWillHide(notification: Notification){
        
        let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber) as? TimeInterval  ?? 0.0
        let curve: UIView.AnimationOptions = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber).map { UIView.AnimationOptions(rawValue: UInt(truncating: $0)) } ?? UIView.AnimationOptions.curveLinear
        
        self.keyboardConstraint.constant = 0
        
        UIView.animate(withDuration: duration, delay: 0.0, options: curve, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    

    
    //MARK:- Actions
    
    @IBAction func buttonSendPressed(button:UIButton){
        
        buttonSend.isEnabled = false
        //self.view.endEditing(true) // keyboard close
        
        if txtMessageView.text.isEmpty == false{
            dataSource.append(["received":false,"nickname":"Giorgio","message":txtMessageView.text!,"sendDate":NSDate()])
        }
        
        txtMessageView.text = nil
    }
    
    @IBAction func buttonAddPressed(button:UIButton){
        // Add Button pressed
    }

    //MARK: - Private
    
    private func moveOnLastMessage(){
        
        collectionView.reloadData()
        collectionView.performBatchUpdates({
            //update
        }) { [weak self](done) in
            guard let weakSelf = self else { return }
            let items: Int = weakSelf.collectionView.numberOfItems(inSection: 0)
            if items > 0 {
                
                let indexPath = IndexPath(item: items-1, section: 0)
                weakSelf.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition.top)
            }
        }
    }


}

extension ViewController: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let chat = dataSource[indexPath.row]
        if chat["received"]! as! Bool == true{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatCellReceive.identifier,
                                                          for: indexPath) as! ChatCellReceive
            
            cell.chat = chat
            cell.bckColor = UIColor.cyan
            cell.txtColor = UIColor.blue
            
            return cell

        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatCellSend.identifier,
                                                          for: indexPath) as! ChatCellSend
            
            cell.chat = chat
            cell.bckColor = UIColor.lightGray
            cell.txtColor = UIColor.black

            return cell

        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let chat = dataSource[indexPath.row]
        if chat["received"]! as! Bool == true{
            
            if let cell = ChatCellReceive.fromNib() {
                let cellMargins = cell.layoutMargins.left + cell.layoutMargins.right
                cell.chat = chat
                
                cell.lblMessage.preferredMaxLayoutWidth = (collectionView.contentSize.width - ViewController.padding) - cellMargins
                var size = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                size.width = ChatCellReceive.size.width
                return size
            }

        }else{
            
            if let cell = ChatCellSend.fromNib() {
                let cellMargins = cell.layoutMargins.left + cell.layoutMargins.right
                cell.chat = chat
                
                cell.lblMessage.preferredMaxLayoutWidth = (collectionView.contentSize.width - ViewController.padding) - cellMargins
                var size = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                size.width = collectionView.contentSize.width
                return size
            }

        }

        
        return CGSize.zero
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

extension ViewController: UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
 
        let maxHeight = textView.font!.lineHeight * ViewController.maxLineInTextContent
        let size = textView.sizeThatFits(CGSize(width:textView.frame.size.width, height:maxHeight))
        
        let lowHeight = (size.height > ViewController.minTextContentHeight ? size.height : ViewController.minTextContentHeight)
        let height = lowHeight <= maxHeight ? lowHeight: maxHeight
        
        textContentConstraint.constant = height
        textView.layoutIfNeeded()
        
        buttonSend.isEnabled = (!textView.text.isEmpty || !text.isEmpty)
        
        if textView.text.count > ViewController.maxTextContentChars{
            if let str = textView.text{
                let index = str.index(str.startIndex, offsetBy: ViewController.maxTextContentChars)
                textView.text = String(str[..<index])
            }
        }

        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        buttonSend.isEnabled = !textView.text.isEmpty
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        textContentConstraint.constant = ViewController.minTextContentHeight
    }
    
    
}
