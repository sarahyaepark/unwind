//
//  OverTime.swift
//  unwind
//
//  Created by Sarah Park on 5/2/20.
//  Copyright © 2020 Sarah Park. All rights reserved.
//
import UIKit
import JTAppleCalendar
import Firebase
import FirebaseDatabase
import FirebaseFirestore

class OverTimeViewController: UIViewController {

    @IBOutlet weak var calendarView: JTACMonthView!
    var calendarDataSource: [String:String] = [:]
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        return formatter
    }
    
   override func viewDidLoad() {
         super.viewDidLoad()
        let gradientLayer = CAGradientLayer()
    gradientLayer.frame = self.view.bounds
    gradientLayer.colors = [UIColor(red: 0.16, green: 0.05, blue: 0.23, alpha: 1.00).cgColor, UIColor(red: 0.39, green: 0.16, blue: 0.49, alpha: 1.00).cgColor]
    self.view.layer.insertSublayer(gradientLayer, at: 0)
         calendarView.scrollDirection = .horizontal
         calendarView.scrollingMode   = .stopAtEachCalendarFrame
         calendarView.showsHorizontalScrollIndicator = false
        populateDataSource()
     }
    func getUid() -> String {
        let loggedInUser = Auth.auth().currentUser
        var uid = ""
        if let loggedInUser = loggedInUser {
        // user is signed in
            uid = loggedInUser.uid
        }
        return uid
    }
    
    func populateDataSource() {
//        let group = DispatchGroup()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        var tempCalendarDataSource:Array<String>?
        var calendarDataSource:Array<String>?
        // You can get the data from a server.
        // Then convert that data into a form that can be used by the calendar.
        let uid = getUid()
        let db = Firestore.firestore()

        let docRef = db.collection("users").document(uid)
        docRef.getDocument(source: .cache) { (document, error) in
            if let document = document {
                let datesArray:Array? = document.get("datesArray") as? Array<Date>
                if datesArray != nil {
                for date in datesArray! {
                    let tempDate = dateFormatter.string(from: date)
                    tempCalendarDataSource?.append(tempDate)
                    let nightlyRef = db.collection("users").document(uid).collection(tempDate).document("nightlyRitual")
                    nightlyRef.getDocument(source: .cache) { (document, error) in
                        if let document = document {
                            let happy = document.get("happy") as? Bool
                            if happy! {
                                let tempDate1 = dateFormatter.date(from: tempDate)
                                dateFormatter.dateFormat = "dd-MMMM-yyyy"
                                let tempDate = dateFormatter.string(from: tempDate1!)
                                calendarDataSource?.append(tempDate)
                            }
                        }
                    }
                }
                }
            }
        }
//        for date in tempCalendarDataSource! {
//            var nightlyRef = db.collection("users").document(uid).collection(date).document("nightlyRitual")
//            nightlyRef.getDocument(source: .cache) { (document, error) in
//            if let document = document {
//                let happy = document.get("happy") as? Bool
//                if happy! {
//                    var tempDate1 = dateFormatter.date(from: date)
//                    dateFormatter.dateFormat = "dd-MMMM-yyyy"
//                    var tempDate = dateFormatter.string(from: tempDate1!)
//                    calendarDataSource?.append(tempDate)
//                }
//
//            }
//        }
//        }
        // update the calendar
            self.calendarView.reloadData()
    }
    func configureCell(view: JTACDayCell?, cellState: CellState) {
        guard let cell = view as? DateCell  else { return }
        cell.dateLabel.text = cellState.text
        handleCellEvents(cell: cell, cellState: cellState)
    }
    
    func handleCellEvents(cell: DateCell, cellState: CellState) {
        let dateString = formatter.string(from: cellState.date)
        if calendarDataSource[dateString] == nil {
            cell.dotView.isHidden = true
        } else {
            cell.dotView.isHidden = false
        }
    }
}

 extension OverTimeViewController: JTACMonthViewDataSource {
    
     func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
         let startDate = formatter.date(from: "2020 01 01")!
         let endDate = formatter.date(from: "2021 01 01")!
         return ConfigurationParameters(startDate: startDate, endDate: endDate)
        
     }
    

 }

extension OverTimeViewController: JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        let formatter = DateFormatter()  // Declare this outside, to avoid instancing this heavy class multiple times.
        formatter.dateFormat = "MMM"
        
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! DateHeader
        header.monthTitle.text = formatter.string(from: range.start)
        return header
    }
    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }
 }

