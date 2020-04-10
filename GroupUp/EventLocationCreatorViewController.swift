
import UIKit
import MapKit

class EventLocationCreatorViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    let mapView = MKMapView()
    var name = NSAttributedString(string: "")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        view.addSubview(mapView)
//        view.addSubview(addressTextField)
//
//        addressTextField.backgroundColor = .white
//        addressTextField.translatesAutoresizingMaskIntoConstraints = false
//        addressTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
//        addressTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
//        addressTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
//        addressTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        //mapView.showsUserLocation = true
        let region = MKCoordinateRegion(center: locationManager.location?.coordinate ?? CLLocationCoordinate2D(), span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
        mapView.setRegion(region, animated: true)
        
        mapView.delegate = self
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50).isActive = true
        mapView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: view.frame.height - 100).isActive = true
        
        let confirmButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(confirm))
        let addressTextField = UITextField()
        navigationItem.titleView = addressTextField
        navigationItem.rightBarButtonItem = confirmButton
        
        
        addressTextField.delegate = self
        addressTextField.backgroundColor = .white
        addressTextField.widthAnchor.constraint(equalToConstant: 295).isActive = true
        addressTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        addressTextField.textColor = .black
        addressTextField.text = nil
        addressTextField.attributedPlaceholder = NSAttributedString(string: "Enter Address or Tap Location on Map", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray2])
        addressTextField.returnKeyType = .go
        addressTextField.autocorrectionType = .no
        //addressTextField.placeholder = "Enter Address or Click on Map"
        addressTextField.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mapWasTapped(gestureRecognizer:)))
        mapView.addGestureRecognizer(tapGestureRecognizer)
        print("never again")
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        mapView.removeAnnotations(mapView.annotations)
        let geocoder = CLGeocoder()
        guard let address = textField.text else {return false}
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if error == nil {
            guard let placemarks = placemarks, let placemark = placemarks.first, let location = placemark.location, let name = placemark.name else {return}
            self.name = NSAttributedString(string: name)
            self.addAnnotation(location.coordinate)
            let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
            self.mapView.setRegion(region, animated: true)
            }
            else{
                textField.text = ""
                textField.attributedPlaceholder = NSAttributedString(string: "Invalid Address, Please Try Again", attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
        }
        return true
    }
    func addAnnotation(_ location : CLLocationCoordinate2D){
        let event = Event(coordinate: location)
        mapView.addAnnotation(event)
        navigationItem.rightBarButtonItem?.isEnabled = true

    }
    @objc func confirm(){
       guard let VCs = navigationController?.viewControllers else {return}
        guard let eventCreator = VCs[VCs.count-2] as? EventCreator else {return}
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "map")
        let imageOffsetY: CGFloat = -5.0
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: 25, height: 25)
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let completeName = NSMutableAttributedString(string: "")
        completeName.append(attachmentString)
        let location = NSAttributedString(string: " Location: ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)])
        completeName.append(location)
        completeName.append(name)
        eventCreator.locationString = completeName
        eventCreator.reloadData = true
        navigationController?.popViewController(animated: true)
    }
    @objc func mapWasTapped(gestureRecognizer: UIGestureRecognizer){
        mapView.removeAnnotations(mapView.annotations)
        let touchPoint = gestureRecognizer.location(in: mapView)
        location = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let coordinate = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(coordinate) { (placemarks, error) in
            if error == nil {
            guard let placemarks = placemarks, let placemark = placemarks.first, let name = placemark.name else {return}
                self.name = NSAttributedString(string: name)
            
            }
            else{
                print("Bruh how")
            }
        }
        addAnnotation(location)
        navigationItem.rightBarButtonItem?.isEnabled = true
       
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
