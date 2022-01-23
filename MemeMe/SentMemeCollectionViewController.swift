//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Min Kaung Htet on 20/01/2022.
//

import UIKit

class SentMemeCollectionViewController: UIViewController {
    
    var memes: [MemeObject]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    @IBOutlet weak var memeCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        memeCollectionView.register(UINib(nibName: "MemeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MemeCollectionViewCell")
        memeCollectionView.dataSource = self
        memeCollectionView.delegate = self
        

    }
  
    

    @IBAction func btnAdd(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension SentMemeCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = memeCollectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        cell.image = memes[indexPath.row].memedImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (view.frame.size.width - (2 * 3.0)) / 3.0 , height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        let meme = memes[indexPath.row]
        controller.meme = meme
        
        //set the title of the back button
        let leftBackButton = UIBarButtonItem()
        leftBackButton.title = "Collection View"
        navigationItem.backBarButtonItem = leftBackButton
        navigationController?.pushViewController(controller, animated: true)
        
    }
}
