//
//  PersonData.swift
//  ChatAppTest
//
//  Created by shima jinsei on 2016/09/23.
//  Copyright © 2016年 Jinsei Shima. All rights reserved.
//

import Foundation
import RealmSwift

class PersonData: Object {
    static let realm = try! Realm()
    
    dynamic var id = 0
    dynamic var name: String = ""
    dynamic var imageString: String = ""
    let messages = List<MessageData>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // id auto increment
    static func lastId() -> Int {
        if let user = realm.objects(PersonData).last {
            return user.id + 1
        } else {
            return 1
        }
    }
    
    // get all data
    static func loadAll() -> [PersonData] {
        let users = realm.objects(PersonData).sorted("id", ascending: false)
        var ret: [PersonData] = []
        for user in users {
            ret.append(user)
        }
        return ret
    }
    
    // addのみ
    func save() {
        try! PersonData.realm.write {
            PersonData.realm.add(self)
        }
    }
    // update クロージャ内でプロパティを書き換える
    func update(method: (() -> Void)) {
        try! PersonData.realm.write {
            method()
        }
    }
}

class MessageData: Object {
    let person = LinkingObjects(fromType: PersonData.self, property: "messages") // バックリンク
    dynamic var message: NSData? // JSQMessageのアーカイブデータ
}
