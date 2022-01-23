//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Min Kaung Htet on 20/01/2022.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var memeImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var image: UIImage? {
        didSet {
            if let image = image {
                memeImage.image = image
            }
        }
    }
}
