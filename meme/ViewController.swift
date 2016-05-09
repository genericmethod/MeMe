//
//  ViewController.swift
//  meme
//
//  Created by Chris Farrugia on 06/05/2016.
//  Copyright © 2016 Chris Farrugia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var topToolbar: UIToolbar!
    
    let memeTextFieldDelegate = MemeTextFieldDelegate()
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        shareButton.enabled = imagePickerView.image != nil
        
        super.viewWillAppear(animated)
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSBackgroundColorAttributeName :UIColor.clearColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0
        ]
        
        topText.delegate = memeTextFieldDelegate
        bottomText.delegate = memeTextFieldDelegate
        
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        
        topText.textAlignment = .Center
        bottomText.textAlignment = .Center
        
    }
    
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(pickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func shareImage(sender: AnyObject){
        
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities:nil);
        self.presentViewController(activityController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                imagePickerView.image = image
            }
            
            dismissViewControllerAnimated(true, completion: nil)
            
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        
        self.topToolbar.hidden = true
        self.bottomToolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.topToolbar.hidden = false
        self.bottomToolbar.hidden = false
        
        return memedImage
    }
    
    func save() {
        //Create the meme
        
        let memedImage = generateMemedImage()
        
        let meme = Meme( topText: topText.text!,
            bottomText:bottomText.text!,
            image:imagePickerView.image!,
            memedImage: memedImage)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if bottomText.isFirstResponder(){
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        } else {
            view.frame.origin.y = 0
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if bottomText.isFirstResponder(){
            self.view.frame.origin.y += getKeyboardHeight(notification)
        } else {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }

}

struct Meme {
    var topText: String
    var bottomText: String
    var image: UIImage
    var memedImage: UIImage
}

