//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Min Kaung Htet on 20/01/2022.
//

import UIKit

class MemeCollectionViewController: UIViewController {
    
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

extension MemeCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
}
