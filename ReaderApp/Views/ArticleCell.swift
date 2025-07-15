//
//  ArticleCell.swift
//  ReaderApp
//
//  Created by  HBK on 15/07/25.
//

import UIKit

protocol MyCellDelegate: AnyObject {
    func btnTapped(cell: ArticleCell) 
}

class ArticleCell: UITableViewCell {

    @IBOutlet weak var ArticleImage: UIImageView!
    @IBOutlet weak var Articletitle: UILabel!
    @IBOutlet weak var articleDescription: UILabel!
    
    @IBOutlet weak var bookmarkButton: UIButton!
    
    weak var delegate: MyCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCellData(_ article: Articles) {
        self.Articletitle.text = article.author
        self.articleDescription.text = article.title
        if let url = URL(string: article.profileImageUrl ?? "") {
            self.ArticleImage.kf.setImage(with: url)
        }
        self.bookmarkButton.setImage(article.isBookmarked ? UIImage(named: "Bookmark-Selected") : UIImage(named: "Bookmark-Unselcted"), for: .normal)
    }
    
    @IBAction func BookMarkArticle(_ sender: Any) {
        delegate?.btnTapped(cell: self)
    }
}
