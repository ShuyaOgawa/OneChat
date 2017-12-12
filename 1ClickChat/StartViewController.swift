//
//  StartViewController.swift
//  1ClickChat
//
//  Created by 小川秀哉 on 2017/11/19.
//  Copyright © 2017年 Digital Circus Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import VideoSplashKit

class StartViewController: VideoSplashViewController {
    
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var ActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var LookButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        custom_button()
        setupVideo()
     /*   ref.child("user/all_member/0").setValue("must_not_delete")
        ref.child("user/waiting_member/0").setValue("must_not_delete")
        ref.child("chat_room/n1&n2/n1").setValue("~~~~")
        ref.child("chat_room/n1&n2/n2").setValue("~~~~")
       */
    }
    
    func custom_button() {
        StartButton.layer.cornerRadius = 5
        LookButton.layer.cornerRadius = 5
//        StartButton.layer.borderWidth = 1
//        StartButton.layer.borderColor = UIColor.black.cgColor
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupVideo() {
        if let path = Bundle.main.path(forResource: "live-aloha", ofType: "mp4") {
            let url = NSURL.fileURL(withPath: path)
            videoFrame = view.frame
            fillMode = .resizeAspectFill
            alwaysRepeat = true
            restartForeground = true
            sound = false
            startTime = 0.0
            duration = 0.0
            alpha = 0.7
            backgroundColor = UIColor.black
            contentURL = url
        }
    }
    
    
    @IBAction func StartButton(_ sender: UIButton) {
        let my_id: AnyObject? = nil
        let your_id: AnyObject? = nil
        self.appDelegate.my_id = nil
        self.appDelegate.your_id = nil
        print("66666666", self.appDelegate.my_id)
        print("6666666666", self.appDelegate.your_id)
        StartButton.isEnabled = false
        print("66666666888888888888", self.appDelegate.my_id)
        print("666666666688888888888888", self.appDelegate.your_id)
        let ref = Database.database().reference()
        
        ref.child("user").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            print("7777777777", self.appDelegate.my_id)
            print("7777777777", self.appDelegate.your_id)
            let value = snapshot.value as! NSDictionary
            let all_member_array = value["all_member"] as AnyObject
            let my_id = all_member_array.count
//            ref.child("user/all_member/\(my_id!)").setValue(my_id!)
            ref.child("user/all_member").updateChildValues(["\(my_id!)": my_id!])
            
//            let waiting_member_array = value["waiting_member"] as AnyObject
            guard let waiting_member_array = value["waiting_member"] as? AnyObject else { return }
            
           
            
            
            //①自分が1人目のパターン
            if waiting_member_array.count == 1{
                
                //ローディング
                self.loading()
                
                ref.child("user/waiting_member").updateChildValues(["\(my_id!)": my_id!])
                self.appDelegate.my_id = my_id! as AnyObject
                print("9999999999992222222222222", self.appDelegate.my_id)
                print("99999999992222222222222", self.appDelegate.your_id)
                //2人目のユーザーが来るまでデータ取得
                ref.observe(.value, with: { snapshot in
                    print("error")
                    let value = snapshot.value as? NSDictionary
                    let user_array = value?["user"] as AnyObject?
                    let waiting_member_array = user_array!["waiting_member"] as AnyObject?
                    if waiting_member_array!.count == 3 {
                        let all_member_array = user_array!["all_member"] as AnyObject?
                        let all_member_count = all_member_array?.count as Int?
                        self.appDelegate.your_id = all_member_count! - 1 as AnyObject
                        print("heeeyy")
                        //ロード終了
                        self.ActivityIndicator.stopAnimating()
                        ref.removeAllObservers()
                        //chat_roomを作る
                        self.set_chat_room(my_id: self.appDelegate.my_id as! Int, your_id: self.appDelegate.your_id as! Int)
                       
                        
                    }
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
            
            
            //②自分が２人目のパターン
            if waiting_member_array.count == 2{
               
                ref.child("user/waiting_member").updateChildValues(["\(my_id!)": my_id!])
                self.appDelegate.my_id = my_id as AnyObject?
                print("2 pattern", self.appDelegate.my_id)
                let all_member_array = value["all_member"] as AnyObject?
                let all_member_count = all_member_array?.count as Int?
                self.appDelegate.your_id = all_member_count! - 1 as AnyObject
                print("2 pattern", self.appDelegate.your_id)
                print("self.appDelegate.my_id", self.appDelegate.my_id!)
                print("self.appDelegate.your_id", self.appDelegate.your_id!)
                ref.removeAllObservers()
                self.performSegue(withIdentifier: "SegueId", sender: self)
            
            }
            
            //③waiting_memberに3人入ってしまった時の処理
            
       
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    //chat_roomを作りwaiting_memberから削除する
    func set_chat_room(my_id: Int, your_id: Int){
        print("888888888", my_id)
        print("88888888", your_id)
        let ref = Database.database().reference()
        ref.child("chat_room/\(my_id)&\(your_id)").updateChildValues(["dammy": "~~~"])
      
        //waiting_member消す
        ref.child("user/waiting_member/\(my_id)").removeValue()
        ref.child("user/waiting_member/\(your_id)").removeValue()
        

        self.performSegue(withIdentifier: "SegueId", sender: self)
        
    }
   
    
    
    //ローディング
    func loading() {
        print("999999999999", self.appDelegate.my_id)
        print("9999999999", self.appDelegate.your_id)
        // ActivityIndicatorを作成＆中央に配置
        self.ActivityIndicator = UIActivityIndicatorView()
        self.ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.ActivityIndicator.center = self.view.center
        // クルクルをストップした時に非表示する
        self.ActivityIndicator.hidesWhenStopped = true
        // 色を設定
        self.ActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        self.ActivityIndicator.backgroundColor = UIColor.gray
        self.ActivityIndicator.layer.opacity = 0.6
        //Viewに追加
        self.view.addSubview(self.ActivityIndicator)
        
        //ロードスタート
        self.ActivityIndicator.startAnimating()
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    
}

