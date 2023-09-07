//
//  Model.swift
//  TokopediaMiniProject
//
//  Created by Barry Juans on 05/09/23.
//

import Foundation

struct Category {
  var id: String
  var categoryLevel: Int = 1
  var isExpanded: Bool = false
  var name: String
  var identifier: String
  var url: String
  var iconImageUrl: String
  var iconImageUrlGray: String
  var parentName: String
  var appLinks: String?
  var iconBannerURL: String
  var child: [Category] = []
  var childrenCount: Int = 0
  
  init(_ json: [String: Any?], _ level: Int = 1) {
    id = json["id"] as? String ?? ""
    name = json["name"] as? String ?? ""
    categoryLevel = level
    identifier = json["identifier"] as? String ?? ""
    url = json["url"] as? String ?? ""
    iconImageUrl = json["icon_image_url"] as? String ?? ""
    iconImageUrlGray = json["iconImageUrlGray"] as? String ?? ""
    parentName = json["parentName"] as? String ?? ""
    appLinks = json["appLinks"] as? String ?? ""
    iconBannerURL = json["iconBannerURL"] as? String ?? ""
    if let children = json["child"] as? [[String : Any]] {
      for i in 0..<children.count {
        child.append(Category(children[i], level + 1))
      }
    }
    childrenCount = child.count
  }
}

struct Categories {
  var categories : [Category] = []
  
  init(_ json: [String : Any]){
    if let items = json["categories"] as? [[String : Any]] {
      for i in 0..<items.count {
        categories.append(Category(items[i], 1))
      }
    }
  }
}

struct CategoryAllList {
  var categoryAllList: Categories?
  
  init(_ json: [String : Any]){
    if let input = json["categoryAllList"] as? [String : Any] {
      categoryAllList = Categories(input)
    }
  }
}

struct CategoryData {
  var data: CategoryAllList?
  
  init(_ json: [String : Any]){
    if let input = json["data"] as? [String : Any] {
      data = CategoryAllList(input)
    }
  }
}
