//
//  ListTableViewCell.swift
//  ToDoList
//
//  Created by Mohsin Braer on 10/3/21.
//

import UIKit

protocol ListTableViewCellDelegate: class{
    
    func checkBoxToggle(sender: ListTableViewCell)
    
}

class ListTableViewCell: UITableViewCell {
    
   
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    weak var delegate: ListTableViewCellDelegate?
    
    var toDoItem: ToDoItem! {
        didSet{
            nameLabel.text = toDoItem.name;
            checkBoxButton.isSelected = toDoItem.isCompleted;
        }
    }

    
    
    @IBAction func checkToggled(_ sender: UIButton) {
        delegate?.checkBoxToggle(sender: self)
        
    }
    
    
    
}
