//
//  RestaurantModel.swift
//  Restaurant Roulette
//
//  Created by Allen Fang, Harrison Mai, Alan Le, Sam Moon on 5/24/17.
//  Copyright © 2017 Allen Fang, Harrison Mai, Alan Le, Sam Moon. All rights reserved.
//

import Foundation

class RestaurantModel {
    
    // get restaurants
    static func getAllRestaurants(lat: Double, long: Double, preference: String, completionHandler:@escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        print(lat)
        print(long)
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/radarsearch/json?location=\(lat),\(long)&radius=8000&type=restaurant&keyword=\(preference)&key=AIzaSyDzSGt90_fYo0UMF37ub-6slUWVKh0n6mc")
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: completionHandler)
        task.resume()
    }
    
    // get single restaurant
    static func getRestaurantWithID(id: String, completionHandler:@escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(id)&key=AIzaSyDzSGt90_fYo0UMF37ub-6slUWVKh0n6mc")
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: completionHandler)
        task.resume()
    }
}



