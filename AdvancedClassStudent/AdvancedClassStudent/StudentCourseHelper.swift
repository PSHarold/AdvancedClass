

class StudentCourseHelper{
    static var _defaultHelper: StudentCourseHelper?
    static var defaultHelper: StudentCourseHelper!{
        get{
            if StudentCourseHelper._defaultHelper == nil{
                StudentCourseHelper._defaultHelper = StudentCourseHelper()
            }
            return StudentCourseHelper._defaultHelper
        }
    }
    
    func getNotifications(page: Int, course: StudentCourse?=nil, completionHandler: ResponseMessageHandler){
        assert(page >= 1)
        let course = course ?? StudentCourse.currentCourse!
        StudentAuthenticationHelper.defaultHelper.getResponsePOSTWithCourse(RequestType.GET_NOTIFICAIONS, parameters: ["page": 1], course: course){
            (error, json) in
            if error == nil{
                course.notifications = [Notification]()
                for (_, n) in json["notifications"]{
                    let notification = Notification(json: n)
                    notification.courseName = course.name
                    course.notifications.append(notification)
                }
            }
            completionHandler(error: error)
        }
        
    }
    
    
    
    func getSyllabus(course: StudentCourse, completionHandler: ResponseMessageHandler){
        if course.syllabus != nil{
            completionHandler(error: nil)
            return
        }
        else{
            StudentAuthenticationHelper.defaultHelper.getResponsePOST(RequestType.GET_SYLLABUS, parameters: ["course_id": course.courseId, "sub_id": course.subId]){
                (error, json) in
                if error == nil{
                    course.syllabus = Syllabus(json: json)
                }
                completionHandler(error: error)
            }
        }
    }
    
    
    func getStudentsInCourse(course: StudentCourse, completionHandler: ResponseMessageHandler){
        let authHelper = StudentAuthenticationHelper.defaultHelper
        authHelper.getResponsePOST(RequestType.GET_STUDENTS_IN_COURES, parameters: ["course_id": course.courseId, "sub_id": course.subId]){
            (error, json) in
            if error == nil{
                for (_, student_json) in json["students"]{
                    let s = Student(json: student_json)
                    course.students[s.studentId] = s
                }
            }
            completionHandler(error: error)
        }
        
    }
    func getCourseDetails(course: StudentCourse, completionHandler: ResponseMessageHandler){
        self.getSyllabus(StudentCourse.currentCourse){
            [unowned self]
            error in
            if error == nil{
                self.getStudentsInCourse(course){
                    error in
                    completionHandler(error: error)
                }
            }
        }
        
    }
    
    
    func getStudent(studentId: String, course: StudentCourse, completionHandler: ResponseMessageHandler){
        if course.students[studentId] != nil{
            completionHandler(error: nil)
            return
        }
        let authHelper = StudentAuthenticationHelper.defaultHelper
        authHelper.getResponsePOST(RequestType.GET_STUDENT, parameters: ["course_id": course.courseId, "sub_id": course.subId, "student_id": studentId]){
            (error, json) in
            if error == nil{
                let student = Student(json: json["student"])
                course.students[student.studentId] = student
            }
            completionHandler(error: error)
        }
    }
    static func drop(){
        _defaultHelper = nil
    }
    
    
    func getAsksForLeave(course: StudentCourse?=nil, completionHandler: ResponseMessageHandler) {
        let auth = StudentAuthenticationHelper.defaultHelper
        let course = course ?? StudentCourse.currentCourse!
        auth.getResponsePOSTWithCourse(RequestType.GET_ASKS_FOR_LEAVE, parameters: [:]){
            error, json in
            course.asks = []
            if error == nil{
                for ask_dict in json["pending_asks"].arrayValue{
                    let ask = AskForLeave(json: ask_dict)
                    course.asks.append(ask)
                }
                for ask_dict in json["approved_asks"].arrayValue{
                    let ask = AskForLeave(json: ask_dict)
                    course.asks.append(ask)
                }
                for ask_dict in json["disapproved_asks"].arrayValue{
                    let ask = AskForLeave(json: ask_dict)
                    course.asks.append(ask)
                }
            }
            completionHandler(error: error)
            
        }
    }
    
    func askForLeave(ask: AskForLeave, course: StudentCourse?=nil, completionHandler: ResponseMessageHandler){
        let auth = StudentAuthenticationHelper.defaultHelper
        var dict = ask.toDict()
        let course = course ?? StudentCourse.currentCourse!
        dict["course_id"] = course.courseId
        auth.getResponsePOSTWithCourse(RequestType.ASK_FOR_LEAVE, parameters: dict){
            error, json in
            if error == nil{
                ask.askId = json["ask_id"].stringValue
                ask.status = AskForLeaveStatus.PENDING
                ask.createdAt = json["created_at"].stringValue
                ask.viewdAt = ""
                course.asks.insert(ask, atIndex: 0)
            }
            completionHandler(error: error)
        }
    }
    func deleteAskForLeave(ask: AskForLeave, course: StudentCourse?=nil, completionHandler: ResponseMessageHandler){
        let auth = StudentAuthenticationHelper.defaultHelper
        let course = course ?? StudentCourse.currentCourse!
        auth.getResponsePOSTWithCourse(RequestType.DELETE_ASK_FOR_LEAVE, parameters: ["ask_id": ask.askId]){
            error, json in
            if error == nil{
                course.asks.removeAtIndex(course.asks.indexOf({$0 === ask})!)
            }
            completionHandler(error: error)
        }
    }
    
    
    func getAbsenceList(course: StudentCourse?=nil, completionHandler: ResponseMessageHandler){
        let auth = StudentAuthenticationHelper.defaultHelper
        let course = course ?? StudentCourse.currentCourse!
        auth.getResponsePOSTWithCourse(RequestType.GET_MY_ABSENCE_LIST, parameters: [:]){
            error, json in
            course.absenceList = []
            if error == nil{
                for absence in json["absence"].arrayValue{
                    course.absenceList.append(absence.rawValue as! [String: Int])
                }
            }
            completionHandler(error: error)
        }
    }
    
}