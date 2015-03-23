//
//  EventsViewController.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 11/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController {

    weak var aView: EventsListView?
    var viewModel: ListViewModel<Event>?
    
    let sortingKey = "shortDate"
    let reuseIdentifier = "EventCellIdentifier";
    let roomSegmentedControl = UISegmentedControl(items: ["All", "Aqua", "Middle", "Cold"])

    override func loadView() {
        aView = loadViewWithClass(EventsListView.self) as? EventsListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupRoomSegmentedControl()
        self.setupTableView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        roomSegmentedControl.selectedSegmentIndex = 1
        segmentedControlChangedState(roomSegmentedControl)
    }
    
}

// MARK: Actions

extension EventsViewController {

    func segmentedControlChangedState(sender: UISegmentedControl) {
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.startAnimating()
        self.navigationItem.titleView = indicator
        
        let index = roomSegmentedControl.selectedSegmentIndex
        NetworkManager.sharedInstance.eventsList(forCalendar: Room[index], success: { (response) -> () in
            
            let array = response?["items"].array
            if let events: [Event] = Event.map(array) {
                let sortedEvents = Event.sortedByDate(events)
                
                self.viewModel = ListViewModel<Event>(sortedEvents, sortingKey: "shortDate")
                self.aView?.tableView.setContentOffset(CGPointMake(0, -64), animated: true)
                self.aView?.tableView.reloadData()
                
            }
            
            self.navigationItem.titleView = self.roomSegmentedControl
            
        }, { (error) -> () in
                
            UIAlertView(title: "Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
            self.navigationItem.titleView = self.roomSegmentedControl
                
        })

    }
    
}


// MARK: UITableViewDelegate

extension EventsViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("\(__FUNCTION__)")
        println("go to event detail")
    }
    
}


// MARK: UITableViewDataSource

extension EventsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel?.sectionsCount() ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _section: List<Event> = viewModel?[section] {
            return _section.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let section = indexPath.section
        let row = indexPath.row
        
        var summary: String?
        
        if viewModel?.sectionsCount() > 1 {
            summary = viewModel?[section][row].summary
        } else {
            summary = viewModel?[row].summary
        }
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as UITableViewCell
        cell.textLabel?.text = summary
        return cell
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (viewModel?[section] as Section).title
    }
    
}

// MARK: Private

extension EventsViewController {
    
    private func setupRoomSegmentedControl() {
        roomSegmentedControl.addTarget(self, action: Selector("segmentedControlChangedState:"), forControlEvents: UIControlEvents.ValueChanged)
        self.navigationItem.titleView = roomSegmentedControl
    }
    
    private func setupTableView() {
        let tableView: UITableView? = aView?.tableView
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
}