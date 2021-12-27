//
//  ViewController.swift
//  MemeMe
//
//  Created by Min Kaung Htet on 07/12/2021.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var buttonToolBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topNavBar: UIToolbar!
    var memedImage: UIImage!
    @IBOutlet weak var topTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -3.00
        ]
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.text = "Top"
        topTextField.textAlignment = .center
        topTextField.borderStyle = .none
        topTextField.textColor = UIColor.white
        topTextField.delegate = self
      
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.text = "Bottom"
        bottomTextField.textAlignment = .center
        bottomTextField.textColor = UIColor.white
        bottomTextField.delegate = self
        bottomTextField.borderStyle = .none
       
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func pickAnImage(_ sender: Any) {
        pickAnImageFromCameraOrLibray(source: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {

        pickAnImageFromCameraOrLibray(source: .camera)
    }
    
    func pickAnImageFromCameraOrLibray(source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
                pickerController.delegate = self
                pickerController.allowsEditing = true
                pickerController.sourceType = source
                present(pickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func shareItems(sender: AnyObject) {

           let memeToShare = generateMemedImage()

           let activityViewController = UIActivityViewController(activityItems: [memeToShare], applicationActivities: nil)
           activityViewController.completionWithItemsHandler = { activity, success, items, error in
               if success {
                   self.save(memedImage: memeToShare)
               }
           }
        present(activityViewController, animated: true, completion: nil)
       }
    
    
    
}

extension ViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.contentMode = .scaleAspectFill
            imagePickerView.image = pickedImage
         }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == topTextField {
            textField.text  = ""
        }else {
            textField.text = "" //Butoom Text Field
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
       
    }
}

//keyboard adjust
extension ViewController {
    
    func subscribeToKeyboardNotifications() {

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
   @objc func keyboardWillShow(_ notification: NSNotification) {

        if bottomTextField.isFirstResponder && view.frame.origin.y == 0 {
            view.frame.origin.y -= getKeyboardHeight(notification as Notification)
        }
    }

    
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder {
               view.frame.origin.y = 0
           }
    }
    
   

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
    
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
}

//save meme
extension ViewController {
    
    
    struct Meme {
        var TopTextField: String!
        var BottomTextField: String!
        var originalImage: UIImage!
        var memedImage: UIImage!
    }
    
    func generateMemedImage() -> UIImage {
          
        toolBarVisible(visible: false)
          
          UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
          memedImage = UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext()
          
        toolBarVisible(visible: true)
          
          return memedImage
      }
    func save(memedImage: UIImage) {
        // Create the meme
        let meme = Meme(TopTextField: topTextField.text!, BottomTextField: bottomTextField.text!, originalImage: self.imagePickerView.image!, memedImage: memedImage)
    }
      
      // MARK: toolbar functions
      func toolBarVisible(visible: Bool){
          if !visible {
              topNavBar.isHidden = true    // removed self
              buttonToolBar.isHidden = true // typo on var for toolbar // removed self
          } else {
              topNavBar.isHidden = false   // removed self
              buttonToolBar.isHidden = false  // removed self
          }
      }
      
}

