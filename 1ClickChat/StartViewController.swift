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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let ref = Database.database().reference()
        ref.child("user/all_member/0").setValue("must_not_delete")
        ref.child("user/waiting_member/0").setValue("must_not_delete")
        ref.child("chat_room/n1&n2/n1").setValue("~~~~")
        ref.child("chat_room/n1&n2/n2").setValue("~~~~")


        // Do any additional setup after loading the view.
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func StartButton(_ sender: UIButton) {
        
        let ref = Database.database().reference()
   
        ref.child("user").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let all_member_array = value?["all_member"] as AnyObject?
            let my_id = all_member_array?.count
            ref.child("user/all_member/\(my_id!)").setValue(my_id!)
            let waiting_member_array = value?["waiting_member"] as AnyObject?
            
            //①自分が1人目のパターン
            if waiting_member_array?.count == 1{
                print("pattern 1")
                ref.child("user/waiting_member/\(my_id!)").setValue(my_id!)
                self.appDelegate.my_id = my_id! as AnyObject
                //2人目のユーザーが来るまでデータ取得
                while waiting_member_array?.count == 1 {
                    let ref = Database.database().reference()
                    print("while")
                    print(waiting_member_array?.count)
                    ref.child("user").observeSingleEvent(of: .value, with: { (snapshot) in
                        let value = snapshot.value as? NSDictionary
                        print("ループ")
                        let waiting_member_array = value?["waiting_member"] as AnyObject?
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                }
                print("well done")
                
            }
            
            
            //②自分が２人目のパターン
            if waiting_member_array?.count == 2{
                print("pattern 2")
                ref.child("user/waiting_member/\(my_id!)").setValue(my_id!)
                self.appDelegate.my_id = my_id as AnyObject?
                self.appDelegate.your_id = waiting_member_array?[1] as AnyObject?
            }
            
            //③waiting_memberに3人入ってしまった時の処理
            
            
           
            /*
            ref.child("user/waiting_member/\(my_id!)").setValue(my_id!)
            self.appDelegate.my_id = all_member_array?.count as AnyObject
            
            self.appDelegate.my_id = all_member_array?.count as AnyObject?
            self.appDelegate.your_id = waiting_member_array?[1] as AnyObject?
             ref.child("user/all_member/\(self.appDelegate.my_id!)").setValue(self.appDelegate.my_id!)
             ref.child("user/waiting_member/\((waiting_member_array?.count)!)").setValue(self.appDelegate.my_id!)
           */
            
            
            
           
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
      
        
        self.performSegue(withIdentifier: "SegueId", sender: self)
        /*
         ref.child("messages").child("-KzIaGarqKKCP7wkHf-E").observeSingleEvent(of: .value, with: { (snapshot) in
         // Get user value
         let value = snapshot.value as? NSDictionary
         print(value)
         let username = value?["text"] as? String ?? ""
         print("aaaaaaaaaaaaaaa")
         print(username)
         }) { (error) in
         print(error.localizedDescription)
         }
         */
       
//        ref.child("user/01").setValue("2")
//        ref.child("user/02").setValue("2")
//        ref.child("user/02").setValue("3")
//        ref.child("user/03")
 /*       for i in 0..<1{
            ref.child("user/all_member/\(i)").setValue("must_not_delete")
        }
*/
/*        let data = [0]
        ref.child("user/all_member").setValue(data)
        
 */
        
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
