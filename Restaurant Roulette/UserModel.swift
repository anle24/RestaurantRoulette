//
//  UserModel.swift
//  Restaurant Roulette
//
//  Created by Allen Fang, Harrison Mai, Alan Le, Sam Mooon 5/25/17.
//  Copyright © Allen Fang, Harrison Mai, Alan Le, Sam Moon. All rights reserved.
//

import Foundation

class UserModel {
    static func getAllUsers(completionHandler: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let url = URL(string: "http://54.244.42.248/")!
        let session = URLSession.shared
        let user  = session.dataTask(with: url, completionHandler: completionHandler)
        user.resume()
    }
    
    static func addUser(username: String, email: String, password: String, completionHandler: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        // Create the url to request
        let url = URL(string: "http://54.244.42.248/newuser")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let bodyData = "username=\(username)&email=\(email)&password=\(password)"
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        let user = session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
        user.resume()
    }
    
    static func editUser(score: Int, completionHandler: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        // Create the url to request
        let url = URL(string: "http://54.244.42.248/editUser")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        
        let bodyData = "score=\(score)"
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        let user = session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
        user.resume()
    }
    
    static func loginUser(username: String, password: String, completionHandler: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        
        let url = URL(string: "http:/54.244.42.248/login")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let bodyData = "username=\(username)&password=\(password)"
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        let user = session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
        user.resume()
    }
}
