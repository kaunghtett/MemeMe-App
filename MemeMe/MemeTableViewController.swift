//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Min Kaung Htet on 20/01/2022.
//

import UIKit

class MemeTableViewController: UIViewController {
    
    var memes: [MemeObject]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MemeTableViewCell", bundle: nil), forCellReuseIdentifier: "MemeTableViewCell")
        tableView.dataSource = self
    }
    

    @IBAction func btnAdd(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
     }

}

extension MemeTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell", for: indexPath) as! MemeTableViewCell
        cell.image = memes[indexPath.row].memedImage
        cell.title = "\(memes[indexPath.row].topText ?? "") .... \(memes[indexPath.row].bottomText ?? "")"
        return cell
        
        
    }
    
  
    
    
}
