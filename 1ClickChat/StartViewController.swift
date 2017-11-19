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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func StartButton(_ sender: UIButton) {
        let ref = Database.database().reference()
        
       
        ref.child("messages").child("-KzHdhFa1hwJaTRJFGPq").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["text"] as? String ?? ""
            print("aaaaaaaaaaaaaaa")
            print(username)
        }) { (error) in
            print(error.localizedDescription)
        }
        
        ref.child("all_member").child("id").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["id"] as? String ?? ""
            print("aaaaaaaaaaaaaaa")
            print(username)
        }) { (error) in
            print(error.localizedDescription)
        }
       
        
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
