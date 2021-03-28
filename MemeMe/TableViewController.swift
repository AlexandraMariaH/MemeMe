//
//  TableViewController.swift
//  MemeMe
//
//  Created by Alexandra Hufnagel on 19.03.21.
//

import UIKit

// MARK: - ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate    
        
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        tabBarController?.tabBar.isHidden = false
        navigationController?.isNavigationBarHidden = false
        self.navigationItem.hidesBackButton = true
    }
    
    // MARK: Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appDelegate.memes.count
    }

    // MARK: Cell for row at index path
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
     
        let memeForRow = appDelegate.memes[(indexPath as NSIndexPath).row]
        
        // Set the textlabels for the image
        cell.textLabel?.text = memeForRow.topText + memeForRow.bottomText
        // Set the image
        cell.imageView?.image = memeForRow.memedImage

        return cell
    }
    
    // MARK: Show MemeDetails
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        detailController.meme = self.appDelegate.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    // MARK: Swipe to delete meme
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            appDelegate.memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

