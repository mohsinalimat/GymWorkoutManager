//
//  PlannerViewController.swift
//  GymWorkoutManager
//
//  Created by zhangyunchen on 16/5/24.
//  Copyright © 2016年 McKay. All rights reserved.
//

import UIKit
import CVCalendar

class PlannerViewController: UIViewController,CVCalendarViewDelegate,CVCalendarMenuViewDelegate {
    
    //MARK: Properties
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var setPlan: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setPlan.backgroundColor = GWMColorPurple
        setPlan.tintColor = GWMColorYellow
        
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Planner"
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }
    
    //MARK: Implemente of CAValendarViewDelegate
    func presentationMode() -> CalendarMode {
        return CalendarMode.MonthView
    }
    
    func firstWeekday() -> Weekday {
        return Weekday.Monday
    }
    
    func didSelectDayView(dayView: DayView, animationDidFinish: Bool){
        print(dayView.date.commonDescription)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "setPlan" {
            var destinationVC = segue.destinationViewController as! SetPlanViewController
           // destinationVC.date =
        }
    }
}
