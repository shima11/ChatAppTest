//
//  ViewController.swift
//  ChatAppTest
//
//  Created by shima jinsei on 2016/09/21.
//  Copyright © 2016年 Jinsei Shima. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import RealmSwift

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var persons:[Person] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.backgroundColor = UIColor.lightGrayColor()
        
        // test data
        var person = Person(name: "satoshi", imageString: "person2", messages: []) // チャット相手
        let message = JSQMessage(senderId: "satoshi",  displayName: "satoshi", text: "こんにちは!")
        person.messages.append(message)
        persons.append(person)
        
        
        // 通常のSwiftのオブジェクトと同じように扱えます
        let hoge = PersonData()
        hoge.name = "takashi"
        hoge.imageString = "person"
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(hoge)
        }

        
        self.tableView.reloadData()
        
    }
    
    override func viewDidLayoutSubviews() {
        // UIView Layout init
    }
    
    override func viewWillDisappear(animated: Bool) {
        print("viewwilldissapear")
    }
    override func viewWillAppear(animated: Bool) {
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            // cell selectedを解除
            self.tableView.deselectRowAtIndexPath(indexPathForSelectedRow, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addUserAction(sender: AnyObject) {
        var person = Person(name: "hiro", imageString: "person2", messages: []) // チャット相手
        let message = JSQMessage(senderId: "hiro",  displayName: "hiro", text: "hello my name is hiro")
        person.messages.append(message)
        persons.append(person)
        
        self.tableView.reloadData()
    }

}

extension ViewController: UITableViewDelegate {
//    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        print("selected")
//    }
}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let cell = UITableViewCell.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = persons[indexPath.row].name
        let lastChat = persons[indexPath.row].messages.last
        cell.detailTextLabel?.text = lastChat?.text
        cell.imageView?.image = UIImage(named: persons[indexPath.row].imageString)
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("selected:\(indexPath.row)")
        let chatViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ChatViewController") as! ChatViewController
        chatViewController.data = persons[indexPath.row]
        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
}

