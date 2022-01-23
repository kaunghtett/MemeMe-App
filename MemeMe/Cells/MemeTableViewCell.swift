//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Min Kaung Htet on 20/01/2022.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var labelMeme: UILabel!
  
    
    var image: UIImage? {
        didSet {
            if let image = image {
                memeImage.image = image
            }
        }
    }
    
    var title: String? {
        didSet {
            if let title = title {
                labelMeme.text = title
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
