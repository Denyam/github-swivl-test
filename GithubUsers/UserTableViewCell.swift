//
//  UserTableViewCell.swift
//  GithubUsers
//
//  Created by Denis on 07/02/2016.
//  Copyright © 2016 Denis. All rights reserved.
//

import UIKit

protocol UserTableViewCellDelegate: class {
	func userTableViewCellShowAvatar(cell: UserTableViewCell)
}

class UserTableViewCell: UITableViewCell {
	@IBOutlet weak var avatarButton: UIButton?
	@IBOutlet weak var usernameLabel: UILabel?
	@IBOutlet weak var profileLinkButton: UIButton?
	
	weak var delegate: UserTableViewCellDelegate?
	
    override func awakeFromNib() {
        super.awakeFromNib()
		
		self.profileLinkButton?.contentHorizontalAlignment = .Left
    }

	@IBAction func showAvatar(sender: UIButton) {
		self.delegate?.userTableViewCellShowAvatar(self)
	}
	
	@IBAction func openProfile(sender: UIButton) {
		if let urlString = self.profileLinkButton?.attributedTitleForState(.Normal)?.string, url = NSURL(string: urlString) {
			UIApplication.sharedApplication().openURL(url)
		}
	}
	
	func setProfileLink(text: String) {
		let attributedLink = NSAttributedString(string: text, attributes: [NSUnderlineStyleAttributeName: true, NSForegroundColorAttributeName: UIColor.blueColor()])
		self.profileLinkButton?.setAttributedTitle(attributedLink, forState: .Normal)
	}
}
