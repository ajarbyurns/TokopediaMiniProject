//
//  Cell2.swift
//  TokopediaMiniProject
//
//  Created by Barry Juans on 05/09/23.
//

import UIKit

class Cell2: UITableViewCell {

  var title : String = ""{
    didSet{
      header.text = title
    }
  }
  
  var children: Int = 0{
    didSet{
      childrenCount.text = (children > 0) ? "\(children) Children" : nil
    }
  }
  
  var filterText: String = ""{
    didSet{
      if(filterText.isEmpty) {
        header.text = title
      } else {
        let attributeText = NSMutableAttributedString(string: header.text ?? "")
        let range: NSRange = attributeText.mutableString.range(of: filterText, options: .caseInsensitive)
        attributeText.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: header.font.pointSize), range: range)
        header.attributedText = attributeText
      }
    }
  }
  
  private lazy var header: UILabel = {
    let i = UILabel()
    i.textColor = .black
    i.textAlignment = .left
    return i
  }()
  
  private lazy var childrenCount: UILabel = {
    let i = UILabel()
    i.textColor = .lightGray
    i.textAlignment = .right
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
    addSubview(header)
    header.translatesAutoresizingMaskIntoConstraints = false
    header.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
    header.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
    header.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20.0).isActive = true
    
    addSubview(childrenCount)
    childrenCount.translatesAutoresizingMaskIntoConstraints = false
    childrenCount.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
    childrenCount.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
    childrenCount.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10.0).isActive = true
  }

}
