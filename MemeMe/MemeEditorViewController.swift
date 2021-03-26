//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Alexandra Hufnagel on 28.02.21.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
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
        
        configureTextField(textFieldTop, "TOP")
        configureTextField(textFieldBottom, "BOTTOM")
    }
    
    // MARK: View appearing / disappearing
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Editing the textField
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text == "TOP") {
            textField.text = ""
        }
        if textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textFieldTop.text == "" {
            configureTextField(textFieldTop, "TOP")
        }
        if textFieldBottom.text == "" {
            configureTextField(textFieldBottom, "BOTTOM")        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Showing / Hiding the keyboard, height adjustment & keyboard notification
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
    
    // MARK: Image picking
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
        dismiss(animated: true, completion: nil)
        shareButton.isEnabled = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: generate memed images
    func generateMemedImage() -> UIImage {
        
        hide(true)
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hide(false)
        
        return memedImage
    }
    
    // MARK: create a meme object and save it to the memes array
    func save() {
        // Update the meme
        let meme = Meme(topText: textFieldTop.text!, bottomText: textFieldBottom.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        
        // Add it to the memes array on the Application Delegate
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
    
    // MARK: share the meme
    @IBAction func share(_ sender: Any) {
        let sharedImage = generateMemedImage()
        
        let activityController = UIActivityViewController(activityItems:    [sharedImage], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
        
        activityController.completionWithItemsHandler = { (_, success, _, _) in
            if(success) {
                self.save()
            }
        }
    }
    
    // MARK: cancel the meming process
    @IBAction func cancel(_ sender: Any) {
        shareButton.isEnabled = false
        imagePickerView.image = nil
        configureTextField(textFieldTop, "TOP")
        configureTextField(textFieldBottom, "BOTTOM")
    }
    
    // MARK: setting the textfields with its default texts
    func configureTextField(_ textField: UITextField, _ text: String) {
            textField.text = text
            textField.delegate = self
            textField.defaultTextAttributes = memeTextAttributes
            textField.textAlignment = .center
    }
    
    // MARK: hiding the tabBar and the navigationBar
    func hide(_ doHide: Bool) {
            tabBarController?.tabBar.isHidden = doHide
            navigationController?.navigationBar.isHidden = doHide
    }
}
