//
//  LikedPostViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 19/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import UIKit

class LikedPostViewController: UICollectionViewController {

    lazy var prototype: PostListCollectionCell! = PostListCollectionCell()
    
    lazy var loadingView: UIActivityIndicatorView! = {
        let view = UIActivityIndicatorView(style: .gray)
        view.hidesWhenStopped = true
        return view
    }()
    
    lazy var emptyView: GhostView! = {
        let view = GhostView()
        view.titleLabel.text = "No posts"
        return view
    }()
    
    lazy var refreshView: UIRefreshControl! = {
        let view = UIRefreshControl()
        view.addTarget(
            self,
            action: #selector(self.triggerRefresh),
            for: .valueChanged)
        return view
    }()
    
    var listLayout: UICollectionViewFlowLayout!
    var presenter: LikedPostModuleInterface!
    
    var isLoadingViewHidden: Bool = false {
        didSet {
            guard collectionView != nil else {
                return
            }
            
            if isLoadingViewHidden {
                loadingView.stopAnimating()
                if collectionView!.backgroundView == loadingView {
                    collectionView!.backgroundView = nil
                }
                
            } else {
                loadingView.frame = collectionView!.bounds
                loadingView.startAnimating()
                collectionView!.backgroundView = loadingView
            }
        }
    }
    
    var isEmptyViewHidden: Bool = false {
        didSet {
            guard collectionView != nil else {
                return
            }
            
            if isEmptyViewHidden {
                if collectionView!.backgroundView == emptyView {
                    collectionView!.backgroundView = nil
                }
                
            } else {
                emptyView.frame = collectionView!.bounds
                collectionView!.backgroundView = emptyView
            }
        }
    }
    
    var isRefreshingViewHidden: Bool = false {
        didSet {
            guard collectionView != nil else {
                return
            }
            
            if refreshView.superview == nil {
                collectionView!.addSubview(refreshView)
            }
            
            if isRefreshingViewHidden {
                refreshView.endRefreshing()
                
            } else {
                refreshView.beginRefreshing()
            }
        }
    }
    
    convenience init() {
        let layout = UICollectionViewFlowLayout()
        self.init(collectionViewLayout: layout)
        self.listLayout = layout
    }
    
    override func loadView() {
        super.loadView()
        
        guard collectionView != nil else {
            return
        }
        
        collectionView!.alwaysBounceVertical = true
        collectionView!.backgroundColor = UIColor.white
        
        let size = collectionView!.frame.size
        
        listLayout.configure(with: size.width, columnCount: 1)
        listLayout.headerReferenceSize = CGSize(width: size.width, height: 48)
        listLayout.sectionHeadersPinToVisibleBounds = false
        
        PostListCollectionCell.register(in: collectionView!)
        PostListCollectionHeader.register(in: collectionView!)
        
        prototype.bounds.size.width = size.width
        
        setupNavigationItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
    func setupNavigationItem() {
        let barItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "back_nav_icon"),
            style: .plain,
            target: self,
            action: #selector(self.back))
        
        navigationItem.leftBarButtonItem = barItem
        
        navigationItem.title = "Liked Post"
    }
    
    @objc func back() {
        presenter.exit()
    }
    
    @objc func triggerRefresh() {
        presenter.refresh()
    }
}

extension LikedPostViewController: LikedPostScene {
    
    var controller: UIViewController? {
        return self
    }
    
    func reload() {
        collectionView?.reloadData()
    }
    
    func reload(at index: Int) {
        let indexSet: IndexSet = [index]
        collectionView?.reloadSections(indexSet)
    }
    
    func didRefresh(error: String?) {
        
    }
    
    func didLoadMore(error: String?) {
        
    }
    
    func didLike(error: String?) {
        
    }
    
    func didUnlike(error: String?) {
        
    }
}
