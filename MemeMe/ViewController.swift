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
   
    @IBOutlet var textFieldTop: UITextField!
    @IBOutlet var textFieldBottom: UITextField!
    
    
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
    
    // Mark: keyboard
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
         // FOR WHAT?
          //  navigationItem.leftBarButtonItem?.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}

