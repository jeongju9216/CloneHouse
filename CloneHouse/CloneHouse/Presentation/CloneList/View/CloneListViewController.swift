//
//  CloneListViewController.swift
//  CloneZip
//
//  Created by 유정주 on 2023/05/22.
//

import UIKit

final class CloneListViewController: UIViewController {
    enum Sections: Int, CaseIterable {
        case news, app
    }
    
    //MARK: - Views
    @IBOutlet weak var collectionView: UICollectionView!
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Sections, CloneApp>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Sections, CloneApp>

    //MARK: - Properties
    private lazy var dataSource: DataSource = setupDataSource()
    private var snapshot: SnapShot = SnapShot()
    
    private let testAppData = [CloneApp(title: "Jetflix", description: "넷플릭스 클론 코딩 앱", version: "v1.0.0", releaseDate: "2023.06.08"),
                            CloneApp(title: "Jetflix", description: "Test", version: "Test", releaseDate: "Test"),
                            CloneApp(title: "Jetflix", description: "Test", version: "Test", releaseDate: "Test"),
                            CloneApp(title: "Jetflix", description: "Test", version: "Test", releaseDate: "Test"),
                            CloneApp(title: "Jetflix", description: "Test", version: "Test", releaseDate: "Test")]
    private let testNewsData = [CloneApp(title: "Jetflix", description: "넷플릭스 클론 코딩 앱", version: "v1.0.0", releaseDate: "2023.06.08"),
                            CloneApp(title: "Jetflix", description: "Test", version: "Test", releaseDate: "Test"),
                            CloneApp(title: "Jetflix", description: "Test", version: "Test", releaseDate: "Test"),
                            CloneApp(title: "Jetflix", description: "Test", version: "Test", releaseDate: "Test"),
                            CloneApp(title: "Jetflix", description: "Test", version: "Test", releaseDate: "Test")]
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        initTestData()
    }
    
    //MARK: - Setup
    private func setupUI() {
        setupNavigationBar()
        setupCollectionView()
    }
    
    private func setupNavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
        //configureWithTransparentBackground는 스크롤할 때 뒤가 안 가려져서 컬러로 지정함
        navBarAppearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        
        navigationController?.navigationBar.tintColor = .label
        
        let logoItem = UIButton(type: .custom)
        logoItem.setImage(UIImage(named: "LogoImage"), for: .normal)
        let leftItem = UIBarButtonItem(customView: logoItem)
        leftItem.customView?.widthAnchor.constraint(equalToConstant: 24 * (1414.0 / 261.0)).isActive = true
        leftItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        navigationItem.leftBarButtonItem = leftItem
        
        navigationItem.rightBarButtonItems = [
            //티스토리 블로그로 이동
            UIBarButtonItem(image: UIImage(systemName: "t.square"), style: .plain, target: self, action: nil),
        ]
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.collectionViewLayout = createCollectionViewLayout()
        collectionView.showsVerticalScrollIndicator = false
        
        registerCollectionViewCell()
    }
    
    private func initTestData() {
        //테스트 데이터
        updateCloneAppList(data: testAppData)
        
        updateCircleIconList(data: testNewsData)
    }
}

//MARK: - Setup CollectionView
extension CloneListViewController {
    private func updateCloneAppList(data: [CloneApp], animate: Bool = false) {
        snapshot = SnapShot()
        snapshot.appendSections([.app])
        
        snapshot.appendItems(data, toSection: .app)
        
        dataSource.apply(snapshot, animatingDifferences:  false)
    }
    
    private func updateCircleIconList(data: [CloneApp], animate: Bool = false) {
        if snapshot.indexOfSection(.news) == nil {
            snapshot.insertSections([.news], beforeSection: .app)
        }
        
        snapshot.appendItems(data, toSection: .news)
        
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
    
    private func registerCollectionViewCell() {
        collectionView.register(DefaultCollectionViewCell.cellClassWithNib, forCellWithReuseIdentifier: DefaultCollectionViewCell.idenfier)
        collectionView.register(CloneListCollectionViewCell.cellClassWithNib, forCellWithReuseIdentifier: CloneListCollectionViewCell.idenfier)
        collectionView.register(CircleIconCollectionViewCell.cellClassWithNib, forCellWithReuseIdentifier: CircleIconCollectionViewCell.idenfier)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let defaultSection = NSCollectionLayoutSection.list(using: .init(appearance: .plain), layoutEnvironment: layoutEnvironment)
            guard let self = self else { return defaultSection }
            
            let section = self.snapshot.sectionIdentifiers[sectionIndex]
            print("Section: \(section)")
            switch section {
            case .news:
                return createNewsSection()
            case .app:
                return createAppsSection()
            }
        }
        
        return layout
    }
    
    private func setupDataSource() -> DataSource {
        let cellProvider = { [weak self] (collectionView: UICollectionView, indexPath: IndexPath, product: CloneApp) -> UICollectionViewCell? in
            let defaultCell = collectionView.dequeueReusableCell(withReuseIdentifier: DefaultCollectionViewCell.idenfier, for: indexPath)
            guard let self = self else { return defaultCell }
            
            let section = self.snapshot.sectionIdentifiers[indexPath.section]
            switch section {
            case .news:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CircleIconCollectionViewCell.idenfier, for: indexPath) as? CircleIconCollectionViewCell else {
                    return defaultCell
                }
                
                if indexPath.row % 2 == 0 {
                    cell.configuration(with: product, isNew: true)
                } else {
                    cell.configuration(with: product, isNew: false)
                }
                
                return cell
            case .app:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CloneListCollectionViewCell.idenfier, for: indexPath) as? CloneListCollectionViewCell else {
                    return defaultCell
                }
                
                cell.configuration(with: product)
                
                return cell
            }
        }
        
        let dataSource = DataSource(collectionView: collectionView, cellProvider: cellProvider)
        return dataSource
    }
    
    private func createNewsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(80),
                                              heightDimension: .absolute(80))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
        group.edgeSpacing = .init(leading: .fixed(10), top: .none, trailing: .fixed(10), bottom: .none)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 10, leading: 0, bottom: 10, trailing: 0)
        
        return section
    }
    
    private func createAppsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(140))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
}

//MARK: - UICollectionViewDelegate
extension CloneListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
    }
}
