//
//  TableViewController.swift
//  MemeMe
//
//  Created by Alexandra Hufnagel on 19.03.21.
//

import UIKit

// MARK: - ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Model
    
    let favoriteThings = [
        "Raindrops on roses",
        "Whiskers on kittens",
        "Bright copper kettles",
        "Warm woolen mittens"
    ]

    // MARK: Table View Data Source Methods
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return self.favoriteThings.count
    }

    // cell for row at index path
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        let favoriteThingForRow = self.favoriteThings[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = favoriteThingForRow
        
        return cell

    }
}

