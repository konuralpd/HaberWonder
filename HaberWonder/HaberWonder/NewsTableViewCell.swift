//
//  TableViewCell.swift
//  HaberWonder
//
//  Created by Mac on 4.07.2022.
//

import UIKit

class NewsTableViewCellViewModel {
    let title: String
    let subtitle: String
    let imageURL: URL?
    var imageData: Data? = nil
    
    init(title:String, subtitle: String, imageURL: URL?, imageData: Data?) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        
    }
}

class NewsTableViewCell: UITableViewCell {

  static let identifier = "NewsTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(newsImageView)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newsTitleLabel.frame = CGRect(x: 10, y: 0, width: contentView.frame.size.width-170, height: contentView.frame.size.height/2)
        
        subtitleLabel.frame = CGRect(x: 10, y: 70, width: contentView.frame.size.width-170, height: contentView.frame.size.height/2)

        newsImageView.frame = CGRect(x: contentView.frame.size.width-150, y: 5, width: 160, height: contentView.frame.size.height-10)
        newsImageView.layer.cornerRadius = 8
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with viewModel: NewsTableViewCellViewModel) {
        
        newsTitleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        
        if let data = viewModel.imageData {
            newsImageView.image = UIImage(data: data)
        } else if let url = viewModel.imageURL {
            
            URLSession.shared.dataTask(with: url)  { [weak self] data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
                
            }.resume()
            
        }
    }
    
    private let newsTitleLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
        label.textColor = UIColor(red: 19/255, green: 36/255, blue: 198/255, alpha: 1)
        return label
        
    }()
    
    private let subtitleLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 0
        return label
        
    }()
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    

}
