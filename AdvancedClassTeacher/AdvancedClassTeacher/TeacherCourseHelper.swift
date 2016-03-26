

class TeacherCourseHelper{
    static var _defaultHelper: TeacherCourseHelper?
    static var defaultHelper: TeacherCourseHelper!{
        get{
            if TeacherCourseHelper._defaultHelper == nil{
                TeacherCourseHelper._defaultHelper = TeacherCourseHelper()
            }
            return TeacherCourseHelper._defaultHelper
        }
    }
    
    func getNotifications(course: TeacherCourse, page: Int, completionHandler: (error: CError?) -> Void){
        assert(page >= 1)
       
            TeacherAuthenticationHelper.defaultHelper.getResponsePOST(RequestType.GET_NOTIFICAIONS, postBody: ["course_id":course.courseId,"sub_id":course.subId, "page": page]){
                (error, json) in
                if error == nil{
                    if page == 1{
                        course.notifications = [Notification]()
                    }
                    for (_, n) in json["notifications"]{
                        let notification = Notification(json: n)
                        notification.courseName = course.name
                        course.notifications.append(notification)
                    }
                }
                completionHandler(error: error)
            }
        
    }
    
    
    
    func getSyllabus(course: TeacherCourse, completionHandler: (error: CError?) -> Void){
        if course.syllabus != nil{
            completionHandler(error: nil)
            return
        }
        else{
            TeacherAuthenticationHelper.defaultHelper.getResponsePOST(RequestType.GET_SYLLABUS, postBody: ["course_id": course.courseId, "sub_id": course.subId]){
                (error, json) in
                if error == nil{
                    course.syllabus = Syllabus(json: json)
                }
                completionHandler(error: error)
            }
        }
    }
    
    
//    func getStudentIdsInCourse(course: TeacherCourse, completionHandler: ResponseMessageHandler){
//        let authHelper = TeacherAuthenticationHelper.defaultHelper
//        authHelper.getResponsePOST(RequestType.GET_STUDENTS_IN_COURES, postBody: ["course_id": course.courseId, "sub_id": course.subId]){
//            (error, json) in
//            if error == nil{
//                for (_, studentId) in json["students"]{
//                    course.studentIds.append(studentId.stringValue)
//                }
//            }
//            completionHandler(error: error)
//        }
//    }
//    
    func getStudentsInCourse(course: TeacherCourse, completionHandler: ResponseMessageHandler){
        let authHelper = TeacherAuthenticationHelper.defaultHelper
        authHelper.getResponsePOST(RequestType.GET_STUDENTS_IN_COURES, postBody: ["course_id": course.courseId, "sub_id": course.subId]){
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
    func getCourseDetails(course: TeacherCourse, completionHandler: ResponseMessageHandler){
        self.getSyllabus(TeacherCourse.currentCourse){
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
    
    func modifyNotificationInCourse(course: TeacherCourse, notification: Notification, completionHandler: ResponseMessageHandler){
        let authHelper = TeacherAuthenticationHelper.defaultHelper
        var a = notification.toDict()
        a["course_id"] = course.courseId
        a["sub_id"] = course.subId
        
        authHelper.getResponsePOST(RequestType.MODIFY_NOTIFICATION, postBody: a){
            (error, json) in
            completionHandler(error: error)
        }
    }
    
    func postNotificationInCourse(course: TeacherCourse, notification: Notification, completionHandler: ResponseMessageHandler){
        let authHelper = TeacherAuthenticationHelper.defaultHelper
        var a = notification.toDict()
        a["course_id"] = course.courseId
        a["sub_id"] = course.subId
        authHelper.getResponsePOST(RequestType.POST_NOTIFICATION, postBody: a){
            (error, json) in
            if error == nil{
                notification.notificationId = json["ntfc_id"].stringValue
                course.notifications.insert(notification, atIndex: 0)
            }
            completionHandler(error: error)
        }
    }
    
    func deleteNotificationInCourse(course: TeacherCourse, notification: Notification, completionHandler: ResponseMessageHandler){
        let authHelper = TeacherAuthenticationHelper.defaultHelper
        authHelper.getResponsePOST(RequestType.DELETE_NOTIFICATION, postBody: ["course_id": course.courseId, "sub_id": course.subId, "ntfc_id": notification.notificationId]){
            (error, json) in
            completionHandler(error: error)
        }

    }
    
    
    
    func getStudent(studentId: String, course: TeacherCourse, completionHandler: ResponseMessageHandler){
        if course.students[studentId] != nil{
            completionHandler(error: nil)
            return
        }
        let authHelper = TeacherAuthenticationHelper.defaultHelper
        authHelper.getResponsePOST(RequestType.GET_STUDENT, postBody: ["course_id": course.courseId, "sub_id": course.subId, "student_id": studentId]){
            (error, json) in
            if error == nil{
                let student = Student(json: json["student"])
                course.students[student.studentId] = student
            }
            completionHandler(error: error)
        }
    }
    
    
}