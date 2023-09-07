//
//  Cell3.swift
//  TokopediaMiniProject
//
//  Created by Barry Juans on 05/09/23.
//

import UIKit

protocol Cell3Delegate : AnyObject {
  func saveCategory(_ text: String)
}

class Cell3: UITableViewCell {
  
  var children: [Category] = []{
    didSet{
      collectionView.reloadData()
    }
  }
  
  var filterText: String = ""
  weak var delegate: Cell3Delegate?
  
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.itemSize = CGSize(width: 100, height: 140)
    layout.minimumInteritemSpacing = 1000
    let i = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
    i.isScrollEnabled = true
    i.isUserInteractionEnabled = true
    i.collectionViewLayout = layout
    i.register(Cell4.self, forCellWithReuseIdentifier: "Cell4")
    i.delegate = self
    i.dataSource = self
    return i
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
    
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }
  
  private func setup(){
    contentView.addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30.0).isActive = true
    collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0).isActive = true
  }

}

extension Cell3 : UICollectionViewDelegate, UICollectionViewDataSource {
    
    var inset: CGFloat {
      get { return 10 }
    }
  
    func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return children.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      delegate?.saveCategory(children[indexPath.row].name)
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell4", for: indexPath) as? Cell4 ?? Cell4()
      cell.viewModel = Cell4ViewModel(children[indexPath.row])
      cell.viewModel?.filterText = filterText
      cell.layoutIfNeeded()
      return cell
    }
    
}
