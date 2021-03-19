//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by Alexandra Hufnagel on 14.03.21.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
