import Foundation
import UIKit
import PureLayout
import Kingfisher
import Combine
import AssetsLibrary
import MapKit
import MapKit
import CoreLocation

class DetailsViewController: UIViewController, MKMapViewDelegate {
    
    private var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    private var imageHeight: CGFloat {
        0.5 * screenHeight
    }
    private var imageWidth: CGFloat {
        screenWidth - 40
    }
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var imageView: UIImageView!
    private var shadowView: UIView!
    private let cornerRadiusSize: CGFloat = 10
    
    private var map: MKMapView!
    
    private var router: RouterProtocol!
    private var disposeables = Set<AnyCancellable>()
    private var detailsViewModel: DetailsViewModel!
    
    private var nameLabel: UILabel!
    private var descriptionTextView: UILabel!
    private var locationLabel: UILabel!
    
    private let arena  = CLLocationCoordinate2D(latitude: 45.771195,  longitude: 15.939294)
    private let city  = CLLocationCoordinate2D(latitude: 45.798503,  longitude: 15.886054)
    private let avenue  = CLLocationCoordinate2D(latitude: 45.777281,   longitude: 15.979214)
    
    private var plushieId: Int!
    private var plushie: Plushie!
    
    init(router: RouterProtocol, detailsViewModel: DetailsViewModel) {
        self.detailsViewModel = detailsViewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSize(width: screenWidth, height: 2000)
    }
    
    override func viewDidLoad() {
        loadData()
        buildViews()
    }
    
    private func loadData() {
        plushieId = detailsViewModel.id
        plushie = Database().getPlushie(id: plushieId)
    }
    
    private func buildViews() {
        createViews()
        styleViews()
        defineLayoutForViews()
        map.delegate = self
        for location in plushie.storeLocations {
            addMapPin(coordinate: location.coordinates, storeName: location.name)
        }
        
    }
    
    private func createViews(){
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        
        contentView = UIView()
        scrollView.addSubview(contentView)
        
        shadowView = UIView(frame: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight))
        
        imageView  = UIImageView(frame: shadowView.bounds)
        shadowView.addSubview(imageView)
        contentView.addSubview(shadowView)
        
        map = MKMapView()
        contentView.addSubview(map)
        nameLabel = UILabel()
        contentView.addSubview(nameLabel)
        
        descriptionTextView = UILabel()
        contentView.addSubview(descriptionTextView)
        
        locationLabel = UILabel()
        contentView.addSubview(locationLabel)
    }
    
    private func styleViews(){
        view.backgroundColor = Colors.backgroundColor
        scrollView.backgroundColor = Colors.backgroundColor
        
        shadowView.clipsToBounds = false
        shadowView.contentMode = .scaleAspectFill
        shadowView.layer.shadowColor = Colors.shadowColor.cgColor
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowOffset = CGSize.zero
        shadowView.layer.shadowRadius = 10
//        shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 10).cgPath
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = cornerRadiusSize
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: plushie.imageName)
        
        map.setRegion(MKCoordinateRegion(center: arena, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)), animated: false)
        
        nameLabel.text = plushie.name
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont(name: "Helvetica-Bold", size: 20)
        nameLabel.textColor = Colors.shadowColor
        
        descriptionTextView.text = "Handmade using antiallergenic acrylic yarn and polyfil. Not appropriate for children under 2 years!"
        descriptionTextView.font = UIFont(name: "Helvetica", size: 14)
        descriptionTextView.textAlignment = .center
        descriptionTextView.textColor = Colors.shadowColor
        descriptionTextView.lineBreakMode = .byWordWrapping
        descriptionTextView.numberOfLines = 0
        
        locationLabel.text = "Store availability"
        locationLabel.textAlignment = .center
        locationLabel.font = UIFont(name: "Helvetica", size: 12)
        locationLabel.textColor = .black
    }
    
    private func defineLayoutForViews(){
//        scrollView.autoPinEdgesToSuperviewSafeArea()
        scrollView.autoPinEdgesToSuperviewEdges()
        contentView.autoMatch(.width, to: .width, of: scrollView)
        contentView.autoPinEdge(.top, to: .top, of: scrollView)
        contentView.autoPinEdge(.bottom, to: .bottom, of: scrollView)
        contentView.autoSetDimension(.height, toSize: screenHeight)
        
        shadowView.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
        shadowView.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        shadowView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        shadowView.autoSetDimension(.height, toSize: imageHeight)

        imageView.autoPinEdgesToSuperviewEdges()
        
        nameLabel.autoPinEdge(.top, to: .bottom, of: shadowView, withOffset: 10)
        nameLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        nameLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        nameLabel.autoSetDimension(.height, toSize: 20)
        
        descriptionTextView.autoPinEdge(.top, to: .bottom, of: nameLabel, withOffset: 10)
        descriptionTextView.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        descriptionTextView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        descriptionTextView.autoSetDimension(.height, toSize: 40)
        
        map.autoPinEdge(.top, to: .bottom, of: descriptionTextView, withOffset: 10)
        map.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        map.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        map.autoSetDimension(.height, toSize: 200)
        
        locationLabel.autoPinEdge(.top, to: .bottom, of: map, withOffset: 8)
        locationLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        locationLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
    }
    
    private func addMapPin(coordinate: CLLocationCoordinate2D , storeName: String) {
        let pin = MKPointAnnotation()
        pin.title = storeName
        pin.subtitle = "Item available at this store"
        pin.coordinate = coordinate
        map.addAnnotation(pin)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        var annotationView = map.dequeueReusableAnnotationView(withIdentifier: "custom")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            annotationView?.canShowCallout = true
//            annotationView?.rightCalloutAccessoryView
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(systemName: "mappin.square.fill")?.withTintColor(Colors.mapPinColor)
        return annotationView
    }
}
