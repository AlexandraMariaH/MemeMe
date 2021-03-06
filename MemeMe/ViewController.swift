//
//  ViewController.swift
//  MemeMe
//
//  Created by Alexandra Hufnagel on 28.02.21.
//

import UIKit


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
        
      //  self.textFieldTop.delegate = self.topDelegate
      //    self.textFieldBottom.delegate = self.bottomDelegate
        self.textFieldTop.defaultTextAttributes = memeTextAttributes
        self.textFieldBottom.defaultTextAttributes = memeTextAttributes
        textFieldTop.textAlignment = .center
        textFieldBottom.textAlignment = .center
    }
    
    override func viewWillAppear(_ animated: Bool) {
           cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
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

