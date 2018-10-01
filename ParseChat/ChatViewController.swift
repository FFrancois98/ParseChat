//
//  ChatViewController.swift
//  ParseChat
//
//  Created by user144860 on 9/30/18.
//  Copyright © 2018 Fleurevca Francois. All rights reserved.
//

import UIKit
import Parse
class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    

    @IBOutlet weak var chatMessageField: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    
    var messages: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
        // Auto size row height based on cell autolayout constraints
        chatTableView.rowHeight = UITableView.automaticDimension
        // Provide an estimated row height. Used for calculating scroll indicator
        chatTableView.estimatedRowHeight = 50
        
        //chatTableView.separatorStyle = .none
        
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ChatViewController.onTimer), userInfo: nil, repeats: true)
        
        
    }
    
    @objc func onTimer() {
        let query = PFQuery(className:"Message")
        query.whereKeyExists("text").includeKey("user")
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                // The find succeeded.
                self.messages = objects
                self.chatTableView.reloadData()
                
            } else {
                // Log details of the failure
                print("<><><><>Error: \(error?.localizedDescription)")
            }
        }
    }
    
    @IBAction func onSend(_ sender: Any) {
        let message = PFObject(className: "Message")
        print ("sending message")
        print (chatMessageField.text ?? "Nothing")
        if chatMessageField.text != "" {
            message["text"] = chatMessageField.text
            message["user"] = PFUser.current()
            message.saveInBackground(block: {(success: Bool?, error: Error?) in
                if success == true {
                    print ("message sent")
                }
                else {
                    print ("message not sent")
                }
            })
        }
        chatMessageField.text = ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let message = self.messages {
            return message.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        cell.messages = (self.messages?[indexPath.row])!
        if let user = cell.messages["user"] as? PFUser {
            // User found! update username label with username
            cell.userLabel.text = user.username
        } else {
            // No user found, set default username
            cell.userLabel.text = "🤖"
        }
        
        return cell
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
