//
//  ViewModel.swift
//  TokopediaMiniProject
//
//  Created by Barry Juans on 05/09/23.
//

import Foundation

protocol ViewModelProtocol: AnyObject {
  func updateData()
  func addRowsAt(_ indexPaths: [IndexPath])
  func removeRowsAt(_ indexPaths: [IndexPath])
}

class ViewModel {
  var items: [Category] = []
  private var tempItems: [Category] = []
  weak var delegate: ViewModelProtocol?
  var filterText: String = ""{
    didSet{
      filter(filterText)
    }
  }
  
  func getData(){
    let bundle = Bundle(for: type(of: self))
    if let path = bundle.path(forResource: "data", ofType: "json") {
        if let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: path)) {
          do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
            tempItems = CategoryData(json).data?.categoryAllList?.categories ?? []
            items = tempItems
            delegate?.updateData()
          } catch {
            print(error)
          }
        } else {
          print("Error found")
        }
    } else {
        print("Error found")
    }
  }
  
  func getDataFromURL() {
    guard let url = URL(string : "https://hades.tokopedia.com/category/v1/tree/all") else {
      return
    }
    
    let request = URLRequest(url: url)
            
    URLSession.shared.dataTask(with: request) { data, response, error in
                    
        guard error == nil, let data = data else {
            DispatchQueue.main.async {
                print("Error With Connection")
            }
            return
        }
        
        do {
          let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
          
          let categoryData = json["data"] as! [String : Any]
          let categories = Categories(categoryData)
            
          DispatchQueue.main.async {
            self.tempItems = categories.categories
            self.items = self.tempItems
            self.delegate?.updateData()
          }
        } catch {
            DispatchQueue.main.async {
              print("Error With Connection")
            }
        }
    }.resume()
  }
  
  func didSelect(at index: Int){
    let item = items[index]
    if item.isExpanded {
      contract(at: index)
    } else {
      if item.categoryLevel != 3 {
        expand(at: index)
      }
    }
  }
  
  private func expand(at index: Int, _ update: Bool = true){
    var item = items[index]
    let temp = item.child
    guard temp.count > 0, !item.isExpanded else {
      return
    }
    if item.categoryLevel == 1 {
      items.insert(contentsOf: temp, at: index+1)
      var indexPaths : [IndexPath] = []
      for i in 0..<temp.count {
        let indexPath = IndexPath(row: index + 1 + i, section: 0)
        indexPaths.append(indexPath)
      }
      if update {
        delegate?.addRowsAt(indexPaths)
      }
    } else if item.categoryLevel == 2 {
      item.categoryLevel = 3
      items.insert(item, at: index+1)
      let indexPath = IndexPath(row: index + 1, section: 0)
      if update {
        delegate?.addRowsAt([indexPath])
      }
    }
    items[index].isExpanded = true
  }
  
  private func contract(at index: Int, _ update: Bool = true){
    let item = items[index]
    let temp = item.child
    guard temp.count > 0, item.isExpanded else {
      return
    }
    if item.categoryLevel == 1 {
      for i in (1...temp.count).reversed() {
        if items[index+i].isExpanded {
          contract(at: index + i)
        }
      }
      let begin = index + 1
      let end = begin + temp.count - 1
      items.removeSubrange(begin...end)
      var indexPaths : [IndexPath] = []
      for i in 0..<temp.count {
        let indexPath = IndexPath(row: index + 1 + i, section: 0)
        indexPaths.append(indexPath)
      }
      if update {
        delegate?.removeRowsAt(indexPaths)
      }
    } else if item.categoryLevel == 2 {
      items.remove(at: index+1)
      let indexPath = IndexPath(row: index + 1, section: 0)
      if update {
        delegate?.removeRowsAt([indexPath])
      }
    }
    items[index].isExpanded = false
  }
  
  private func filter(_ text: String){
    if text.isEmpty {
      items = tempItems
      delegate?.updateData()
      return
    }
    
    var temp = tempItems
    for i in 0..<temp.count {
      for j in 0..<temp[i].child.count {
        temp[i].child[j].child.removeAll(where: {!$0.name.lowercased().contains(text.lowercased())})
      }
      temp[i].child.removeAll(where: {$0.child.isEmpty && !$0.name.lowercased().contains(text.lowercased())})
    }
    temp.removeAll(where: {$0.child.isEmpty && !$0.name.lowercased().contains(text.lowercased())})
    
    items = temp
    
    for i in (0..<items.count).reversed() {
      expand(at: i, false)
      let start = i+1
      let end = start + items[i].child.count
      for j in (start..<end).reversed() {
        expand(at: j, false)
      }
    }
    
    delegate?.updateData()
  }
}
