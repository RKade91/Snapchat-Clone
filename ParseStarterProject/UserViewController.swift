//
//  UserViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Rohit Kumar on 2015-08-13.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class UserViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    
    
    @IBOutlet var messageView: UIImageView!
    
    
    var userArray: [String] = []
    
    var activeRecipient = 0
    
    var timer = NSTimer()
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        //upload to parse code
        var imageToSend = PFObject(className:"image")
        imageToSend["photo"] = PFFile(name: "image.jpg", data: UIImageJPEGRepresentation(image, 0.5)) // this have a bigger limit as aspposed to a 128kb lmit
        //imageToSend["image"] = UIImageJPEGRepresentation(image, 1) // this conrtols the quality of teh image from 0 - 1; 1 being highest qualitryy
        imageToSend["senderUsername"] = PFUser.currentUser()!.username
        imageToSend["recipientUsername"] = userArray[activeRecipient]
        imageToSend.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                
                print("image saved")
                
            } else {
                // There was a problem, check error.description
                
                print(error)
            }
        }
        
        
        
    }
    
    @IBAction func pickImage(sender: AnyObject) {
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        var query = PFUser.query()
        query?.whereKey("username", notEqualTo: PFUser.currentUser()!.username!)
        var users = query!.findObjects()
        
        
        for user in users as! [PFUser]{
            
            println(user.username!)
            userArray.append(user.username!)
            
            tableView.reloadData()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: ("checkForMessage"), userInfo: nil, repeats: true)
        
        if PFUser.currentUser() != nil {
            
            
            
            
            
            
        }
        

        
    }
    
    func checkForMessage(){
    
        if PFUser.currentUser() != nil {
            
            //////
            
            print("checking for message...")
            
            var done = false
            
            var query = PFQuery(className: "image")
            query.whereKey("recipientUsername", equalTo: PFUser.currentUser()!.username!)
            query.findObjectsInBackgroundWithBlock({ (images, error) -> Void in
                
             
                if error != nil {
                    
                    print(error)
                    print("***NO OBJECT FOUND***")
                    
                } else if let images = images as? [PFObject]{
                    
                    
                    for image in images {
                    
                    
                        //let imageFile = image["photo"] as! PFFile
                        
                        if done == false {
                            
                            
                            let imageFile = image["photo"] as! PFFile
                            
                            var senderUsername = ""
                            
                            if image["senderUsername"] != nil {
                            
                                senderUsername = image["senderUsername"] as! String
                            
                            } else {
                            
                                senderUsername = "Unkown user"
                            
                            }
                           
                            
                            imageFile.getDataInBackgroundWithBlock{
                            (imageData: NSData?, error: NSError?) -> Void in
                                
                                
                                if error != nil {
                                    
                                    print(error)
                                } else {
                                    
                                    
                                    
                                    var alert = UIAlertController(title: "you have a message", message: "Message from \(senderUsername)", preferredStyle: UIAlertControllerStyle.Alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
                                    (action) -> Void in
                                    
                                    
                                    
                                    
                                    if let data = imageData {
                                       ///
                                        
                                        var backgroundView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
                                        backgroundView.backgroundColor = UIColor.blackColor()
                                        backgroundView.alpha = 0.8
                                        backgroundView.tag = 3
                                        self.view.addSubview(backgroundView)
                                        
                                                
                                        var displayedImage = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
                                        displayedImage.image = UIImage(data: data)
                                        displayedImage.tag = 3
                                        displayedImage.contentMode = UIViewContentMode.ScaleAspectFit
                                        self.view.addSubview(displayedImage)
                                        
                                        
                                        
                                        self.timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: ("hideMessage"), userInfo: nil, repeats: false)
   
                                        
                                        //self.messageView.image = UIImage(data: data)
                                        
                                        ///
                                    }
                                        
                                }))
                                    
                                    
                                    self.presentViewController(alert, animated: true, completion: nil)
                                }
                                    
                            
                            
                            }//
                            
                            
                            
                          //self.messageView.image = imageFile
                            done = true
                            
                        }
                    
                    
                    }
                    
                    
                    
                
                }
                
                
            })

            
            //////
        }else{
            
            timer.invalidate()
        }
        
        
        
        
        
        /* if PFUser.currentUser() != nil {
        
        
            print("checking for message...")
        
            var query = PFQuery(className: "image")
            query.whereKey("recipientUsername", equalTo: PFUser.currentUser()!.username!)
            var images = query.findObjects()
        
        
            var done = false
        
        
            for image in images as! [PFFile]{
            
                if done == false {
                
                
                    var imageView: PFImageView = PFImageView()
                    imageView.file = image["photo"] as! PFFile
                    imageView.loadInBackground({ (photo, error) -> Void in
                    
                        if error == nil{
                    
                            print(error)
                    
                        } else {
                
                            var displayedImage = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
                            displayedImage.image = photo
                            self.view.addSubview(displayedImage)
                        
                        }
                    
                    })
            
                    done = true
                
                }
            
            
            }
    
    
        }else{
        
            timer.invalidate()
        
        }*/
    }
    
    
    func hideMessage(){
    
        
        for subview in self.view.subviews{
        
            if subview.tag == 3{
            
                subview.removeFromSuperview()
            }
        
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return userArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell

        cell.textLabel?.text = userArray[indexPath.row]

        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        activeRecipient = indexPath.row
        
        pickImage(self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "logout"{
        
           print("logging out")
            PFUser.logOut()
        
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
