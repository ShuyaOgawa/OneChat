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
        
        senderDisplayName = String(describing: my_id)
        senderId = String(describing: your_id)
        
        
        let ref = Database.database().reference()
        ref.observe(.value, with: { snapshot in
            sleep(UInt32(0.5))
            let value = snapshot.value as! NSDictionary
            let whole_chat_room = value["chat_room"] as AnyObject
          
            if Int(truncating: my_id as! NSNumber) < Int(truncating: your_id as! NSNumber) {
                
                print("value", value)
                print("whole_chat", whole_chat_room)
                print("type", type(of: whole_chat_room))
                guard let chat_room = whole_chat_room["\(my_id)&\(your_id)"] as? Dictionary<String, AnyObject>
                else {
                    return
                }
                
              
                print(chat_room)
                for (key, value) in chat_room {
                    
                    
                    if key == String(describing: my_id) {
                        let text = value
                        self.messages.append(JSQMessage(senderId: String(describing: your_id), displayName: String(describing: my_id), text: (text as! String )))
                    }
                    
                    if key == String(describing: your_id) {
                        let text = value
                        self.messages.append(JSQMessage(senderId: String(describing: my_id), displayName: String(describing: your_id), text: (text as! String )))
                    }
                }
                
                
                self.collectionView.reloadData()
            }
           
            
            
            if Int(truncating: my_id as! NSNumber) > Int(truncating: your_id as! NSNumber) {
                guard let chat_room = whole_chat_room["\(your_id)&\(my_id)"] as? Dictionary<String, AnyObject>
                    else {
                        return
                }
            
                for (key, value) in chat_room {
                    
                    if key == String(describing: my_id) {
                        let text = value
                        self.messages.append(JSQMessage(senderId: String(describing: your_id), displayName: String(describing: my_id), text: (text as! String)))
                    }
                    
                    if key == String(describing: your_id) {
                        let text = value
                        self.messages.append(JSQMessage(senderId: String(describing: my_id), displayName: String(describing: your_id), text: (text as! String)))
                    }
                }
                
                
                self.collectionView.reloadData()
            }
         
        })
    }
    
    
    
    
    
 
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        print("1")
        return messages[indexPath.row]
    }
    
    // コメントの背景色の指定
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
         print("2")
        if messages[indexPath.row].senderId == senderId {
            return JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor(red: 112/255, green: 192/255, blue:  75/255, alpha: 1))
        } else {
            return JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1))
        }
        
       
        
    }
    
    // コメントの文字色の指定
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         print("3")
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
         print("4")
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
         print("6")
        inputToolbar.contentView.textView.text = ""
        let ref = Database.database().reference()
        let my_id = self.appDelegate.my_id!
        let your_id = self.appDelegate.your_id!
        let senderDisplayName = String(describing: my_id)
        let senderId = String(describing: your_id)
        if Int(truncating: my_id as! NSNumber) < Int(truncating: your_id as! NSNumber) {
            ref.child("chat_room/\(my_id)&\(your_id)/\(senderDisplayName)").setValue(text)
        }
        if Int(truncating: my_id as! NSNumber) > Int(truncating: your_id as! NSNumber) {
            ref.child("chat_room/\(your_id)&\(my_id)/\(senderDisplayName)").setValue(text)
        }
    }
    
    
}

