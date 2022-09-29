//
//  HeroCollectionViewCell.swift
//  LTKProject
//
//  Created by Mustapha Barrie on 9/28/22.
//

import UIKit


class HeroCollectionViewCell: UICollectionViewCell {
    
    var heroImageView: UIImageView!
    
    
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
        heroImageView = UIImageView(frame: .zero)
        heroImageView.translatesAutoresizingMaskIntoConstraints = false
        heroImageView.contentMode = .scaleAspectFit
        contentView.addSubview(heroImageView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            heroImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            heroImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            heroImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            heroImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        
        ])
    }
    
    func configure(for heroModel:ltkModel){
        let imageURL = heroModel.hero_image
        NetworkManager.fetchImage(imageURL: imageURL) { image in
            DispatchQueue.main.async {
                self.heroImageView.image = image
            }
        }
        
        
    }
    
    
}
