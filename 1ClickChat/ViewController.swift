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
    weak var ref2: DatabaseReference? = nil
    weak var value: NSDictionary? = nil
    var number_of_chat: Int? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let my_id = self.appDelegate.my_id!
        let your_id = self.appDelegate.your_id!
        
        senderDisplayName = String(describing: my_id)
        senderId = String(describing: your_id)
        
        if Int(truncating: my_id as! NSNumber) < Int(truncating: your_id as! NSNumber) {
            print("iffffff")
            var ref2 = Database.database().reference().child("chat_room/\(my_id)&\(your_id)")
            ref2.observe(.value, with: { snapshot in
                if (self.appDelegate.my_id != nil && self.appDelegate.your_id != nil) {
                    let value = snapshot.value as! NSDictionary
                    let number_of_chat = value.count - 1
                    guard let chat_room_content = value["\(number_of_chat)"] as? Dictionary<String, AnyObject> else { return }
                    self.get_message(ref2: ref2, my_id: my_id as! Int, your_id: your_id as! Int, value: value, number_of_chat: number_of_chat, chat_room_content: chat_room_content)
                }
            })
        }
        if Int(truncating: my_id as! NSNumber) > Int(truncating: your_id as! NSNumber) {
            var ref2 = Database.database().reference().child("chat_room/\(your_id)&\(my_id)")
            ref2.observe(.value, with: { snapshot in
                if (self.appDelegate.my_id != nil && self.appDelegate.your_id != nil) {
                    guard let value = snapshot.value as? NSDictionary else {return}
                    let number_of_chat = value.count - 1
                    guard let chat_room_content = value["\(number_of_chat)"] as? Dictionary<String, AnyObject> else { return }
                    self.get_message(ref2: ref2, my_id: my_id as! Int, your_id: your_id as! Int, value: value, number_of_chat: number_of_chat, chat_room_content: chat_room_content)
                }
            })
            
        }
            
        
    }
    
    
    
    func get_message(ref2: DatabaseReference, my_id: Int, your_id: Int, value: NSDictionary, number_of_chat: Int, chat_room_content: Dictionary<String, AnyObject>) {
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
        
        
    

    //添付ボタン＝ログアウトボタン
    override func didPressAccessoryButton(_ sender: UIButton!) {
        let ref = Database.database().reference()
        let alert: UIAlertController = UIAlertController(title: "", message: "チャットを終了してもよろしいですか？", preferredStyle:  UIAlertControllerStyle.alert)
        
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
                    self.ref2?.removeAllObservers()
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
            self.ref2?.removeAllObservers()
            let my_id: AnyObject? = nil
            let your_id: AnyObject? = nil
            self.appDelegate.my_id = nil
            self.appDelegate.your_id = nil
            self.performSegue(withIdentifier: "SegueId2", sender: self)
        })
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("disappearrrrrrrrrrrrr")
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

