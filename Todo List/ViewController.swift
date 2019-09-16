//
//  ViewController.swift
//  Todo List
//
//  Created by Lukas on 2019-09-11.
//  Copyright © 2019 Lukas. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTaskTextField: UITextField!
    @IBOutlet weak var completedFilterButton: UIButton!
    @IBOutlet weak var todoFilterButton: UIButton!
    
    var tasks = [Task]()
    var displayedTasks = [Task]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load Tasks
        loadTasks()

        displayedTasks = tasks
        
        // Set Delegates
        tableView.delegate = self
        tableView.dataSource = self
        addTaskTextField.delegate = self
    }
    
    //TODO: Animations
    
    //MARK: Private Methods
    
//    private func createMockTasks() {
//        let task1 = Task(name: "Example task", isCompleted: false)
//        let task2 = Task(name: "Add more mock data", isCompleted: false)
//        tasks.append(task1)
//        tasks.append(task2)
//    }
    
    // Create strikethrough String Attribute
    private func strikeThroughString(_ inputStr: String, strikeThrough: Bool) -> NSMutableAttributedString {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: inputStr)
        if strikeThrough {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        } else {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, 0))
        }
        return attributeString
    }
    
    // Set table cell based on task properties
    private func setTableViewCell(task: Task, cell: TaskTableViewCell) {
        // Set cell text
        cell.taskLabel.text = task.name
        
        // Load Images
        let bundle = Bundle(for: type(of: self))
        let circle = UIImage(named: "circle", in: bundle, compatibleWith: self.traitCollection)
        let check = UIImage(named: "check", in: bundle, compatibleWith: self.traitCollection)
        
        if task.isCompleted {
            cell.taskLabel.attributedText = strikeThroughString(task.name, strikeThrough: true)
            cell.taskButton.setImage(check, for: .normal)
        } else {
            cell.taskLabel.attributedText = strikeThroughString(task.name, strikeThrough: false)
            cell.taskButton.setImage(circle, for: .normal)
        }
    }
    
    //Filter tableView based on filter buttons
    private func filterTableView() {
        let filterCompleted = !completedFilterButton.isSelected
        let filterTodo = !todoFilterButton.isSelected
        
        if filterTodo && filterCompleted {
            displayedTasks = [Task]()
        } else if filterCompleted && !filterTodo {
            displayedTasks  = tasks.filter { $0.isCompleted == false }
        } else if !filterCompleted && filterTodo {
            displayedTasks = tasks.filter { $0.isCompleted == true }
        } else {
            displayedTasks = tasks
        }
        tableView.reloadData()
    }
    
    // Save data to device
    private func saveTasks() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tasks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "tasks")
        }
    }
    
    // Load saved tasks from device
    private func loadTasks() {
        let defaults = UserDefaults.standard
        if let savedTasks = defaults.object(forKey: "tasks") as? Data {
            if let decodedTasks = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedTasks) as? [Task] {
                tasks = decodedTasks
            }
        }
    }
    
    // Update view after any change
    private func updateView() {
        saveTasks()
        filterTableView()
    }
    
    
    //MARK: TableView Protocol Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedTasks.count
    }
    
    // Create Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TaskTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TaskTableViewCell  else {
            fatalError("The dequeued cell is not an instance of TaskTableViewCell.")
        }
        
        // Get the task for this cell
        let task = displayedTasks[indexPath.row]

        setTableViewCell(task: task, cell: cell)
        
        return cell
    }
    
    // On tap row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Unselect row
        tableView.deselectRow(at: indexPath, animated: false)

        // Get cell tapped on
        let cell = tableView.cellForRow(at: indexPath) as! TaskTableViewCell
        
        //Get task tapped on
        let selectedTask = displayedTasks[indexPath.row]
        selectedTask.isCompleted = !selectedTask.isCompleted
        
        setTableViewCell(task: selectedTask, cell: cell)
        
        updateView()
        os_log("Task was tapped", log: OSLog.default, type: .debug)
    }
    
    // On delete row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //tasks.remove(at: indexPath.row)
            let removedTask = displayedTasks[indexPath.row]
            tasks.removeAll { (task) -> Bool in
                return removedTask == task
            }
            displayedTasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    //MARK: TextField Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Create new task
        let newTask = Task(name: textField.text!, isCompleted: false)
        
        // Insert new row into table view
        let newIndexPath = IndexPath(row: displayedTasks.count, section: 0)
        displayedTasks.append(newTask)
        tasks.append(newTask)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        
        // Reset text field
        textField.text = ""
        
        updateView()
        os_log("Task was added", log: OSLog.default, type: .debug)
    }
    
    //MARK: Filter button actions
    
    @IBAction func onCompletedTap(_ sender: Any) {
        // Toggle Filter
        completedFilterButton.isSelected = !completedFilterButton.isSelected
        updateView()
    }
    
    @IBAction func onTodoTap(_ sender: Any) {
        // Toggle Filter
        todoFilterButton.isSelected = !todoFilterButton.isSelected
        updateView()
    }
    
}

