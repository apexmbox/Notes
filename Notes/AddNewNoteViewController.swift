//
//  AddNewNoteViewController.swift
//  Notes
//
//  Created by Apex on 01.08.2021.
//

import UIKit

class AddNewNoteViewController: UIViewController, UITextViewDelegate {

    let buttonCornerRadius: CGFloat = 15
    let textFieldCornerRadius: CGFloat = 20
    let textFieldPadding: CGFloat = 15
    var initialAddButtonY: CGFloat = 0
    let textViewPlaceholder: String = "Write something here"
    
    var note: Note = Note(name: "", description: "")
    var willFavourite: Bool = false
    
    @IBOutlet weak var noteNameTextField: UITextField!
    @IBOutlet weak var noteDescriptionTextView: UITextView!
    @IBOutlet weak var addNewNoteButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var favouriteButton: UIBarButtonItem!
    @IBOutlet weak var addNoteBackgroundView: UIView!
    
    @IBAction func favouriteButtonTapped(_ sender: UIBarButtonItem) {
        willFavourite = !willFavourite
        let image = willFavourite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        favouriteButton.image = image

    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        let name = sender.text ?? ""
        addNewNoteButton.isEnabled = !name.isEmpty
        addNewNoteButton.layoutIfNeeded()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNewNoteButton.layer.cornerRadius = buttonCornerRadius
        addNewNoteButton.isEnabled = false
        noteNameTextField.layer.cornerRadius = textFieldCornerRadius
        addNoteBackgroundView.layer.cornerRadius = buttonCornerRadius
        noteNameTextField.setLeftPaddingPoints(textFieldPadding)
        noteNameTextField.setRightPaddingPoints(textFieldPadding)
        initialAddButtonY = addNoteBackgroundView.frame.origin.y
        registerForKeyboardNotifications()
        noteDescriptionTextView.delegate = self
        noteDescriptionTextView.text = textViewPlaceholder
        noteDescriptionTextView.textColor = UIColor.lightGray
    }
     
    deinit {
        removeKeyboardNotifications()
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if addNoteBackgroundView.frame.origin.y == initialAddButtonY {
                self.addNoteBackgroundView.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if addNoteBackgroundView.frame.origin.y != initialAddButtonY {
                self.addNoteBackgroundView.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "addNewNoteButtonSegue" else { return }
        
        let noteDescription = noteDescriptionTextView.text ?? ""
        
        if let noteName = noteNameTextField.text {
            self.note.name = noteName
            self.note.description = noteDescription
            self.note.isFavourite = willFavourite
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textViewPlaceholder
            textView.textColor = UIColor.lightGray
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
