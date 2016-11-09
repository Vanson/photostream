//
//  NewsFeedViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 16/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import MONUniformFlowLayout
import DateTools

class NewsFeedViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: MONUniformFlowLayout!
    
    lazy var refreshControl = UIRefreshControl()
    lazy var indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    lazy var emptyView = EmptyView.createNew()
    
    var shouldDisplayIndicatorView: Bool = false {
        didSet {
            if shouldDisplayIndicatorView {
                indicatorView.startAnimating()
                collectionView.backgroundView = indicatorView
            } else {
                indicatorView.stopAnimating()
                collectionView.backgroundView = nil
            }
        }
    }
    
    var shouldDisplayEmptyView: Bool = false {
        didSet {
            if shouldDisplayEmptyView {
                collectionView.backgroundView = emptyView
            } else {
                collectionView.backgroundView = nil
            }
        }
    }
    
    var isRefreshing: Bool = false {
        didSet {
            if isRefreshing {
                refreshControl.beginRefreshing()
            } else {
                refreshControl.endRefreshing()
            }
        }
    }
    
    var presenter: NewsFeedModuleInterface!
    lazy var scrollHandler = ScrollHandler()
    lazy var sizeHandler = DynamicSizeHandler<String,String>()

    override func loadView() {
        super.loadView()
        
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        
        emptyView.actionHandler = { (view) in
            self.triggerInitialLoad()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flowLayout.enableStickyHeader = true
        
        PostListCell.registerPrototype(in: &sizeHandler)
        PostListCell.registerNib(in: collectionView)
        PostListHeader.registerNib(in: collectionView)
        PostListFooter.registerClass(in: collectionView)
        
        scrollHandler.scrollView = collectionView
        triggerInitialLoad()
    }
    
    func triggerInitialLoad() {
        shouldDisplayIndicatorView = true
        presenter.refreshFeeds()
    }
}

extension NewsFeedViewController: NewsFeedViewInterface {
    
    var controller: UIViewController? {
        return self
    }

    func reloadView() {
        collectionView.reloadData()
    }

    func showEmptyView() {
        shouldDisplayEmptyView = true
    }
    
    func loadMore() {
        presenter.loadMoreFeeds()
    }
    
    func refresh() {
        isRefreshing = true
        presenter.refreshFeeds()
    }
    
    func didRefreshFeeds() {
        shouldDisplayEmptyView = false
        shouldDisplayIndicatorView = false
        isRefreshing = false
        reloadView()
    }
    
    func didLoadMoreFeeds() {
        reloadView()
    }
    
    func didFetchWithError(message: String) {
        shouldDisplayEmptyView = false
        shouldDisplayIndicatorView = false
        isRefreshing = false
        refreshControl.endRefreshing()
    }
    
    func didLikeWithError(message: String?) {
    
    }
    
    func didUnlikeWithError(message: String?) {
    
    }
}