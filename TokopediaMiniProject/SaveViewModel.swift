//
//  SaveViewModel.swift
//  TokopediaMiniProject
//
//  Created by Barry Juans on 05/09/23.
//

import Foundation

protocol SaveViewModelProtocol : AnyObject{
  func updateSaved(_ text: String)
}

class SaveViewModel {
  
  weak var delegate: SaveViewModelProtocol?
  
  func saveData(_ input: String) {
    UserDefaults.standard.set(input, forKey: "Saved Category")
    delegate?.updateSaved(input)
  }
  
  func loadData() -> String? {
    return UserDefaults.standard.string(forKey: "Saved Category")
  }
  
}
