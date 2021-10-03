//
//  ToDoDetailTableViewController.swift
//  ToDoList
//
//  Created by Mohsin Braer on 9/25/21.
//

import UIKit

private let dateFormatter: DateFormatter = {
    print("Date Formatter created");
    let dateFormatter = DateFormatter();
    dateFormatter.dateStyle = .short;
    dateFormatter.timeStyle = .short;
    return dateFormatter;
}()

class ToDoDetailTableViewController: UITableViewController {

    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noteView: UITextView!
    
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    
    var toDoItem: ToDoItem!;
    let datePickerIndexPath = IndexPath(row: 1, section: 1);
    let notesTextIndexPath = IndexPath(row: 0, section: 2);
    let notesRowHeight: CGFloat = 200;
    let defaultRowHeight: CGFloat = 44;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false;
        self.view.addGestureRecognizer(tap);
        
        nameField.delegate = self;
        
        if toDoItem == nil
        {
            //toDoItem = ToDoItem(name: "", date: Date(), notes: "");
            toDoItem = ToDoItem(name: "", date: Date().addingTimeInterval(24*60*60), notes: "", reminderSet: false, isCompleted: false);
            nameField.becomeFirstResponder();
        }
        
        updateUserInterface();

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.         // self.navigationItem.rightBarButtonItem = self.editButtonItem

        
    }
    
   
    func updateUserInterface()
    {
        nameField.text = toDoItem.name;
        datePicker.date = toDoItem.date;
        noteView.text = toDoItem.notes;
        reminderSwitch.isOn = toDoItem.reminderSet;
        dateLabel.textColor = (reminderSwitch.isOn ? .black : .gray);
        dateLabel.text = dateFormatter.string(from: toDoItem.date);
        enableDisableSaveButton(text: nameField.text!)
    }
    
    func updateReminderSwitch(){
        LocalNotificationManger.isAuthorized { (authorized) in
            DispatchQueue.main.async {
                if !authorized && self.reminderSwitch.isOn{
                    self.oneButtonAlert(title: "User Has Not Allowed Notifications", message: "To receive alerts for reminders, go to settings");
                    self.reminderSwitch.isOn = false;
                }
                
                self.view.endEditing(true)
                self.dateLabel.textColor = (self.reminderSwitch.isOn ? .black : .gray);
                self.tableView.beginUpdates();
                self.tableView.endUpdates();
            }
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        toDoItem = ToDoItem(name: nameField.text!, date: datePicker.date, notes: noteView.text, reminderSet: reminderSwitch.isOn, isCompleted: toDoItem.isCompleted);
    }
    
    func enableDisableSaveButton(text: String){
        if text.count > 0
        {
            saveBarButton.isEnabled = true;
        } else{
            saveBarButton.isEnabled = false;
        }
        
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        
        let isPresentingInAddMode = presentingViewController is UINavigationController;
        if isPresentingInAddMode{
            dismiss(animated: true, completion: nil)
        }else {
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    @IBAction func reminderSwitchChanged(_ sender: UISwitch) {
        updateReminderSwitch()

        
    }
    
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        self.view.endEditing(true)
        dateLabel.text = dateFormatter.string(from: sender.date);
        
    }
    

    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        
        enableDisableSaveButton(text: sender.text!);
        
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ToDoDetailTableViewController{
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath{
            case datePickerIndexPath:
                return reminderSwitch.isOn ? datePicker.frame.height : 0;
            case notesTextIndexPath:
                return notesRowHeight;
        default:
            return defaultRowHeight;
        
        }
    }
}

extension ToDoDetailTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        noteView.becomeFirstResponder();
        return true;
    }
    
}
