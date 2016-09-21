//
//  Person.swift
//  ChatAppTest
//
//  Created by shima jinsei on 2016/09/21.
//  Copyright © 2016年 Jinsei Shima. All rights reserved.
//

import Foundation
import JSQMessagesViewController

struct Person {
    let name: String
    let imageString: String
    var messages: [JSQMessage] // チャット内容の配列
    
    init(){
        name = "hoge"
        imageString = "person.png"
        messages = []
    }
    init(name: String, imageString: String, messages: [JSQMessage]){
        self.name = name
        self.imageString = imageString
        self.messages = messages
    }
}
