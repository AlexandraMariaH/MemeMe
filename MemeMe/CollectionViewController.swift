//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by Alexandra Hufnagel on 14.03.21.
//

import UIKit

class CollectionViewController: UICollectionViewController {
        
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var memes = [Meme]()
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toDoWhenInView()

        collectionView.dataSource = self
        collectionView.delegate = self

        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        toDoWhenInView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        toDoWhenInView()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return memes.count
    }
    
    // MARK: Cell for item at index path
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! CollectionViewCell
        let meme = memes[(indexPath as NSIndexPath).row]

        // Set the image
        cell.memeImageView?.image = meme.memedImage

        return cell
    }
    
    
    func toDoWhenInView() {
        memes = appDelegate.memes
        collectionView.reloadData()
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: Show MemeDetails
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
}
