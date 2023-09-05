//
//  SaveViewController.swift
//  TokopediaMiniProject
//
//  Created by Barry Juans on 05/09/23.
//

import UIKit

class SaveViewController: UIViewController {
  
  var viewModel: SaveViewModel
  
  lazy var header : UILabel = {
    let i = UILabel()
    i.textAlignment = .left
    i.textColor = .black
    i.text = "You have no selected category"
    i.font = UIFont.systemFont(ofSize: 25.0, weight: .bold)
    return i
  }()
  
  lazy var saved: UILabel = {
    let i = UILabel()
    i.textAlignment = .left
    i.textColor = .black
    return i
  }()
  
  lazy var choose: UILabel = {
    let i = UILabel()
    i.textAlignment = .left
    i.textColor = .link
    i.text = "Choose One"
    i.isUserInteractionEnabled = true
    i.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseOne(_:))))
    return i
  }()
    
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    viewModel = SaveViewModel()
    super.init(nibName: nil, bundle: nil)
    viewModel.delegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    saved.text = viewModel.loadData()
    if saved.text != nil {
      header.text = "You have chosen"
    }
  }

  override func loadView() {
    super.loadView()
    view.backgroundColor = .white
    
    view.addSubview(header)
    header.translatesAutoresizingMaskIntoConstraints = false
    header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.0).isActive = true
    header.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10.0).isActive = true
    header.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10.0).isActive = true
    
    view.addSubview(saved)
    saved.translatesAutoresizingMaskIntoConstraints = false
    saved.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10.0).isActive = true
    saved.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10.0).isActive = true
    saved.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10.0).isActive = true
    
    view.addSubview(choose)
    choose.translatesAutoresizingMaskIntoConstraints = false
    choose.topAnchor.constraint(equalTo:saved.bottomAnchor, constant: 60.0).isActive = true
    choose.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10.0).isActive = true
    choose.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10.0).isActive = true
  }
  
  @objc func chooseOne(_ sender: Any){
    self.navigationController?.pushViewController(ViewController(), animated: false)
  }
}

extension SaveViewController : SaveViewModelProtocol {
  func updateSaved(_ text: String) {
    saved.text = text
    header.text = "You have chosen"
  }
}
