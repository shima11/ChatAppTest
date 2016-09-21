//
//  ProfileViewController.swift
//  ChatAppTest
//
//  Created by shima jinsei on 2016/09/22.
//  Copyright © 2016年 Jinsei Shima. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var chatCountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var data: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = data?.name
        imageView.image = UIImage(named: (data?.imageString)!)
        chatCountLabel.text = "チャット回数：\(data?.messages.count)"
        dateLabel.text = "\(data?.messages.last?.date!)"
        
    }
}
