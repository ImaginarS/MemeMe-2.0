//
//  SentMemeTableViewCell.swift
//  MemeMe
//
//  Created by Sandra Q on 3/28/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class SentMemeTableViewCell: UITableViewCell {

   @IBOutlet weak var memeImage: UIImageView!
    
    var meme: Meme!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
//elf.imageView!.image = meme.memedImage
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        memeImage.image = meme.memedImage
    }

}
