//
//  HeroDetailViewController.swift
//  LTKProject
//
//  Created by Mustapha Barrie on 9/29/22.
//

import UIKit
import WebKit

class HeroDetailViewController: UIViewController, WKUIDelegate {
    
    var nameLabel = UILabel()
    var profileImageView: UIImageView!
    var heroImageView: UIImageView!
    var productArray = [productModel]()
    
    // With additonal time: Make this its own class to limit the functionality of the DetalViewController
    var productCollectionView: UICollectionView!
    
    let productCellReuseIdentifier = "productCellReuseIdentifier"
    let padding: CGFloat = 8


    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
    }
    
    func setupViews(){
        title = "Profile Page"
        view.backgroundColor = .white
        
        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 20)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        profileImageView = UIImageView(frame: .zero)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        view.addSubview(profileImageView)
        
        heroImageView = UIImageView(frame: .zero)
        heroImageView.translatesAutoresizingMaskIntoConstraints = false
        heroImageView.contentMode = .scaleAspectFit
        heroImageView.clipsToBounds = true
        view.addSubview(heroImageView)
        
        //Setup CollectionView Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
        
        //Setup CollectionView
        productCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        productCollectionView.translatesAutoresizingMaskIntoConstraints = false
        productCollectionView.backgroundColor = .white
        productCollectionView.dataSource = self
        productCollectionView.delegate = self
        productCollectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: productCellReuseIdentifier)
        view.addSubview(productCollectionView)
         
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 150),
            profileImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            heroImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 30),
            heroImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            heroImageView.heightAnchor.constraint(equalToConstant:300)
        ])
        
        NSLayoutConstraint.activate([
            productCollectionView.topAnchor.constraint(equalTo: heroImageView.bottomAnchor,constant: 15),
            productCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            productCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
    }
    
    func config(for profile: profileModel, heroImageURL:String, productArray:[productModel]){
        //Sometimes users don't have a full_name
        nameLabel.text = profile.display_name
        let imageURL = profile.avatar_url
        
        // Batch the request so you don't have to call for profileImage and then heroImage
        NetworkManager.fetchImage(imageURL: imageURL) { image in
            DispatchQueue.main.async {
                self.profileImageView.image = image
            }
        }
        NetworkManager.fetchImage(imageURL: heroImageURL) { image in
            DispatchQueue.main.async {
                self.heroImageView.image = image
            }
        }
        
        self.productArray = productArray
        
        
    }
    

}

extension HeroDetailViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productCellReuseIdentifier, for: indexPath) as! ProductCollectionViewCell
        let product = productArray[indexPath.item]
        cell.configure(for: product)
        return cell
        
    }
    
}

extension HeroDetailViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Instead of creating a webView making it so that safari opens up.
        let product = productArray[indexPath.item]
        let urlString = product.hyperlink
        if let url = URL(string: urlString){
            UIApplication.shared.open(url)
        }

    }
}


extension HeroDetailViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = 4
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: size)
    }
    

}

