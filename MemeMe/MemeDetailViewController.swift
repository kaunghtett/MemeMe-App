//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Min Kaung Htet on 24/01/2022.
//

import UIKit

class MemeDetailViewController: UIViewController {
    @IBOutlet weak var memeImage: UIImageView!
    var meme: MemeObject!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        memeImage.image = meme.memedImage
        self.tabBarController?.tabBar.isHidden = true
    
    }

}
