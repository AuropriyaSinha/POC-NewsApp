//
//  NewsTableViewCell.swift
//  POC-NewsApp
//
//  Created by Auropriya Sinha on 20/09/22.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    static let identifier = "NewsTableViewCell"
    public var newsViewModel : NewsViewModel?
    var representedIdentifier = ""
    
    //MARK: programmatically created UI elements
    
    private let titleLabel : UILabel = {
        let title = UILabel()
        title.isAccessibilityElement = true
        title.numberOfLines = 0
        title.font = .systemFont(ofSize: 22, weight: .semibold)
        return title
    }()
    
    private let subtitleLabel : UILabel = {
        let subtitle = UILabel()
        subtitle.isAccessibilityElement = true
        subtitle.numberOfLines = 0
        subtitle.font = .systemFont(ofSize: 17, weight: .light)
        return subtitle
    }()
    
    private let newsImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.isAccessibilityElement = true
        imageView.layer.cornerRadius = 6.0
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(newsImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setting UI elements frame
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 10, y: 0, width: contentView.frame.width - 170, height: 70)
        subtitleLabel.frame = CGRect(x: 10, y: 70, width: contentView.frame.width - 170, height: contentView.frame.height/2)
        newsImageView.frame = CGRect(x: contentView.frame.size.width - 150, y: 5, width: 140, height: contentView.frame.height - 10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        newsImageView.image = nil
    }
    
    //MARK: configuring UI elements and assigning values
    func configure(with viewModel : NewsTableViewCellViewModel, publishedAt : String) {
        self.titleLabel.text = viewModel.title
        titleLabel.accessibilityHint = viewModel.title
        self.subtitleLabel.text = viewModel.subtitle
        subtitleLabel.accessibilityHint = viewModel.subtitle
        
        //image
        if let data = viewModel.imageData {
            self.newsImageView.image = UIImage(data: data)
        }
        else if let url = viewModel.imageURL {
            //fetch
            newsViewModel?.apiHandler?.getImage(url: url, completion: { data in
                DispatchQueue.main.async {
                    viewModel.imageData = data
                    self.newsImageView.image = UIImage(data: data)
                    self.newsImageView.accessibilityHint = "Picture"
                }
            })
        }
    }
}
