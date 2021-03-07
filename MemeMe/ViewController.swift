//
//  ViewController.swift
//  MemeMe
//
//  Created by Alexandra Hufnagel on 28.02.21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet var imagePickerView: UIImageView!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var albumButton: UIBarButtonItem!
        
    @IBOutlet var textFieldTop: UITextField!
    @IBOutlet var textFieldBottom: UITextField!
    
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
        
    let memeTextAttributes: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.0
    ]
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldTop.text = "TOP"
        textFieldBottom.text = "BOTTOM"
        
        textFieldTop.delegate = self
        textFieldBottom.delegate = self
      
        self.textFieldTop.defaultTextAttributes = memeTextAttributes
        self.textFieldBottom.defaultTextAttributes = memeTextAttributes
        
        textFieldTop.textAlignment = .center
        textFieldBottom.textAlignment = .center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
       }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" {
            textField.text = ""
        }
        if textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textFieldTop.text == "" {
            textFieldTop.text = "TOP"
        }
        if textFieldBottom.text == "" {
            textFieldBottom.text = "BOTTOM"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if textFieldBottom.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification)
                }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if textFieldBottom.isEditing {
                    view.frame.origin.y = 0
                }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name:  UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        presentImagePickerWith(.photoLibrary)
       }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
          presentImagePickerWith(.camera)
         }
   
    private func presentImagePickerWith(_ sourceType: UIImagePickerController.SourceType){
          
          let imagePickerController = UIImagePickerController()
          
          imagePickerController.delegate = self
          imagePickerController.sourceType = sourceType
          
          present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
            navigationItem.leftBarButtonItem?.isEnabled = true
        }
        self.dismiss(animated: true, completion: nil)
        shareButton.isEnabled = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    struct Meme {
           let topText: String
           let bottomText: String
           let originalImage: UIImage
           let memedImage: UIImage
       }
    
    func generateMemedImage() -> UIImage {

        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        
        return memedImage
    }
    
    func save() {
        _ = Meme(topText: textFieldTop.text!, bottomText: self.textFieldBottom.text!, originalImage: self.imagePickerView.image!, memedImage: generateMemedImage())
    }
    
    @IBAction func share(_ sender: Any) {
           let sharedImage = generateMemedImage()
        
           let activityController = UIActivityViewController(activityItems:    [sharedImage], applicationActivities: nil)
           self.present(activityController, animated: true, completion: nil)
           
           activityController.completionWithItemsHandler = { (activity, success, items, error) in
                if(success) {
                    self.save()
                }
           }
    }
    
    @IBAction func cancel(_ sender: Any) {
        shareButton.isEnabled = false
        imagePickerView.image = nil
        textFieldTop.text = "TOP"
        textFieldBottom.text = "BOTTOM"
    }
}
