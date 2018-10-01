//
//  ChatViewController.swift
//  ParseChat
//
//  Created by user144860 on 9/30/18.
//  Copyright © 2018 Fleurevca Francois. All rights reserved.
//

import UIKit
import Parse
class ChatViewController: UIViewController{
    

    @IBOutlet weak var chatMessageField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSend(_ sender: Any) {
        let chatMessage = PFObject(className: "Message")
        
        chatMessage["text"] = chatMessageField.text ?? ""
        
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
        chatMessageField.text = ""
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
