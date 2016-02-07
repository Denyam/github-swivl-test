//
//  User.swift
//  GithubUsers
//
//  Created by Denis on 06/02/2016.
//  Copyright © 2016 Denis. All rights reserved.
//

import UIKit

class User {
	init(login username: String, profileUrl: String, avatarUrl: String) {
		self.login = username
		self.profileUrl = profileUrl
		self.avatarUrl = avatarUrl
	}
	
	var login: String
	var profileUrl: String
	var avatarUrl: String
}
