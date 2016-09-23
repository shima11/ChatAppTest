//
//  ProfileViewController.swift
//  ChatAppTest
//
//  Created by shima jinsei on 2016/09/22.
//  Copyright © 2016年 Jinsei Shima. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var chatCountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var person: PersonData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = person?.name
        imageView.image = UIImage(named: (person?.imageString)!)
        chatCountLabel.text = "チャット回数：\(person?.messages.count)"
        let lastMessage = NSKeyedUnarchiver.unarchiveObjectWithData((person?.messages.last?.message)!) as! JSQMessage
        dateLabel.text = "\(lastMessage.date)"
        
    }
}
