//
//  ChatCell.swift
//  WhereApp
//
//  Created by Alessandro Perna on 02/02/17.
//  Copyright © 2017 VJTlabapple. All rights reserved.
//

import UIKit

class ChatCellReceive: UICollectionViewCell {

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
            return UINib(nibName: "ChatCellReceive" , bundle: nil)
        }
    }
    
    class var identifier: String  {
        get{
            return "ChatCellReceive"
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
    
    class func fromNib() -> ChatCellReceive?{
        guard let nibView = Bundle.main.loadNibNamed("ChatCellReceive", owner: nil, options: nil)?.first as? ChatCellReceive
            else { return nil }
        return nibView
    }

    
    var chat: WAChatMessage? {
    
        didSet{
            guard let chat = chat else { return }
            print("chat receive message: \(chat)")

            let attributeName = [NSAttributedStringKey.foregroundColor:txtColor ?? UIColor.black,
                                 NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 16)]
            let attributeMessage = [NSAttributedStringKey.foregroundColor:txtColor ?? UIColor.black,
                                    NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16)]
            
            let name = NSAttributedString(string: "\(chat.nickname.removingPercentEncoding!):\n", attributes: attributeName )
            let message = NSAttributedString(string: chat.testo, attributes: attributeMessage )
            
            let completeMessage = NSMutableAttributedString(attributedString: name)
            completeMessage.append(message)
            lblMessage.attributedText = completeMessage
            
            let dateFormatter = DateFormatter()

            if
                let languageCode = RegistrationManager.sharedInstance.language,
                let lang = InternalLanguage(rawValue: languageCode)?.getLanguageAndRegion()
            {
                dateFormatter.locale = Locale(identifier: lang)
            }
            dateFormatter.dateFormat = "dd MMM HH:mm"
            lblData.text = dateFormatter.string(from: chat.datainvio as Date)
            layoutIfNeeded()

        }
    }
    
    override func prepareForReuse() {
        lblData.text = nil
        lblMessage.text = nil
    }
    



}
