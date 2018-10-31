//
//  ChatCell.swift
//  WhereApp
//
//  Created by Alessandro Perna on 02/02/17.
//  Copyright © 2017 VJTlabapple. All rights reserved.
//

import UIKit

class ChatCellSend: UICollectionViewCell {

    @IBOutlet weak var lblMessage:UILabel!
    @IBOutlet weak var lblData:UILabel!
    @IBOutlet weak var imvBackground:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    //MARK: - Class Properties
    
    class var nibName: UINib  {
        get{
            return UINib(nibName: "ChatCellSend" , bundle: nil)
        }
    }
    
    class var identifier: String  {
        get{
            return "ChatCellSend"
        }
    }
    class var size: CGSize {
        get{
            return CGSize(width: UIScreen.main.bounds.width, height: 80)
        }
    }
    
    var bckColor: UIColor?{
        
        didSet{
            imvBackground.tintColor = bckColor
        }
    }
    var txtColor: UIColor?{
        
        didSet{
            lblMessage.textColor = txtColor
        }
    }
    
    class func fromNib() -> ChatCellSend?{
        guard let nibView = Bundle.main.loadNibNamed("ChatCellSend", owner: nil, options: nil)?.first as? ChatCellSend
            else { return nil }
        return nibView
    }
    
    var chat: [String:Any]? {
        
        didSet{
            guard let chat = chat else { return }
            print("chat receive message: \(chat)")
            
            let attributeName = [NSAttributedString.Key.foregroundColor:txtColor ?? UIColor.black,
                                 NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16)]
            let attributeMessage = [NSAttributedString.Key.foregroundColor:txtColor ?? UIColor.black,
                                    NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)]
            
            let name = NSAttributedString(string: "\(chat["nickname"]!):\n", attributes: attributeName )
            let message = NSAttributedString(string: chat["message"] as! String, attributes: attributeMessage )
            
            let completeMessage = NSMutableAttributedString(attributedString: name)
            completeMessage.append(message)
            lblMessage.attributedText = completeMessage
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = "dd MMM HH:mm"
            lblData.text = dateFormatter.string(from: chat["sendDate"] as! Date)
            layoutIfNeeded()
            
        }
    }

        
    override func prepareForReuse() {
        lblData.text = nil
        lblMessage.text = nil
    }
    



}
