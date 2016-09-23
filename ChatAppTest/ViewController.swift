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
    
    var persons:[PersonData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.backgroundColor = UIColor.lightGrayColor()
    }
    
    override func viewDidLayoutSubviews() {
        // UIView Layout init
    }
    
    override func viewWillAppear(animated: Bool) {
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            // cell selectedを解除
            self.tableView.deselectRowAtIndexPath(indexPathForSelectedRow, animated: true)
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.persons = PersonData.loadAll()
        self.tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func addUserAction(sender: AnyObject) {
        self.addUserData()
        self.tableView.reloadData()
    }
    
    
    func addUserData(){
        let message = JSQMessage(senderId: "satoshi",  displayName: "satoshi", text: "こんにちは!")
        
        let chat = MessageData()
        chat.message = NSKeyedArchiver.archivedDataWithRootObject(message)
        
        let person = PersonData(value: ["name": "satoshi", "imageString": "person1"])
        person.messages.append(chat)
        person.id = PersonData.lastId()
        
        person.save()
        
        self.persons.append(person)
    }
    
//    func getData() {
//        self.persons = PersonData.loadAll()
//    }

}

extension ViewController: UITableViewDelegate {

}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let cell = UITableViewCell.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = persons[indexPath.row].name
        // 最後のチャットを表示
        let messageData = persons[indexPath.row].messages
        let lastMessage = NSKeyedUnarchiver.unarchiveObjectWithData((messageData.last?.message)!) as! JSQMessage
        cell.detailTextLabel?.text = lastMessage.text
        cell.imageView?.image = UIImage(named: persons[indexPath.row].imageString)
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //画面遷移
        let chatViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ChatViewController") as! ChatViewController
        chatViewController.person = self.persons[indexPath.row]
        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
}

