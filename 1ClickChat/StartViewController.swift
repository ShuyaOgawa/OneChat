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

class StartViewController: UIViewController {
    
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var ActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = Database.database().reference()
     /*   ref.child("user/all_member/0").setValue("must_not_delete")
        ref.child("user/waiting_member/0").setValue("must_not_delete")
        ref.child("chat_room/n1&n2/n1").setValue("~~~~")
        ref.child("chat_room/n1&n2/n2").setValue("~~~~")
       */
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func StartButton(_ sender: UIButton) {
        
        button.isEnabled = false
        
        let ref = Database.database().reference()
        
        ref.child("user").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as! NSDictionary
            let all_member_array = value["all_member"] as AnyObject
            let my_id = all_member_array.count
            ref.child("user/all_member/\(my_id!)").setValue(my_id!)
            print("11111111")
            
//            let waiting_member_array = value["waiting_member"] as AnyObject
            guard let waiting_member_array = value["waiting_member"] as? AnyObject else { return }
            
            print("22222222222")
            print(waiting_member_array)
            
            print("waiting_member_array?.count", waiting_member_array.count)
            //①自分が1人目のパターン
            if waiting_member_array.count == 1{
                print("33333333333")
                //ローディング
                self.loading()
                ref.child("user/waiting_member/\(my_id!)").setValue(my_id!)
                self.appDelegate.my_id = my_id! as AnyObject
                //2人目のユーザーが来るまでデータ取得
                ref.observe(.value, with: { snapshot in
                    print("4444444444")
                    let value = snapshot.value as? NSDictionary
                    let user_array = value?["user"] as AnyObject?
                    let waiting_member_array = user_array!["waiting_member"] as AnyObject?
                    if waiting_member_array!.count == 3 {
                        print("55555555555")
                        let all_member_array = user_array!["all_member"] as AnyObject?
                        let all_member_count = all_member_array?.count as Int?
                        self.appDelegate.your_id = all_member_count! - 1 as AnyObject
                        print("66666666666666")
                        //ロード終了
                        self.ActivityIndicator.stopAnimating()
                        print("7777777777777")
                        //chat_roomを作る
                        self.set_chat_room(my_id: self.appDelegate.my_id as! Int, your_id: self.appDelegate.your_id as! Int)
                        print("88888888888")
                        
                    }
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
            
            
            //②自分が２人目のパターン
            if waiting_member_array.count == 2{
                print("9999999999999")
                ref.child("user/waiting_member/\(my_id!)").setValue(my_id!)
                self.appDelegate.my_id = my_id as AnyObject?
                let all_member_array = value["all_member"] as AnyObject?
                let all_member_count = all_member_array?.count as Int?
                self.appDelegate.your_id = all_member_count! - 1 as AnyObject
                self.performSegue(withIdentifier: "SegueId", sender: self)
                print("aaaaaaaaaaaaaaa")
                
            }
            
            //③waiting_memberに3人入ってしまった時の処理
            
       
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    //chat_roomを作りwaiting_memberから削除する
    func set_chat_room(my_id: Int, your_id: Int){
        print("bbbbbbbbbbbb")
        let ref = Database.database().reference()
        ref.child("chat_room/\(my_id)&\(your_id)/dammy").setValue("~~~")
        ref.child("chat_room/\(my_id)&\(your_id)/dammy").setValue("~~~")
        //waiting_member消す
        ref.child("user/waiting_member/\(my_id)").removeValue()
        ref.child("user/waiting_member/\(your_id)").removeValue()
        print("cccccccccccccc")
        self.performSegue(withIdentifier: "SegueId", sender: self)
        print("ddddddddddddddd")
    }
   
    
    
    //ローディング
    func loading() {
        print("eeeeeeeeeee")
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
        print("fffffffffffff")
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

