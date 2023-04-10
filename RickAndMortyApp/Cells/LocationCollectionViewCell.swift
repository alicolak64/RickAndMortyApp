import UIKit

class LocationCollectionViewCell: UICollectionViewCell {
    static let identifier = "LocationCollectionViewCell"

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0 // birden fazla satıra bölünsün
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        // ContentView'i çerçeve gibi kullanmak için boyutunu küçültüyoruz
        contentView.frame = CGRect(x: 5, y: 5, width: frame.width - 10, height: frame.height - 10)
        contentView.addSubview(nameLabel)
        // ContentView'in çerçeve gibi görünmesi için köşelerini yuvarlıyoruz
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        // Cell'in kendisi de bir çerçeve gibi görünsün
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame = contentView.bounds
    }

    func configure(with location: Location) {
        nameLabel.text = location.name
        // Label'in boyutunu textine göre ayarlıyoruz
        let size = nameLabel.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        nameLabel.frame.size.height = size.height
    }
}
