//
//  SentMemeDetails.swift
//  MemeMe
//
//  Created by Sandra Q on 3/22/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class SentMemeDetailView: UIViewController {
    
    // MARK: Properties
    
    var meme: Meme!
    
    @IBOutlet weak var sentMemeImageDetailView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sentMemeImageDetailView.image = meme.memedImage
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}

