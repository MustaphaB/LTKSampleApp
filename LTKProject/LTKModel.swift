//
//  LTKModel.swift
//  LTKProject
//
//  Created by Mustapha Barrie on 9/28/22.
//

import Foundation

// not using all fields, but interesting usecases for adding additonal UI with added time, such as caption, share button
struct ltkModel:Codable{
    var hero_image: String
    var hero_image_width: Int
    var hero_image_height: Int
    var id: String
    var profile_id: String
    var profile_user_id: String
    var caption: String
    var share_url:String
    var product_ids:[String]
}


struct profileModel:Codable{
    var id:String
    var avatar_url:String
    var display_name:String
    var full_name: String
    var bio: String
}

// Made Equatable in order to use extension on productArray -> mapping ltk_ids to hero_id
struct productModel:Codable, Equatable{
    var id:String
    var ltk_id:String
    var hyperlink:String
    var image_url:String
}


struct LTKDataResponse:Codable{
    var ltks:[ltkModel]
    var profiles:[profileModel]
    var products:[productModel]
}
