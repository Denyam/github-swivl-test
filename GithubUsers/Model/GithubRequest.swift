//
//  Request.swift
//  GithubUsers
//
//  Created by Denis on 06/02/2016.
//  Copyright © 2016 Denis. All rights reserved.
//

import UIKit
import Alamofire

class GithubRequest {
	static let requestUrl = "https://api.github.com/users"
	static let sinceKey = "since"
	static let perPageKey = "per_page"
	static let loginKey = "login"
	static let profileUrlKey = "html_url"
	static let avatarUrlKey = "avatar_url"

	func perform(since since: Int = 0, perPage: Int = 30, completion: (users: [User]?) -> ()) {
		Alamofire.request(.GET, GithubRequest.requestUrl, parameters: [GithubRequest.sinceKey: "\(since)", GithubRequest.perPageKey: "\(perPage)",], encoding: .URL, headers: nil).responseJSON { (response: Response<AnyObject, NSError>) in
			if let usersJson = response.result.value as? [[String: AnyObject]] {
				var usersList = [User]()
				for userDict in usersJson  {
					if let login = userDict[GithubRequest.loginKey] as? String,
						profileUrl = userDict[GithubRequest.profileUrlKey] as? String,
						avatarUrl = userDict[GithubRequest.avatarUrlKey] as? String {
						let user = User(login: login, profileUrl: profileUrl, avatarUrl: avatarUrl)
						usersList.append(user)
					}
				}

				completion(users: usersList)
			} else {
				completion(users: nil)
			}
		}
	}
}
