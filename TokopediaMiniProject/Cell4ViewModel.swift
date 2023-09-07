//
//  Cell4ViewModel.swift
//  TokopediaMiniProject
//
//  Created by Barry Juans on 07/09/23.
//

import Foundation

protocol Cell4Delegate : AnyObject {
  func imageLoaded(_ imageData : Data)
  func filterText(_ filterText: String)
}

var imageDataCache = NSCache<AnyObject, AnyObject>()

class Cell4ViewModel : NSObject {
    
  weak var delegate : Cell4Delegate?
  var item: Category
  var filterText: String = ""{
    didSet{
      delegate?.filterText(filterText)
    }
  }
  var categoryImgData : Data?{
    didSet{
      if let data = categoryImgData {
        delegate?.imageLoaded(data)
      }
    }
  }
  
  init(_ item : Category){
    self.item = item
    self.categoryImgData = imageDataCache.object(forKey: item.iconImageUrl as AnyObject) as? Data
  }
  
  func loadImage(){
    if let imgData = categoryImgData {
        delegate?.imageLoaded(imgData)
        return
    }
    
    guard let url = URL(string: item.iconImageUrl) else {
      DispatchQueue.main.async {
        print(self.item.iconImageUrl)
        print("URL Error")
      }
      return
    }
    
    URLSession.shared.dataTask(with: url) {
      data, response, error in
      
      guard error == nil, let data = data else {
          DispatchQueue.main.async{
              print("Connection Error")
          }
          return
      }
      
      DispatchQueue.main.async {
        imageDataCache.setObject(data as AnyObject, forKey: self.item.iconImageUrl as AnyObject)
        self.categoryImgData = data
      }
    }.resume()
  }
  
}
