//
//  BrowseNoteViewController.swift
//  Notes
//
//  Created by Apex on 02.08.2021.
//

import UIKit

class BrowseNoteViewController: UIViewController {
    
    let buttonCornerRadius: CGFloat = 15
    
    var note: Note = Note(name: "", description: "")
    
    @IBOutlet weak var noteNameLabel: UILabel!
    @IBOutlet weak var noteDescriptionTextView: UITextView!
    @IBOutlet weak var favouriteNoteButton: UIBarButtonItem!
    @IBOutlet weak var editNoteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteNameLabel.text = note.name
        noteDescriptionTextView.text = note.description
        let image = note.isFavourite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        favouriteNoteButton.image = image
        
        editNoteButton.layer.cornerRadius = buttonCornerRadius
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
