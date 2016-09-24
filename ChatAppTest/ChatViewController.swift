//
//  ChatViewConrtoller.swift
//  ChatAppTest
//
//  Created by shima jinsei on 2016/09/21.
//  Copyright © 2016年 Jinsei Shima. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import RealmSwift

class ChatViewController: JSQMessagesViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var person:PersonData = PersonData() // 相手の情報とこれまでのチャットログを保持
    var messages:[JSQMessage] = [] // チャットのログ
    
    let myId:String = "myname"
    
    private var userAvatar: [JSQMessagesAvatarImage] = [] //アバター画像をセット

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title =  self.person.name
        self.collectionView.backgroundColor = UIColor.whiteColor()
        
        // 必須
        self.senderDisplayName = myId
        self.senderId = myId // 自分の名前
        
        //ユーザアイコンを設定（avatar1:相手、avatar2:自分）
        let avatar1 = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: self.person.imageString)!, diameter: 128)
        let avatar2 =  JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "person1")!, diameter: 64)
        userAvatar.append(avatar1)
        userAvatar.append(avatar2)
        
        // keyboard外をタップした時の処理
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.DismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        // メッセージをアンアーカイブしてJSQMessage配列に入れ直す
        for data in self.person.messages {
            messages.append(NSKeyedUnarchiver.unarchiveObjectWithData(data.message!)! as! JSQMessage)
        }
        
    }
    
    // keyboard以外をタップした時のイベント
    func DismissKeyboard(){
        // keyboard を閉じる
        self.inputToolbar.contentView.textView.resignFirstResponder()
    }
    
    // セルのデータを指定
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }
    
    // 吹き出しの背景色
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        if messages[indexPath.row].senderId == senderId {
            return JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(
                UIColor.lightGrayColor()) // 自分
        } else {
            return JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(
                UIColor.darkGrayColor()) // 相手
        }
    }
    
    // コメントの文字色
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as? JSQMessagesCollectionViewCell
        if messages[indexPath.row].senderId == senderId {
            cell?.textView?.textColor = UIColor.darkGrayColor() // 自分
        } else {
            cell?.textView?.textColor = UIColor.whiteColor() // 相手
        }
        
        // ユーザーアイコンに対してジェスチャーをつける
        let avatarImageTap = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.tappedAvatar))
        cell?.avatarImageView?.userInteractionEnabled = true
        cell!.avatarImageView?.addGestureRecognizer(avatarImageTap)
        
        return cell!
    }
    // ユーザアイコン　タップ
    func tappedAvatar() {
        print("tapped user avatar")
        // TODO: 自分と相手のアイコンのタップの判定処理
        
        let profileViewController = self.storyboard!.instantiateViewControllerWithIdentifier( "ProfileViewController" ) as! ProfileViewController
        profileViewController.person = self.person
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    // コメント数
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    // 表示するユーザーアイコンを指定。（nilを指定すると画像がでない）
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        if messages[indexPath.row].senderId == person.name { // 相手
            return userAvatar[0]
        } else if messages[indexPath.row].senderId == senderId { // 自分
            return userAvatar[1]
        } else {
            return nil
        }
        
    }
    
    
    // MARK: send button tapped
    // 送信ボタンを押した時の挙動
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        print("send text")
        let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text)
        messages.append(message)
        
        self.saveChatData(message)
        
        // 更新
        finishSendingMessageAnimated(true)
        
        // keyboard を閉じる
        //self.inputToolbar.contentView.textView.resignFirstResponder()
    }
    
    // 送信時刻を出すために高さを調整する
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item]
        if indexPath.item == 0 {
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
        }
        if indexPath.item - 1 > 0 {
            let previousMessage = messages[indexPath.item - 1]
            if message.date.timeIntervalSinceDate(previousMessage.date) / 60 > 1 {
                return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
            }
        }
        return nil
    }
    
    // 送信時刻を出すために高さを調整する
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if indexPath.item == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        if indexPath.item - 1 > 0 {
            let previousMessage = messages[indexPath.item - 1]
            let message = messages[indexPath.item]
            if message.date.timeIntervalSinceDate(previousMessage.date) / 60 > 1 {
                return kJSQMessagesCollectionViewCellLabelHeightDefault
            }
        }
        return 0.0
    }
    
    
    // MARK: photo upload
    override func didPressAccessoryButton(sender: UIButton!) {
        print("didpress accessorybutton")
        selectImage()
    }
    private func selectImage() {
        let alertController = UIAlertController(title: "画像を選択", message: nil, preferredStyle: .ActionSheet)
        let cameraAction = UIAlertAction(title: "カメラを起動", style: .Default) { (UIAlertAction) -> Void in
            self.selectFromCamera()
        }
        let libraryAction = UIAlertAction(title: "カメラロールから選択", style: .Default) { (UIAlertAction) -> Void in
            self.selectFromLibrary()
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel) { (UIAlertAction) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerEditedImage] {
            sendImageMessage(image as! UIImage)
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    private func sendImageMessage(image: UIImage) {
        let photoItem = JSQPhotoMediaItem(image: image)
        let imageMessage = JSQMessage(senderId: senderId, displayName: senderDisplayName, media: photoItem)
        messages.append(imageMessage)
        finishSendingMessageAnimated(true)
    }
    private func selectFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
            imagePickerController.allowsEditing = true
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        } else {
            print("カメラ許可をしていない時の処理")
        }
    }
    
    private func selectFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePickerController.allowsEditing = true
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        } else {
            print("カメラロール許可をしていない時の処理")
        }
    }
    
    
    // chatログを保存
    func saveChatData(message:JSQMessage){
        let chat = MessageData()
        chat.message = NSKeyedArchiver.archivedDataWithRootObject(message)
        self.person.update { 
            self.person.messages.append(chat)
        }
    }


}


