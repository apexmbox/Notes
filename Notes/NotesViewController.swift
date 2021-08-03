//
//  NotesViewController.swift
//  Notes
//
//  Created by Apex on 29.07.2021.
//

import UIKit

public enum ButtonActiveState {
    case active
    case inactive
}

public enum showNotesType {
    case all
    case favourites
    case trash
}

public var showNotes: showNotesType = .all

class NotesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NoteCellActionsDelegate{

    

    let buttonCornerRadius: CGFloat = 15
    let cellCornerRadius: CGFloat = 15
    let cellSpacingHeight: CGFloat = 10
    let cellReuseIdentifier: String = "noteCell"
    
    let defaultNotes: [Note] = [
        Note(name: "Note1", description: "General note"),
        Note(name: "Note2", description: "General note"),
        Note(name: "Note3", description: "Favourite note", isFavourite: true),
        Note(name: "Note4", description: "Trash note", isInTrash: true),
        Note(name: "Note5", description: "Favourite note", isFavourite: true),
        Note(name: "Note6", description: "General note"),
        Note(name: "Note note note note note note note 7", description: "General note"),
        Note(name: "Note note note note note note note note note enot 8", description: "General note")
    ]
    
    var notes: [Note] = []
    var allNotes: [Note] = []
    var favouriteNotes: [Note] = []
    var trashNotes: [Note] = []
    var currentNote: Note = Note(name: "", description: "")
    
    @IBOutlet weak var allNotesButton: UIButton!
    @IBOutlet weak var favouriteNotesButton: UIButton!
    @IBOutlet weak var trashNotesButton: UIButton!
    @IBOutlet weak var createNewNoteButton: UIButton!
    @IBOutlet weak var notesTableView: UITableView!
    @IBOutlet weak var magnifierView: UIView!
    @IBOutlet weak var notesView: UIView!
    @IBOutlet weak var emptyNotesMessageLabel: UILabel!
    
    @IBAction func helpButton(_ sender: UIButton) {
    }
    
    @IBAction func allNotesButtonTapped(_ sender: UIButton) {
        updateSortButtons(sender)
        showNotes = .all
    }
    
    @IBAction func favoutiteNotesButtonTapped(_ sender: UIButton) {
        updateSortButtons(sender)
        showNotes = .favourites
    }
    
    @IBAction func trashNotesButtonTapped(_ sender: UIButton) {
        updateSortButtons(sender)
        showNotes = .trash
    }
    
    @IBAction func createNewNoteButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        guard segue.identifier == "addNewNoteButtonSegue" else { return }
        let sourceVC = segue.source as! AddNewNoteViewController
        let note = sourceVC.note
        allNotes.append(note)
        if note.isFavourite {
            favouriteNotes.append(note)
        }
        
        switch showNotes {
        case .all:
            notes = allNotes
            notesTableView.reloadData()
        case .favourites:
            notes = favouriteNotes
            notesTableView.reloadData()
        case .trash:
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "browseNoteButtonSegue" else { return }
        let navigationVC = segue.destination as! UINavigationController
        let browseNoteVC = navigationVC.topViewController as! BrowseNoteViewController
        browseNoteVC.note = currentNote
    }
    
    // MARK: - ViewController Lyfe cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allNotesButton.layer.cornerRadius = buttonCornerRadius
        favouriteNotesButton.layer.cornerRadius = buttonCornerRadius
        trashNotesButton.layer.cornerRadius = buttonCornerRadius
        createNewNoteButton.layer.cornerRadius = buttonCornerRadius
       
        notesTableView.delegate = self
        notesTableView.dataSource = self
        notesTableView.backgroundColor = .systemGray6
        
      
        for note in defaultNotes {
            if note.isInTrash {
                trashNotes.append(note)
            } else {
                allNotes.append(note)
                if note.isFavourite {
                    favouriteNotes.append(note)
                }
            }
        }
        
        notes = allNotes
        showNotes = .all
        
        if notes.isEmpty {
            showEmptyNotesScreen()
        } else {
            hideEmptyNotesScreen()
        }
    }
  
    override func viewDidAppear(_ animated: Bool) {
        allNotesButton.switchState(to: .active)
        favouriteNotesButton.switchState(to: .inactive)
        trashNotesButton.switchState(to: .inactive)
    }
    
    
    // MARK: - Supporting functions
    
    private func updateSortButtons(_ sender: UIButton) {
        notes = []
        notesTableView.reloadData()
        switch sender {
        case allNotesButton:
            allNotesButton.switchState(to: .active)
            favouriteNotesButton.switchState(to: .inactive)
            trashNotesButton.switchState(to: .inactive)
            showNotes = .all
            notes = allNotes
        case favouriteNotesButton:
            allNotesButton.switchState(to: .inactive)
            favouriteNotesButton.switchState(to: .active)
            trashNotesButton.switchState(to: .inactive)
            showNotes = .favourites
            notes = favouriteNotes
        case trashNotesButton:
            allNotesButton.switchState(to: .inactive)
            favouriteNotesButton.switchState(to: .inactive)
            trashNotesButton.switchState(to: .active)
            showNotes = .trash
            notes = trashNotes
        default:
            return
        }
        notesTableView.reloadData()
    }
    
    private func animate(_ button: UIButton, transform: CGAffineTransform) {
        UIView.animate(withDuration: 2,
                       delay: 0,
                       usingSpringWithDamping: 5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut],
                       animations: { button.transform = transform },
                       completion: nil)
    }
    
    private func showEmptyNotesScreen() {
        switch showNotes {
        case .all:
            emptyNotesMessageLabel.text = "It looks like you haven't added anything to the notes list yet, add the first note"
        case .favourites:
            emptyNotesMessageLabel.text = "It looks like you haven't added anything to the favourite notes list yet, press All and like something"
        case .trash:
            emptyNotesMessageLabel.text = "It looks like you haven't notes in trash"
        }
        magnifierView.isHidden = false
        notesView.isHidden = true
    }
    
    private func hideEmptyNotesScreen() {
        magnifierView.isHidden = true
        notesView.isHidden = false
    }
   
    
    // MARK: - Delegate Cell methods
    
    func favouriteButtonTapped(delegateFrom cell: NoteCell) {
        //animate(cell.favouriteButton, transform: CGAffineTransform.identity.scaledBy(x: 0.6, y: 0.6))
        //animate(cell.favouriteButton, transform: .identity)
        var foundIndex: Int?
        if let note = cell.note {
            
            switch showNotes {
            case .all:
                for noteIndex in 0..<notes.count {
                    if notes[noteIndex].id == note.id {
                        foundIndex = noteIndex
                        break
                    }
                }
                if let index = foundIndex {
                    notes[index].isFavourite = !notes[index].isFavourite
                    allNotes = notes
                    if notes[index].isFavourite {
                        // add to favourites
                        favouriteNotes.append(notes[index])
                    } else {
                        // remove from favourites
                        var foundedIndexToRemove: Int?
                        for favouriteNoteIndex in 0..<favouriteNotes.count {
                            if favouriteNotes[favouriteNoteIndex].id == notes[index].id {
                                foundedIndexToRemove = favouriteNoteIndex
                                break
                            }
                        }
                        if let indexToRemove = foundedIndexToRemove {
                            favouriteNotes.remove(at: indexToRemove)
                        }
                    }
                }
                notesTableView.reloadData()
            case .favourites:
                for noteIndex in 0..<favouriteNotes.count {
                    if favouriteNotes[noteIndex].id == note.id {
                        foundIndex = noteIndex
                        break
                    }
                }
                if let index = foundIndex {
                    // update current note in all notes
                    for noteIndex in 0..<allNotes.count {
                        if allNotes[noteIndex].id == favouriteNotes[index].id {
                            allNotes[noteIndex].isFavourite = false
                        }
                    }
                    // delete from favourites
                    favouriteNotes.remove(at: index)
                    notes = favouriteNotes
                    notesTableView.deleteSections(IndexSet(integer: index), with: .fade)
                }
            case .trash:
                break
            }
        }
    }
    
    func moveToTrashButtonTapped(delegateFrom cell: NoteCell) {
        var foundIndex: Int?
        if var note = cell.note {
            switch showNotes {
            case .all:
                for noteIndex in 0..<allNotes.count {
                    if allNotes[noteIndex].id == note.id {
                        foundIndex = noteIndex
                        break
                    }
                }
                if let index = foundIndex {
                    // remove from all
                    allNotes.remove(at: index)
                    // add to trash
                    note.isFavourite = false
                    note.isInTrash = true
                    trashNotes.append(note)
                    notes = allNotes
                    notesTableView.deleteSections(IndexSet(integer: index), with: .right)
                }
                // remove from favourites
                foundIndex = nil
                for favouriteIndex in 0..<favouriteNotes.count {
                    if favouriteNotes[favouriteIndex].id == note.id {
                        foundIndex = favouriteIndex
                        break
                    }
                }
                if let index = foundIndex {
                    favouriteNotes.remove(at: index)
                }
            case .favourites:
                for noteIndex in 0..<favouriteNotes.count {
                    if favouriteNotes[noteIndex].id == note.id {
                        foundIndex = noteIndex
                        break
                    }
                }
                if let index = foundIndex {
                    // remove from favourites
                    favouriteNotes.remove(at: index)
                    // add to trash
                    note.isFavourite = false
                    note.isInTrash = true
                    trashNotes.append(note)
                    notes = favouriteNotes
                    notesTableView.deleteSections(IndexSet(integer: index), with: .right)
                }
                // remove from all
                foundIndex = nil
                for allIndex in 0..<allNotes.count {
                    if allNotes[allIndex].id == note.id {
                        foundIndex = allIndex
                        break
                    }
                }
                if let index = foundIndex {
                    allNotes.remove(at: index)
                }
            case .trash:
                for trashNoteIndex in 0..<trashNotes.count {
                    if trashNotes[trashNoteIndex].id == note.id {
                        foundIndex = trashNoteIndex
                        break
                    }
                }
                if let index = foundIndex {
                    // remove from trash permanently
                    trashNotes.remove(at: index)
                    notes = trashNotes
                    notesTableView.deleteSections(IndexSet(integer: index), with: .right)
                }
                break
            }
        }
    }
    
    func restoreButtonTapped(delegateFrom cell: NoteCell) {
        var foundIndex: Int?
        switch showNotes {
        case .all, .favourites:
            return
        case .trash:
            if var note = cell.note {
                for trashNoteIndex in 0..<trashNotes.count {
                    if trashNotes[trashNoteIndex].id == note.id {
                        foundIndex = trashNoteIndex
                        break
                    }
                }
                if let index = foundIndex {
                    trashNotes.remove(at: index)
                    notes = trashNotes
                    notesTableView.deleteSections(IndexSet(integer: index), with: .left)
                    note.isInTrash = false
                    allNotes.append(note)
                }
            }
        }
    }
    
    func noteButtonTapped(delegateFrom cell: NoteCell) {
        guard cell.note != nil else { return }
        currentNote = cell.note!
    }
    

    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if notes.isEmpty {
            showEmptyNotesScreen()
        } else {
            hideEmptyNotesScreen()
        }
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! NoteCell
        let indexNote = indexPath.section
        let note = notes[indexNote]
        cell.delegateActions = self
        cell.note = note
        let largeConfig = UIImage.SymbolConfiguration(scale: .large)
        let image = note.isFavourite ? UIImage(systemName: "heart.fill", withConfiguration: largeConfig) : UIImage(systemName: "heart")
        cell.favouriteButton.setImage(image, for: .normal)
        cell.backgroundColor = UIColor.white
        cell.roundRectCellBackground.layer.cornerRadius = cellCornerRadius
        cell.noteName?.text = note.name
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let indexPath = notesTableView.indexPathForSelectedRow {
            notesTableView.deselectRow(at: indexPath, animated: false)
        }
    }
}

//
// MARK: - Extensions
//

extension UIButton {

    func switchState(to activeState: ButtonActiveState) {
        switch activeState {
        case .active:
            self.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
            self.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        case .inactive:
            self.backgroundColor = #colorLiteral(red: 0.7557968497, green: 0.8878346086, blue: 0.970261991, alpha: 1)
            self.titleLabel?.textColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        }
    }
}
