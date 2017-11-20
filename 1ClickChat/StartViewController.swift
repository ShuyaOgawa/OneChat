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
            self.appDelegate.my_id = all_member_array?.count as AnyObject
            ref.child("user/all_member/\(self.appDelegate.my_id!)").setValue(self.appDelegate.my_id!)
            ref.child("user/waiting_member/\(self.appDelegate.my_id!)").setValue(self.appDelegate.my_id!)
        }) { (error) in
            print(error.localizedDescription)
        }
        
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
