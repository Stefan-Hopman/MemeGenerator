//
//  ViewController.swift
//  memes
//  this
//  Created by Stefan Hopman on 6/25/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    //MARK: Outlets
    @IBOutlet weak var shareButton: UIButton!         //share button
    @IBOutlet weak var topTextField: UITextField!     //top text field
    @IBOutlet weak var bottomTextField: UITextField!  //bottom text field
    @IBOutlet weak var imageView: UIImageView!        //where you upload your images
    @IBOutlet weak var toolBar: UIToolbar!            //the tool bar on the bottom
    @IBOutlet weak var albumButton: UIBarButtonItem!  //album button to access your pictures
    @IBOutlet weak var cameraButton: UIBarButtonItem! //access to your camera
    
   
    //Assign Delegates
    
    let text = MemeTextDelegate()
    
    // Create required instance
    let textStyles = MemeTextDelegate()
     //creating a variable of the meme text delegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.topTextField.delegate = text
        self.bottomTextField.delegate = text
        textStyles.applyStyleToText(for: topTextField, Defaulttext: "top")
        textStyles.applyStyleToText(for: bottomTextField, Defaulttext: "bottom")
        shareButton.isEnabled = false // disables the share button until an image is added
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        //subscibes to keyboard will show and will hide
        subscribeToKeyboardNotifications()
        //Disables the camera if user has a devie without a camera
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //unsubscibes to keyboard will show and will hide
        unsubscribeToKeyboardNotifications()
    }
        
    //----------------------------------------------------------------------------------------------------------//
    //MARK: Keyboard Adjustements
    func subscribeToKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications(){
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardWillHideNotification,object: nil)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder{
        view.frame.origin.y -= getKeyboardHeight(notification) //Will move the frame equal to the keyboard
        }
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0 //Will move the frame equal to the keyboard
    }
    
    //----------------------------------------------------------------------------------------------------------//
    
    func presentPickerViewController(source: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()            //instiates an image picker controller object
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true                       //allows the image to be edited
        imagePickerController.sourceType = source
        present(imagePickerController, animated: true, completion: nil)  //presents the view
        shareButton.isEnabled = true //allows the share button to be clicked on
    }
    
    //MARK: Camera Selector
    @IBAction func cameraImageSelector(_ sender: Any) {
        presentPickerViewController(source: .camera)
        
    }
    //MARK: Album Selector
    @IBAction func albumImageSelector(_ sender: Any) {
        presentPickerViewController(source: .photoLibrary)
    }
    
    // MARK: Processing The Meme Images
    func imagePickerController(_ picker : UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            //print ("edited")
            imageView.image = editedImage
        }
        else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            //print ("original")
            imageView.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Geneate The Meme Image
    func generateMemedImage() -> UIImage {
        // Render view to an image
        toolBar.isHidden = true                                                 //hides parts of the app which you do not want a picture to be taken
        shareButton.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)                     //creates the bits
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)     //draws the hierachy
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        toolBar.isHidden = false
        shareButton.isHidden = false
        return memedImage
    }
    
    //Saves the meme image
    func save(memedImage: UIImage) {
        // saves the meme in the app delegate
        if topTextField.text != nil && bottomTextField.text != nil && imageView.image != nil {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage)
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme) //memes array called in the app delegate
        }
    }
    
    //MARK: Share Button Functionality
    @IBAction func shareButton(_ sender: Any) {
        let memeImage = generateMemedImage()
        let share = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        present(share, animated: true, completion: nil)
        share.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, complete: Bool, returnedItems: [Any]?, error: Error?) in
            if !complete{
                return
            }
            else{
                self.save(memedImage: memeImage);
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
}

