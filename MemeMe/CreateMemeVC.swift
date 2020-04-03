
//
//  ViewController.swift
//  MemeMe
//
//  Created by Sandra Q on 6/20/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class CreateMemeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
{
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        shareButton.isEnabled = false
        setupTextFieldStyle(toTextField: topTextField, text: "TOP")
        setupTextFieldStyle(toTextField: bottomTextField, text: "BOTTOM")
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
        // Disable Share button if no image is loaded
        if imagePickerView.image == nil {
            shareButton.isEnabled = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }

    //MARK: - TextFields
    func setupTextFieldStyle(toTextField textField: UITextField, text: String) {
        textField.text = text
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.autocapitalizationType = .allCharacters
        textField.textAlignment = .center
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        textField.textAlignment = .center
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    let memeTextAttributes: [NSAttributedString.Key: Any] = [ NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!, NSAttributedString.Key.strokeColor: UIColor.black, NSAttributedString.Key.strokeWidth: -4]
       
        //bold, all caps, white with a black outline, and shrink to fit. The text needs to be white with a black outline.
    
    //MARK: Picking the image
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        openImagePicker(.camera)
    }
    
    @IBAction func pickAnImage(_ sender: Any) {
        openImagePicker(.photoLibrary)
    }
    
    func openImagePicker(_ type: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Call camera or album imagePicker depending on which button initiated the call
    // Enable share button in the completion handler

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
            shareButton.isEnabled = true
        }

        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Saving and sharing the mame
    @IBAction func shareAction(_ sender: UIBarButtonItem) {
        
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView!.image!, memedImage: generateMemedImage())
        
        let image = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        controller.modalPresentationStyle = .popover
        let popover = controller.popoverPresentationController
        popover?.barButtonItem = sender
        present(controller, animated: false, completion: nil)
        controller.completionWithItemsHandler = {(activity, completed, items, error) in
            completed ? self.save(meme: meme) : print("Meme not saved.")
            
        }
        
    }

    
    //MARK: - Generating the Meme
    
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        hideToolBars(hide: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        hideToolBars(hide: false)
        return memedImage
    }
    
    func save(meme: Meme) {

        // Add the meme to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate =  object as! AppDelegate
        appDelegate.memes.append(meme)
        dismiss(animated: true, completion: nil)
        print("Meme Saved")
    }

    func hideToolBars(hide: Bool) {
        navigationBar.isHidden = hide
        toolBar.isHidden = hide
    }
    
    //MARK: - Keyboard functions
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification){
        if bottomTextField.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification: notification)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
}
