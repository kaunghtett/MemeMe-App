//
//  ViewController.swift
//  MemeMe
//
//  Created by Min Kaung Htet on 07/12/2021.
//

import UIKit

class MemeEditorViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var buttonToolBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topNavBar: UIToolbar!
    var memedImage: UIImage!
    @IBOutlet weak var topTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setTextAttribute(topTextField, str: " TOP ")
        
        setTextAttribute(bottomTextField, str : " BOTTOM ")
        
        imagePickerView.image = nil

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
    
    // Texts Attributes
      
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
       .strokeColor: UIColor.black,
       .foregroundColor: UIColor.white,
       .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
       .strokeWidth: -3.00
    ]
    // Default Text Settings
       
       func setTextAttribute(_ textField : UITextField, str : String) {
           textField.delegate = self
           textField.text = str
           textField.defaultTextAttributes = memeTextAttributes
           textField.textAlignment = .center
           textField.backgroundColor = .clear
           textField.borderStyle = .none
           textField.autocapitalizationType = .allCharacters
           
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
                   let vc = self.storyboard?.instantiateViewController(withIdentifier: "SentMemesViewController") as! SentMemesViewController
                   self.present(vc, animated: true, completion: nil)
               }
           }
        present(activityViewController, animated: true, completion: nil)
       }
    
    
    
}

extension MemeEditorViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
//        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            imagePickerView.contentMode = .scaleAspectFit
//            //imagePickerView.image = pickedImage
//         }
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imagePickerView.image = image
            shareButton.isEnabled = true
        }
        else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = image
            shareButton.isEnabled = true
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension MemeEditorViewController: UITextFieldDelegate {
    
    // Text Editing
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == topTextField && topTextField.text == " TOP ") {
            topTextField.text = ""
        } else if (textField == bottomTextField && bottomTextField.text == " BOTTOM ") {
            bottomTextField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
       
    }
}

//keyboard adjust
extension MemeEditorViewController {
    
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
extension MemeEditorViewController {
    
    
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
        guard let topText = topTextField.text, let bottomText = bottomTextField.text, let originalImage = self.imagePickerView.image else {
            return
        }
        
        
        let meme = MemeObject(topText: topText, bottomText: bottomText, originalImage: originalImage, memedImage: memedImage)
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
      
      // MARK: toolbar functions
   
    func toolBarVisible(visible: Bool){
        topNavBar.isHidden = !visible
        buttonToolBar.isHidden = !visible
    }
      
}

