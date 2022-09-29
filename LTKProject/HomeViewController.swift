//
//  ViewController.swift
//  LTKProject
//
//  Created by Mustapha Barrie on 9/28/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    var heroCollectionView: UICollectionView!
    var heroArray = [ltkModel]()
    var profileArray = [profileModel]()
    var productArray = [productModel]()
    
    let heroCellReuseIdentifier = "heroCellReuseIdentifier"
    let padding: CGFloat = 8
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        fetchLTKData()
    }
    
    func setupViews(){
        
        // Adjust background color
        view.backgroundColor = .white
        
        // Main page title
        title = "Home"
        
        //Setup CollectionView Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
        
        //Setup CollectionView
        heroCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        heroCollectionView.translatesAutoresizingMaskIntoConstraints = false
        heroCollectionView.backgroundColor = .white
        heroCollectionView.dataSource = self
        heroCollectionView.delegate = self
        heroCollectionView.register(HeroCollectionViewCell.self, forCellWithReuseIdentifier: heroCellReuseIdentifier)
        view.addSubview(heroCollectionView)
    }
    
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            heroCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 15),
            heroCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            heroCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            heroCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func fetchLTKData(){
        NetworkManager.getLTKData { data in
            self.heroArray = data.ltks
            self.productArray = data.products
            self.profileArray = data.profiles
            DispatchQueue.main.async {
                self.heroCollectionView.reloadData()
            }
        }
    }

}


extension HomeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heroArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: heroCellReuseIdentifier, for: indexPath) as! HeroCollectionViewCell
        let hero = heroArray[indexPath.item]
        cell.configure(for: hero)
        return cell
        
    }
    
}

extension HomeViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = HeroDetailViewController()
        let hero = heroArray[indexPath.item]
        // Associating a profile id with hero hero profile id
        guard let index = profileArray.firstIndex(where: {$0.id == hero.profile_id}) else { return}
        let profile = profileArray[index]
        // Associating all products with a given hero id
        let newArray = productArray.all(where: {$0.ltk_id == hero.id})
        vc.config(for: profile,heroImageURL: hero.hero_image, productArray: newArray)
        navigationController?.pushViewController(vc, animated: true)
        
    }
}


// Essentially making it easy to update depending on the number of cells per row
extension HomeViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = 1
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: size)
    }
    

}

// Needed to find all indicies where a ltk_id matches a hero_id
extension Array where Element: Equatable {
    func all(where predicate: (Element) -> Bool) -> [Element] {
        return self.compactMap { predicate($0) ? $0 : nil }
    }
}




