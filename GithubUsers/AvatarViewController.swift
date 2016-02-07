//
//  AvatarViewController.swift
//  GithubUsers
//
//  Created by Denis on 07/02/2016.
//  Copyright © 2016 Denis. All rights reserved.
//

import UIKit

class AvatarViewController: UIViewController {
	@IBOutlet weak var avatarImageView: UIImageView?
	@IBOutlet weak var navigationBar: UINavigationBar?
	
	weak var image: UIImage?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.navigationBar?.topItem?.title = self.title
		
		self.avatarImageView?.image = self.image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func dismiss(sender: AnyObject) {
		self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
	}
}
