//
//  PersonData.swift
//  ChatAppTest
//
//  Created by shima jinsei on 2016/09/23.
//  Copyright © 2016年 Jinsei Shima. All rights reserved.
//

import Foundation
import JSQMessagesViewController
import RealmSwift

class PersonData: Object {
    dynamic var name: String = ""
    dynamic var imageString: String = ""
    //dynamic var messages: [JSQMessage] = [] // チャット内容の配列
    
}

