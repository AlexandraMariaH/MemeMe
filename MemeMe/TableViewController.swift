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
   // var memes = [Meme]()
    
    
    @IBOutlet weak var gotoEditMeme: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!

        
  /*  override func viewDidLoad() {
        memes = appDelegate.memes

        super.viewDidLoad()
        print(-1, appDelegate.memes.count)
        tableView.reloadData()

    }*/
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Collection View Will Appear")
        print(0, appDelegate.memes.count)
        tableView.reloadData()
        tabBarController?.tabBar.isHidden = false
        navigationController?.isNavigationBarHidden = false
        self.navigationItem.hidesBackButton = true
    }

    // MARK: Table View Data Source Methods
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("1", appDelegate.memes.count)

        return self.appDelegate.memes.count

    }

    // cell for row at index path
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("1")

        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
     
        let memeForRow = appDelegate.memes[(indexPath as NSIndexPath).row]
        
        print("2")

        cell.textLabel?.text = memeForRow.topText + memeForRow.bottomText
        cell.imageView?.image = memeForRow.memedImage

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        detailController.meme = self.appDelegate.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
}

