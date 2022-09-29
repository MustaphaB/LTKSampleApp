//
//  ProductCollectionViewCell.swift
//  LTKProject
//
//  Created by Mustapha Barrie on 9/29/22.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    var productImageView: UIImageView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        //Setup imageView for heroes
        productImageView = UIImageView(frame: .zero)
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.contentMode = .scaleAspectFit
        contentView.addSubview(productImageView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        
        ])
    }
    
    func configure(for product:productModel){
        let imageURL = product.image_url
        NetworkManager.fetchImage(imageURL: imageURL) { image in
            DispatchQueue.main.async {
                self.productImageView.image = image
            }
        }
        
        
    }
}
