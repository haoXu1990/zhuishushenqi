//
//  QSSearchPresenter.swift
//  zhuishushenqi
//
//  Created Nory Cao on 2017/4/10.
//  Copyright © 2017年 QS. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class QSSearchPresenter: QSSearchPresenterProtocol {

    weak var view: QSSearchViewProtocol?
    var interactor: QSSearchInteractorProtocol
    var router: QSSearchWireframeProtocol
    
    var hotwords:[String] = [] {
        didSet{
            
        }
    }
    var history:[String] = [] {
        didSet{
            
        }
    }
    var keywords:[String] = []
    
    var books:[Book] = []

    init(interface: QSSearchViewProtocol, interactor: QSSearchInteractorProtocol, router: QSSearchWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad(){
        self.interactor.fetchHotwords()
        self.interactor.fetchSearchList()
    }
    
    func didClickClearBtn(){
        interactor.clearSearchList()
    }
    
    func didSelectHotWord(hotword:String){
        view?.showActivityView()
        interactor.updateHistoryList(history: hotword)
        interactor.fetchBooks(key: hotword)
    }
    
    func didClickChangeBtn(){
        fetchHotwordsSuccess(hotwords: interactor.subWords())
    }
    
    func didSelectResultRow(indexPath:IndexPath){
        router.presentDetails(books[indexPath.row])
    }
    
    func didSelectHistoryRow(indexPath:IndexPath){
        view?.showActivityView()
        view?.showBooks(books: [], key: history[indexPath.row])
        interactor.fetchBooks(key: history[indexPath.row])
    }
    
    func didSelectAutoCompleteRow(indexPath: IndexPath) {
        view?.showActivityView()
        view?.showBooks(books: [], key: keywords[indexPath.row])
        interactor.updateHistoryList(history: keywords[indexPath.row])
        interactor.fetchBooks(key: keywords[indexPath.row])
    }
    
    func fetchBooks(key:String){
        view?.showActivityView()
        interactor.fetchBooks(key: key)
    }
}

extension QSSearchPresenter:QSSearchInteractorOutputProtocol{

    func fetchHotwordsSuccess(hotwords:[String]){
        self.hotwords = hotwords
        view?.showHotwordsData(hotwords: hotwords)
    }
    
    func fetchHotwordsFailed(){
        
    }
    
    func fetchAutoComplete(keys: [String]) {
        self.keywords = keys
        view?.hideActivityView()
        view?.showAutoComplete(keywords: keys)
    }
    
    func searchListFetch(list:[[String]]){
        self.history = list[1]
        view?.showSearchListData(searchList: list)
    }
    
    func fetchBooksSuccess(books:[Book],key:String){
        self.books = books
        view?.hideActivityView()
        view?.showBooks(books: self.books,key:key)
    }
    
    func fetchBooksFailed(key:String) {
        self.books = []
        view?.hideActivityView()
        view?.showBooks(books: self.books,key:key)
    }

    func showResult(key: String) {
        self.books = []
        view?.showBooks(books: self.books, key: key)
    }
}