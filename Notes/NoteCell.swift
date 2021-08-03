//
//  NoteCell.swift
//  Notes
//
//  Created by Apex on 29.07.2021.
//

import UIKit

protocol NoteCellActionsDelegate: class {
    func favouriteButtonTapped(delegateFrom cell: NoteCell)
    func moveToTrashButtonTapped(delegateFrom cell: NoteCell)
    func restoreButtonTapped(delegateFrom cell: NoteCell)
    func noteButtonTapped(delegateFrom cell: NoteCell)
}

class NoteCell: UITableViewCell {
    
    let buttonCornerRadius: CGFloat = 10
    let cellCornerRadius: CGFloat = 15
    let hidingTime: TimeInterval = 0.2
    let appearingTime: TimeInterval = 0.1
    let alphaForSelectedState: CGFloat = 0.1

    @IBOutlet weak var noteButton: UIButton!
    @IBOutlet weak var noteName: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var roundRectCellBackground: UIView!
    
    weak var delegateActions: NoteCellActionsDelegate?
    
    var note: Note?
    
    @IBAction func noteButtonTapped(_ sender: Any) {
        delegateActions?.noteButtonTapped(delegateFrom: self)
    }
    
    @IBAction func favouriteButtonTapped(_ sender: UIButton) {
        delegateActions?.favouriteButtonTapped(delegateFrom: self)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.setSelected(false, animated: true)
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func trashButtonTapped(_ sender: UIButton) {
        delegateActions?.moveToTrashButtonTapped(delegateFrom: self)
    }
    
    @IBAction func restoreButtonTapped(_ sender: UIButton) {
        delegateActions?.restoreButtonTapped(delegateFrom: self)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        noteButton.layer.cornerRadius = buttonCornerRadius
        cancelButton.layer.cornerRadius = buttonCornerRadius
        editButton.layer.cornerRadius = buttonCornerRadius
        trashButton.layer.cornerRadius = buttonCornerRadius
        restoreButton.layer.cornerRadius = buttonCornerRadius
        
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1).cgColor
        
        setIsHiddenForSupportedButtons(isHidden: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.selectedBackgroundView?.backgroundColor = .white
            UIView.transition(with: noteButton, duration: hidingTime, options: .transitionCrossDissolve, animations: {
                self.noteButton.alpha = self.alphaForSelectedState
            }, completion: { (finished) in self.noteButton.isEnabled = false })
            UIView.transition(with: noteName, duration: hidingTime, options: .transitionCrossDissolve, animations: {
                self.noteName.alpha = self.alphaForSelectedState
            })
            UIView.transition(with: favouriteButton, duration: hidingTime, options: .transitionCrossDissolve, animations: {
                self.favouriteButton.isHidden = true
            }) { (finished) in
                UIView.transition(with: self.cancelButton, duration: self.hidingTime, options: .transitionCrossDissolve, animations: {
                    self.cancelButton.isHidden = false
                })
                if showNotes == .trash {
                    UIView.transition(with: self.restoreButton, duration: self.hidingTime, options: .transitionCrossDissolve, animations: {
                        self.restoreButton.isHidden = false
                    })
                } else {
                    UIView.transition(with: self.editButton, duration: self.hidingTime, options: .transitionCrossDissolve, animations: {
                        self.editButton.isHidden = false
                    })
                }
                UIView.transition(with: self.trashButton, duration: self.hidingTime, options: .transitionCrossDissolve, animations: {
                    self.trashButton.isHidden = false
                })
            }
        } else {
            UIView.transition(with: cancelButton, duration: appearingTime, options: .transitionCrossDissolve, animations: {
                self.cancelButton.isHidden = true
            })
            UIView.transition(with: self.restoreButton, duration: appearingTime, options: .transitionCrossDissolve, animations: {
                self.restoreButton.isHidden = true
            })
            UIView.transition(with: editButton, duration: appearingTime, options: .transitionCrossDissolve, animations: {
                self.editButton.isHidden = true
            })
            UIView.transition(with: trashButton, duration: appearingTime, options: .transitionCrossDissolve, animations: {
                self.trashButton.isHidden = true
            }) { (finished) in
                UIView.transition(with: self.noteButton, duration: self.appearingTime, options: .transitionCrossDissolve, animations: {
                    self.noteButton.alpha = 1.0
                }) { (finished) in
                    self.noteButton.isEnabled = true
                }
                UIView.transition(with: self.noteName, duration: self.appearingTime, options: .transitionCrossDissolve, animations: {
                    self.noteName.alpha = 1.0
                })
                UIView.transition(with: self.favouriteButton, duration: self.appearingTime, options: .transitionCrossDissolve, animations: {
                    self.favouriteButton.isHidden = false
                })
            }
        }
    }
    
    private func setIsHiddenForSupportedButtons(isHidden: Bool) {
        cancelButton.isHidden = isHidden
        editButton.isHidden = isHidden
        trashButton.isHidden = isHidden
        restoreButton.isHidden = isHidden
    }
    
    func hideView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
    }
}
