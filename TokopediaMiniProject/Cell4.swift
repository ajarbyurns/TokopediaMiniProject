//
//  Cell4.swift
//  TokopediaMiniProject
//
//  Created by Barry Juans on 07/09/23.
//

import UIKit

class Cell4: UICollectionViewCell {
  
  private lazy var loading : UIActivityIndicatorView = {
    let loading = UIActivityIndicatorView(style: .large)
    loading.color = .black
    loading.hidesWhenStopped = false
    loading.startAnimating()
    return loading
  }()
  
  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    return imageView
  }()
  
  private lazy var header: UILabel = {
    let i = UILabel()
    i.textColor = .black
    i.textAlignment = .center
    i.numberOfLines = 0
    i.adjustsFontSizeToFitWidth = true
    return i
  }()
  
  var viewModel : Cell4ViewModel?{
    didSet{
      imageView.image = nil
      header.text = viewModel?.item.name
      viewModel?.delegate = self
      viewModel?.loadImage()
    }
  }
  
  override init(frame : CGRect){
    super.init(frame: frame)
    setupViews()
  }
  
  private func setupViews(){
    backgroundColor = .white
    
    addSubview(loading)
    loading.translatesAutoresizingMaskIntoConstraints = false
    loading.widthAnchor.constraint(equalToConstant: 30).isActive = true
    loading.heightAnchor.constraint(equalToConstant: 30).isActive = true
    loading.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    loading.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    
    let content = UIView()
    content.backgroundColor = .clear
    addSubview(content)
    content.translatesAutoresizingMaskIntoConstraints = false
    content.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    content.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    
    content.addSubview(header)
    header.translatesAutoresizingMaskIntoConstraints = false
    header.leadingAnchor.constraint(equalTo: content.leadingAnchor).isActive = true
    header.trailingAnchor.constraint(equalTo: content.trailingAnchor).isActive = true
    header.bottomAnchor.constraint(equalTo: content.bottomAnchor).isActive = true
    
    content.addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.widthAnchor.constraint(equalTo: content.widthAnchor).isActive = true
    imageView.topAnchor.constraint(equalTo: content.topAnchor).isActive = true
    imageView.bottomAnchor.constraint(equalTo: header.topAnchor).isActive = true
  }
   
  required init?(coder: NSCoder) {
    fatalError("Not In Storyboard")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    loading.isHidden = false
    loading.startAnimating()
  }
  
}

extension Cell4 : Cell4Delegate {
  func imageLoaded(_ imageData: Data) {
    imageView.image = UIImage(data: imageData)
    loading.isHidden = true
  }
  
  func filterText(_ filterText: String) {
    if(filterText.isEmpty) {
      header.text = viewModel?.item.name ?? ""
    } else {
      let attributeText = NSMutableAttributedString(string: header.text ?? "")
      let range: NSRange = attributeText.mutableString.range(of: filterText, options: .caseInsensitive)
      attributeText.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: header.font.pointSize), range: range)
      header.attributedText = attributeText
    }
  }
}
