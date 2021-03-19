//
//  TableViewController.swift
//  MemeMe
//
//  Created by Alexandra Hufnagel on 19.03.21.
//

import UIKit

// MARK: - ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: Model
    
   /* let favoriteThings = [
        "Raindrops on roses",
        "Whiskers on kittens",
        "Bright copper kettles",
        "Warm woolen mittens"
    ]*/

    // MARK: Table View Data Source Methods
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
      //  return self.favoriteThings.count
        return self.memes.count
    }

    // cell for row at index path
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
     //   let favoriteThingForRow = self.favoriteThings[(indexPath as NSIndexPath).row]
     //   cell.textLabel?.text = favoriteThingForRow
        
        let memeForRow = self.memes[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = "test"
        cell.imageView?.image = memeForRow.memedImage
        
        return cell

    }
}

