//
//  EventManagerSlideUpViewController.swift
//  GroupUp
//
//  Created by Samuel Hecht (student LM) on 2/22/20.
//  Copyright © 2020 Samuel Hecht (student LM). All rights reserved.
//

import UIKit
import FirebaseAuth
class EventManagerSlideUpViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource{
    
    
    var event: Event?
    let timeAndDistanceLabel = UILabel()
    let fullView : CGFloat = 88
    let joinButton = UIButton(type: .system)
    var eventMembers = [NSAttributedString]()
    let dateLabel = UILabel()
    let activityLabel = UILabel()
    let joinedTableView = UITableView(frame: CGRect(x: 50, y: 70, width: 100, height: 100), style: .plain)
    var partialView : CGFloat {
        return UIScreen.main.bounds.height-300
    }
    var collapsedView : CGFloat {
        return UIScreen.main.bounds.height-90
    }
    let attendeeLabel = UILabel()
    let permissionsLabel = UILabel()
    let eventInformationLabel = UILabel()
    let nothingLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNothingLabel()
        setUpPanGesture()
        setUpAttendeeLabel()
        setUpJoinedTableView()
        setUpDateLabel()
        
        setUpJoinButton()
        setUpEventInformationLabel()
        setUpPermissionLabel()
        setUpTimeAndDistanceLabel()
        setUpActivityLabel()
    }
    func setUpNothingLabel(){
        
        nothingLabel.text = "There's nothing here\nright now...\n \nSelect an event\nfor more information!"
        nothingLabel.textAlignment = .center
        nothingLabel.textColor = UIColor(red: 208/255.0, green: 222/255.0, blue: 39/255.0, alpha: 1.0)
        nothingLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 32)
        nothingLabel.isHidden = false
        nothingLabel.numberOfLines = 5
        
        view.addSubview(nothingLabel)
        nothingLabel.translatesAutoresizingMaskIntoConstraints = false
        nothingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        nothingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        nothingLabel.widthAnchor.constraint(equalToConstant: view.frame.width-80).isActive = true
        nothingLabel.heightAnchor.constraint(equalToConstant: 240).isActive = true
    }
    func setUpEventInformationLabel(){
        let infoText = NSAttributedString(string: "     Event Info", attributes: [NSAttributedString.Key.underlineStyle : 1, NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 28)!, NSAttributedString.Key.foregroundColor : UIColor.white])
        eventInformationLabel.attributedText = infoText
        eventInformationLabel.isHidden = true
        
        
        view.addSubview(eventInformationLabel)
        eventInformationLabel.translatesAutoresizingMaskIntoConstraints = false
        eventInformationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 110).isActive = true
        eventInformationLabel.topAnchor.constraint(equalTo: joinButton.bottomAnchor, constant: -40).isActive = true
        eventInformationLabel.widthAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
        eventInformationLabel.heightAnchor.constraint(equalToConstant: 140).isActive = true
    }
    func setUpActivityLabel(){
        
        activityLabel.text = ""
        activityLabel.textAlignment = .center
        activityLabel.textColor = .white
        activityLabel.font = UIFont(name: "HelveticaNeue", size: 26)
        activityLabel.isHidden = true
        activityLabel.numberOfLines = 3
        
        view.addSubview(activityLabel)
        activityLabel.translatesAutoresizingMaskIntoConstraints = false
        activityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 110).isActive = true
        activityLabel.topAnchor.constraint(equalTo: timeAndDistanceLabel.bottomAnchor, constant: -20).isActive = true
        activityLabel.widthAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
        activityLabel.heightAnchor.constraint(equalToConstant: 140).isActive = true
    }
    func setUpPermissionLabel(){
        permissionsLabel.text = ""
        permissionsLabel.textAlignment = .center
        permissionsLabel.textColor = .white
        permissionsLabel.font = UIFont(name: "Helvetica Neue", size: 26)
        permissionsLabel.isHidden = true
        permissionsLabel.numberOfLines = 4
        
        view.addSubview(permissionsLabel)
        permissionsLabel.translatesAutoresizingMaskIntoConstraints = false
        permissionsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 110).isActive = true
        permissionsLabel.topAnchor.constraint(equalTo: eventInformationLabel.bottomAnchor, constant: -35).isActive = true
        permissionsLabel.widthAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
        permissionsLabel.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setUpAttendeeLabel(){
        attendeeLabel.text = "Attendees"
        attendeeLabel.textAlignment = .center
        attendeeLabel.textColor = .white
        attendeeLabel.font = UIFont(name: "Helvetica Neue", size: 26)
        attendeeLabel.isHidden = true
        
        view.addSubview(attendeeLabel)
        attendeeLabel.translatesAutoresizingMaskIntoConstraints = false
        attendeeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -85).isActive = true
        attendeeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 83).isActive = true
        attendeeLabel.widthAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
        attendeeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 2
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 1)
        let view = UIView(frame: frame)
        view.backgroundColor = .clear
        return view
        
    }
    
    
    func setUpJoinedTableView(){
        joinedTableView.delegate = self
        joinedTableView.dataSource = self
        joinedTableView.allowsSelection = false
        joinedTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        joinedTableView.backgroundColor = .clear
        joinedTableView.separatorColor =  .clear
        
        view.addSubview(joinedTableView)
        
        joinedTableView.translatesAutoresizingMaskIntoConstraints = false
        
        joinedTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -85).isActive = true
        joinedTableView.topAnchor.constraint(equalTo: attendeeLabel.bottomAnchor, constant: 5).isActive = true
        joinedTableView.widthAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
        joinedTableView.heightAnchor.constraint(equalToConstant: view.frame.height-20).isActive = true
        
        joinedTableView.isScrollEnabled = false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("Event members count is \(eventMembers.count)")
        return eventMembers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("There's 1 row man")
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = joinedTableView.dequeueReusableCell(withIdentifier: "cellID") else {return UITableViewCell()}
        print("Hello moto")
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.systemGray3.cgColor
        cell.layer.borderWidth = 3
        cell.textLabel?.attributedText = eventMembers[indexPath.section]
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.backgroundColor = .systemGray3
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func setUpJoinButton(){
        joinButton.setTitle("Join Event", for: .normal)
        joinButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
        
        joinButton.addTarget(self, action: #selector(joinEvent), for: .touchUpInside)
        
        joinButton.backgroundColor = .systemGray3
        joinButton.layer.cornerRadius = 10
        joinButton.layer.borderWidth = 3
        joinButton.layer.borderColor = UIColor.systemGray3.cgColor
        joinButton.isHidden = true
        joinButton.isEnabled = false
        
        view.addSubview(joinButton)
        
        joinButton.translatesAutoresizingMaskIntoConstraints = false
        joinButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -303).isActive = true
        joinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 110).isActive = true
        joinButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        joinButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    func setUpPanGesture(){
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(EventManagerSlideUpViewController.panGesture))
        view.addGestureRecognizer(gesture)
    }
    
    func setUpTimeAndDistanceLabel(){
        
        view.addSubview(timeAndDistanceLabel)
        
        timeAndDistanceLabel.translatesAutoresizingMaskIntoConstraints = false
        timeAndDistanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 110).isActive = true
        timeAndDistanceLabel.topAnchor.constraint(equalTo: permissionsLabel.bottomAnchor, constant: -15).isActive = true
        timeAndDistanceLabel.widthAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
        timeAndDistanceLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        timeAndDistanceLabel.numberOfLines = 4
        timeAndDistanceLabel.textAlignment = .center
        timeAndDistanceLabel.textColor = strokeColor
        timeAndDistanceLabel.font = UIFont(name: "Helvetica Neue", size: 30)
        timeAndDistanceLabel.isHidden = true
    }
    func setUpDateLabel(){
        dateLabel.isHidden = true
        view.addSubview(dateLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: view.frame.width-20).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        dateLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        
        dateLabel.numberOfLines = 2
        dateLabel.backgroundColor = .systemGray5
        dateLabel.textAlignment = .center
        dateLabel.textColor = strokeColor
        dateLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        //dateLabel.adjustsFontSizeToFitWidth = true
        
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3) {
            let frame = self.view.frame
            let yComponent = UIScreen.main.bounds.height-80
            self.view.frame = CGRect(x: 0, y: yComponent, width: frame.width, height: frame.height)
            
        }
    }
    
    func popUpViewToBottom(){
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.allowUserInteraction], animations: {
            self.view.frame = CGRect(x: 0, y: self.collapsedView, width: self.view.frame.width, height: self.view.frame.height)
            self.joinedTableView.isScrollEnabled = false
        })
    }
    func popUpViewToMiddle(){
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.allowUserInteraction], animations: {
            self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
        })
        
    }
    
    
    func updateTimeAndDistanceLabel(_ text : String){
        //timeAndDistanceLabel.text = text
        let distanceText = NSMutableAttributedString()
        distanceText.append(NSAttributedString(string: "How far    away is it?\n", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 32)!]))
        distanceText.append(NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor : strokeColor, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 28)!]))
        timeAndDistanceLabel.attributedText = distanceText
    }
    func updateEventSelected(_ event: Event){
        self.event = event
        guard let uid = Auth.auth().currentUser?.uid else {return}
        if !event.joined.contains(uid){
            joinButton.setTitle("Join Event", for: .normal)
            joinButton.isEnabled = true
        }
        else{
            joinButton.setTitle("You Joined", for: .normal)
            joinButton.isEnabled = false
        }
        eventMembers = []
        populateJoinedTableView(event: event)
        nothingLabel.isHidden = true
        joinButton.isHidden = false
        dateLabel.isHidden = false
        attendeeLabel.isHidden = false
        permissionsLabel.isHidden = false
        eventInformationLabel.isHidden = false
        activityLabel.isHidden = false
        timeAndDistanceLabel.isHidden = false
        dateLabel.textColor = strokeColor
        dateLabel.text = dateFormatter.string(from: event.time)
        let permissionsText = NSMutableAttributedString()
        permissionsText.append(NSAttributedString(string: "Who can see this event?   \n", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 28)!]))
        if event.permission == "Friends"{
            permissionsText.append(NSAttributedString(string: "Creator's friends", attributes: [NSAttributedString.Key.foregroundColor : strokeColor, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 22)!]))
            permissionsLabel.attributedText = permissionsText
        }
        else{
            
            permissionsText.append(NSAttributedString(string: "Anyone", attributes: [NSAttributedString.Key.foregroundColor : strokeColor, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 28)!]))
            permissionsLabel.attributedText = permissionsText
        }
        let activityText = NSMutableAttributedString()
        activityText.append(NSAttributedString(string: "What type of\n event is it?\n", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 28)!]))
        
        activityText.append(NSAttributedString(string: event.activity, attributes: [NSAttributedString.Key.foregroundColor : strokeColor, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 28)!]))
        activityLabel.attributedText = activityText
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareBackgroundView()
    }
    func unpopulate(){
        eventMembers = []
        nothingLabel.isHidden = false
        attendeeLabel.isHidden = true
        dateLabel.isHidden = true
        joinButton.isHidden = true
        permissionsLabel.isHidden = true
        eventInformationLabel.isHidden = true
        activityLabel.isHidden = true
        timeAndDistanceLabel.isHidden = true
        joinedTableView.reloadData()
    }
    func populateJoinedTableView(event: Event){
        for i in 0..<event.joined.count{
            print("ITS POPULATING THE TABLE VIEW AHGHG")
            
            guard let username = UIDToUsername[event.joined[i]] else {
                print("Rippp")
                return
            }
            guard let formattedProfile = usernameToFormattedProfile[username] else {
                print("Username is: \(username)")
                print("Rippp pt 2")
                
                return}
            
            guard let copyOfProfile = formattedProfile.mutableCopy() as? NSMutableAttributedString else{
                print("Noperes")
                return
            }
            copyOfProfile.setAttributes([NSAttributedString.Key.foregroundColor : strokeColor, NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 24)!], range: NSRange(1..<formattedProfile.string.count))
            self.eventMembers.append(copyOfProfile)
        }
        joinedTableView.reloadData()
    }
    
    
    @objc func joinEvent(){
        print("something's got a hold on me")
        guard let event = event else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        event.joined.append(uid)
        //Updates it in the event tree
        databaseRef.child("events/\(event.identifier)").updateChildValues(["joined": event.joined])
        //Updates it in the owner's tree
        databaseRef.child("users/\(uid)/joined").observeSingleEvent(of: .value) { (snapshot) in
            print("Ok joining is a thing without the thing")
            guard var joined = snapshot.value as? [String] else {
                databaseRef.child("users/\(uid)").updateChildValues(["joined": [event.identifier]])
                return}
            joined.append(event.identifier)
            databaseRef.child("users/\(uid)").updateChildValues(["joined": joined])
            
        }
        updateEventSelected(event)
    }
    
    
    @objc func panGesture(recognizer : UIPanGestureRecognizer){
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        
        let y = self.view.frame.minY
        //Value of where the final y position will be
        let finalYPosition = translation.y + y
        //print("Translations is: \(translation.y) and the frame's is \(view.frame.minY)")
        
        
        //Checks to make sure that final position is in between fullView and partialView
        
        if finalYPosition >= fullView && finalYPosition <= collapsedView{
            //If so, changes the view with the gesture
            view.frame = CGRect(x: 0, y: finalYPosition, width: view.frame.width, height: view.frame.height)
            //Resets the translation to zero so it stops doing the translation
            recognizer.setTranslation(CGPoint.zero, in: view)
        }
        
        
        
        //If the user stopped swiping, resets the view to either fully up or partially up
        if recognizer.state == .ended {
            //Sets the duration of the animation
            // v = d/t so t = d/v and that's what this equation is
            var duration : Double
            if finalYPosition <= partialView{
                duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            }
            else{
                duration =  velocity.y < 0 ? Double((y - partialView) / -velocity.y) : Double((collapsedView - y) / velocity.y )
            }
            
            //If the duration > 2, make it 1, otherwise leave it
            duration = duration > 2.0 ? 1 : duration
            
            
            //Animate the view going back to either full view or partial view
            //Duration is duration set above
            //No delay
            //Options allows the user to interact with the animations while they take place
            //Therefore, the user can change the screen size while it resets
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                //Animations:
                //First 2 if statements are if view is between full and partial
                //Second 2 if statements are if view is between partial and collapsed
                
                
                //Swipe was up and its between partial and full
                //So set the view to the full view
                if velocity.y < 0 && finalYPosition <= self.partialView || finalYPosition <= self.fullView {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                    self.joinedTableView.isScrollEnabled = self.joinedTableView.cellForRow(at: IndexPath(row: 0, section: 0)) != nil
                }
                    //If the gesture left a positive velocity, then it was a swipe down
                    //It is between the full view and the partial view
                    //Therefore, set the view to the partial view
                else if  velocity.y >= 0 && finalYPosition <= self.partialView {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                    self.joinedTableView.isScrollEnabled = false
                    
                }
                    //Swipe was down and its between partial and collapsed
                    //So set the view to the collapsed view
                else if velocity.y >= 0 || finalYPosition >= self.collapsedView{
                    self.view.frame = CGRect(x: 0, y: self.collapsedView, width: self.view.frame.width, height: self.view.frame.height)
                    self.joinedTableView.isScrollEnabled = false
                }
                    //Swipe was up and its between collapsed and partial
                    //So set the view to the partial view
                else{
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                    self.joinedTableView.isScrollEnabled = false
                }
                
            })
            //            A completion handler that would enable scrolling on a possible tableview
            //            Once the animation is complete, can also be used for whatever view used
            //                , completion: { [weak self] _ in
            //                    if ( velocity.y < 0 ) {
            //                        self?.joinedTableView.isScrollEnabled = true
            //                    }
            //            })
        }
        
        
    }
    
    
    func prepareBackgroundView(){
        view.backgroundColor = .systemGray5
        
        
        //overrideUserInterfaceStyle = .dark
        setUpBarline()
        
        //        let blurEffect = UIBlurEffect.init(style: .prominent)
        //        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        //        let blurredView = UIVisualEffectView.init(effect: blurEffect)
        //        blurredView.contentView.addSubview(visualEffect)
        //
        //        visualEffect.frame = UIScreen.main.bounds
        //        blurredView.frame = UIScreen.main.bounds
        //
        //        view.insertSubview(blurredView, at: 0)
    }
    
    func setUpBarline(){
        
        let barline = UIImageView()
        view.addSubview(barline)
        let centerXAnchor = view.centerXAnchor
        let topAnchor = view.topAnchor
        barline.image = #imageLiteral(resourceName: "Barline")
        barline.translatesAutoresizingMaskIntoConstraints = false
        barline.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        barline.widthAnchor.constraint(equalToConstant: 38).isActive = true
        barline.heightAnchor.constraint(equalToConstant: 11).isActive = true
        barline.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
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
