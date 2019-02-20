//
//  StatsViewController.swift
//  Editor
//
//  Created by Marco Capano on 18/02/2019.
//  Copyright © 2019 Marco Capano. All rights reserved.
//

import UIKit

class StatsViewController: UITableViewController {
    typealias Stat = (type: Shape, count: Int)
    
    ///The stats to be displayed
    var stats: [Stat]
    
    ///The action to perform when the "Delete All" button is tapped
    var deleteAllBlock: (() -> ())?
    ///The action to perform when the user demands a single type of shape to be deleteds
    var deleteShapeType: ((Shape) -> Void)?
    
    init(stats: [Stat]) {
        self.stats = stats
        super.init(style: .grouped)
        title = "Stats"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let button = UIBarButtonItem(title: "Delete all", style: .done, target: self, action: #selector(deleteAll))
        navigationItem.rightBarButtonItem = button
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stats.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            preconditionFailure("Undefined state: could not load cell in StatsViewController.")
        }
        
        let shapeInfo = stats[indexPath.row]
        cell.textLabel?.text = shapeInfo.type.description + ": \(shapeInfo.count) shape(s)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let shapeType = stats[indexPath.row].type
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {[weak self] (_, _, _) in
            self?.deleteShapeType?(shapeType)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    @objc private func deleteAll() {
        deleteAllBlock?()
    }

}
