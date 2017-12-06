//
//  ViewController.swift
//  1ClickChat
//
//  Created by 小川秀哉 on 2017/10/25.
//  Copyright © 2017年 Digital Circus Inc. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase
import FirebaseDatabase

class ViewController: JSQMessagesViewController {
    
    var messages = [JSQMessage]()
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        let my_id = self.appDelegate.my_id!
        let your_id = self.appDelegate.your_id!
        print("111111111",type(of: my_id))
        print("111111111",your_id)
        
        senderDisplayName = String(describing: my_id)
        senderId = String(describing: your_id)
       
        let ref = Database.database().reference()
        ref.observe(.value, with: { snapshot in
            if (self.appDelegate.my_id != nil || self.appDelegate.your_id != nil) {
                print("22222222226666666666666666", my_id)
                print("22222222226666666666", your_id)
                let my_id = self.appDelegate.my_id!
                let your_id = self.appDelegate.your_id!
                print("2222222222", my_id)
                print("2222222222", your_id)
                let value = snapshot.value as! NSDictionary
                let whole_chat_room = value["chat_room"] as AnyObject
                
                //チャット終了処理
                if (my_id == nil || your_id == nil) {
                    print("44444444", my_id)
                    print("44444444", your_id)
                    self.end_of_chat()
                }
                
                
                if Int(truncating: my_id as! NSNumber) < Int(truncating: your_id as! NSNumber) {
                    
                    //                guard let chat_room = whole_chat_room["\(my_id)&\(your_id)"] as? Dictionary<String, AnyObject> else { return }
                    guard let chat_room = whole_chat_room["\(my_id)&\(your_id)"] as? Dictionary<String, AnyObject> else { return }
                    
                    guard let number_of_chat = chat_room.count - 1 as? Int else { return }
                    guard let chat_room_content = chat_room["\(number_of_chat)"] as? Dictionary<String, AnyObject> else { return }
                    for (key, value) in chat_room_content {
                        if key == String(describing: my_id) {
                            let text = value
                            
                            self.messages.append(JSQMessage(senderId: String(describing: your_id), displayName: String(describing: my_id), text: (text as! String )))
                        }
                        
                        if key == String(describing: your_id) {
                            let text = value
                            if text as! String == "退出しました。" {
                                self.end_of_chat()
                            }
                            self.messages.append(JSQMessage(senderId: String(describing: my_id), displayName: String(describing: your_id), text: (text as! String )))
                        }
                    }
                    
                    
                    self.collectionView.reloadData()
                }
               
                
                
                if Int(truncating: my_id as! NSNumber) > Int(truncating: your_id as! NSNumber) {
                    
                    
                    //                guard let chat_room = whole_chat_room["\(my_id)&\(your_id)"] as? Dictionary<String, AnyObject> else { return }
                    guard let chat_room = whole_chat_room["\(your_id)&\(my_id)"] as? Dictionary<String, AnyObject> else { return }
                    
                   
                    guard let number_of_chat = chat_room.count - 1 as? Int else { return }
                    guard let chat_room_content = chat_room["\(number_of_chat)"] as? Dictionary<String, AnyObject> else { return }
                   
                   
                    for (key, value) in chat_room_content {
                        if key == String(describing: my_id) {
                            let text = value
                            
                            self.messages.append(JSQMessage(senderId: String(describing: your_id), displayName: String(describing: my_id), text: (text as! String)))
                        }
                        
                        if key == String(describing: your_id) {
                            let text = value
                            if text as! String == "退出しました。" {
                                self.end_of_chat()
                            }
                            self.messages.append(JSQMessage(senderId: String(describing: my_id), displayName: String(describing: your_id), text: (text as! String)))
                        }
                    }
                    self.collectionView.reloadData()
                }
                }
            })
            
        
    }
    

    //添付ボタン＝ログアウトボタン
    override func didPressAccessoryButton(_ sender: UIButton!) {
        print("aaaaaaaaaaaaaaaaaaa")
        let alert: UIAlertController = UIAlertController(title: "", message: "チャットを終了してもよろしいですか？", preferredStyle:  UIAlertControllerStyle.alert)
        let ref = Database.database().reference()
        let my_id = self.appDelegate.my_id!
        let your_id = self.appDelegate.your_id!
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            if Int(truncating: my_id as! NSNumber) < Int(truncating: your_id as! NSNumber) {
                ref.child("chat_room").observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! NSDictionary
                    let chat_room = value["\(my_id)&\(your_id)"] as AnyObject
                    let number_of_chat = chat_room.count
                    let text = "退出しました。"
                    ref.child("chat_room/\(my_id)&\(your_id)/\(number_of_chat!)").updateChildValues(["\(my_id)": text])
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
            if Int(truncating: my_id as! NSNumber) > Int(truncating: your_id as! NSNumber) {
                ref.child("chat_room").observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! NSDictionary
                    let chat_room = value["\(your_id)&\(my_id)"] as AnyObject
                    let number_of_chat = chat_room.count
                    let text = "退出しました。"
                    ref.child("chat_room/\(your_id)&\(my_id)/\(number_of_chat!)").updateChildValues(["\(my_id)": text])
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
            
            let my_id: AnyObject? = nil
            let your_id: AnyObject? = nil
            self.appDelegate.my_id = nil
            self.appDelegate.your_id = nil
            print("33333333", my_id)
            print("33333333", your_id)
            self.performSegue(withIdentifier: "SegueId2", sender: self)
            print("bbbbbbbbbbbbbbbbbbbb")
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    func end_of_chat () {
        let alert: UIAlertController = UIAlertController(title: "チャットが終了しました", message: "ホームに戻ります。", preferredStyle:  UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            self.performSegue(withIdentifier: "SegueId2", sender: self)
            print("5555555555", self.appDelegate.my_id)
            print("55555555", self.appDelegate.your_id)
        })
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        var my_id: AnyObject?  = nil
        var your_id: AnyObject? = nil
        self.appDelegate.my_id = nil
        self.appDelegate.your_id = nil
    }
 
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        
        return messages[indexPath.row]
    }
    
    // コメントの背景色の指定
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        if messages[indexPath.row].senderId == senderId {
            return JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor(red: 112/255, green: 192/255, blue:  75/255, alpha: 1))
        } else {
            return JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1))
        }
        
       
        
    }
    
    // コメントの文字色の指定
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        if messages[indexPath.row].senderId == senderId {
            cell.textView.textColor = UIColor.white
        } else {
            cell.textView.textColor = UIColor.darkGray
        }
        return cell
    }
    
    // メッセージの数
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    // ユーザのアバターの設定
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        return JSQMessagesAvatarImageFactory.avatarImage(
            withUserInitials: messages[indexPath.row].senderDisplayName,
            backgroundColor: UIColor.lightGray,
            textColor: UIColor.white,
            font: UIFont.systemFont(ofSize: 10),
            diameter: 30)
    }
 
    
   
    
    
    // 送信ボタンを押した時の処理
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        inputToolbar.contentView.textView.text = ""
        let ref = Database.database().reference()
        let my_id = self.appDelegate.my_id!
        let your_id = self.appDelegate.your_id!
       
        if Int(truncating: my_id as! NSNumber) < Int(truncating: your_id as! NSNumber) {
            ref.child("chat_room").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as! NSDictionary
                let chat_room = value["\(my_id)&\(your_id)"] as AnyObject
                let number_of_chat = chat_room.count
                ref.child("chat_room/\(my_id)&\(your_id)/\(number_of_chat!)").updateChildValues(["\(my_id)": text])
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        if Int(truncating: my_id as! NSNumber) > Int(truncating: your_id as! NSNumber) {
            ref.child("chat_room").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as! NSDictionary
                let chat_room = value["\(your_id)&\(my_id)"] as AnyObject
                let number_of_chat = chat_room.count
                ref.child("chat_room/\(your_id)&\(my_id)/\(number_of_chat!)").updateChildValues(["\(my_id)": text])
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    
}

