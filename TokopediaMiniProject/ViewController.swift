//
//  ViewController.swift
//  TokopediaMiniProject
//
//  Created by Nakama on 06/11/20.
//

import UIKit

class ViewController: UIViewController {
  
  var viewModel: ViewModel
    
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    viewModel = ViewModel()
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private lazy var searchImage: UIImageView = {
    let i = UIImageView(image: UIImage(systemName: "magnifyingglass"))
    i.tintColor = .darkGray
    return i
  }()
  
  private lazy var searchTextField: UITextField = {
    let i = UITextField()
    i.keyboardType = .webSearch
    i.clearsOnBeginEditing = true
    i.delegate = self
    return i
  }()
  
  private lazy var tableView: UITableView = {
    let item = UITableView()
    item.delegate = self
    item.dataSource = self
    item.register(Cell1.self, forCellReuseIdentifier: "Cell1")
    item.register(Cell2.self, forCellReuseIdentifier: "Cell2")
    item.register(Cell3.self, forCellReuseIdentifier: "Cell3")
    return item
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.delegate = self
    viewModel.getDataFromURL()
  }
  
  override func loadView() {
    super.loadView()
    
    navigationController?.navigationBar.isHidden = true
    view.backgroundColor = .white
    
    let searchView = UIView()
    searchView.layer.cornerRadius = 10
    searchView.backgroundColor = .lightGray
    view.addSubview(searchView)
    searchView.translatesAutoresizingMaskIntoConstraints = false
    searchView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
    searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    
    searchView.addSubview(searchImage)
    searchImage.translatesAutoresizingMaskIntoConstraints = false
    searchImage.topAnchor.constraint(equalTo: searchView.topAnchor, constant: 10).isActive = true
    searchImage.leadingAnchor.constraint(equalTo: searchView.leadingAnchor, constant: 10).isActive = true
    searchImage.bottomAnchor.constraint(equalTo: searchView.bottomAnchor, constant: -10).isActive = true
    searchImage.widthAnchor.constraint(equalTo: searchImage.heightAnchor, multiplier: 1).isActive = true

    searchView.addSubview(searchTextField)
    searchTextField.keyboardType = .webSearch
    searchTextField.translatesAutoresizingMaskIntoConstraints = false
    searchTextField.translatesAutoresizingMaskIntoConstraints = false
    searchTextField.leadingAnchor.constraint(equalTo: searchImage.trailingAnchor, constant: 10).isActive = true
    searchTextField.trailingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: -10).isActive = true
    searchTextField.topAnchor.constraint(equalTo: searchView.topAnchor, constant: 10).isActive = true
    searchTextField.bottomAnchor.constraint(equalTo: searchView.bottomAnchor, constant: -10).isActive = true
    
    view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.topAnchor.constraint(equalTo: searchView.bottomAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true

  }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50.0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.items.count
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.didSelect(at: indexPath.row)
    tableView.deselectRow(at: indexPath, animated: false)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let item = viewModel.items[indexPath.row]
    switch item.categoryLevel {
      case 2:
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2") as? Cell2 ?? Cell2()
        cell.title = item.name
        cell.filterText = viewModel.filterText
        cell.children = item.childrenCount
        return cell
      case 3:
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3") as? Cell3 ?? Cell3()
        cell.title = item.name
        cell.filterText = viewModel.filterText
        return cell
      default:
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1") as? Cell1 ?? Cell1()
        cell.title = item.name
        cell.filterText = viewModel.filterText
        cell.children = item.childrenCount
        return cell
    }
  }
  
}

extension ViewController: ViewModelProtocol {
  func updateData() {
    tableView.reloadData()
  }
  
  func saveCategory(_ text: String) {
    if let navController = self.navigationController, navController.viewControllers.count >= 2 {
      if let viewController = navController.viewControllers[navController.viewControllers.count - 2] as? SaveViewController {
        viewController.viewModel.saveData(text)
        navController.popViewController(animated: false)
      }
    }
  }
}

extension ViewController : UITextFieldDelegate {
    
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    viewModel.filterText = textField.text ?? ""
  }
    
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if let text = textField.text, let textRange = Range(range, in: text) {
      viewModel.filterText = text.replacingCharacters(in: textRange, with: string)
    }
    return true
  }
}
