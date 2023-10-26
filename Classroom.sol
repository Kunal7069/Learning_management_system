// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract GoogleClassroom {
  
  struct Teacher{
    string name;
    string password;
  }
  struct Homework{
    string work;
    string post_date;
    string due_date;
  }
  struct Student{
    string name;
    string password;
  }
  struct Classroom{
    string classname;
    string classcode;
  }

  Teacher[] teacher;
  Student[]  student;
  Classroom[]  classroom;
  Homework[] homework;
  mapping(string=>address) public teacher_access; 
  mapping(string=>address) public student_access; 
  mapping(string=>string) public classcode; // Which class has what code...
  mapping(string=>Classroom[]) public classroomlist; // List of classrooms teachers wise
  mapping(string=>Student[]) public classlist; // List of students in each class
  mapping(string=>mapping(string=>Homework[])) public home_work; // List of homework teacher and class wise
  mapping(string=>mapping(string=>mapping(string=>bool))) public check; // To check whether student submitted the work or not 
  
  function teacher_signup(string memory _name,string memory _password) public payable {
    teacher.push(Teacher({name: _name,password: _password}));
    teacher_access[_name]=msg.sender;
  }
  
  function student_signup(string memory _name,string memory _password) public payable {
    student.push(Student({name: _name,password: _password}));
    student_access[_name]=msg.sender;
  }
  
  // Teacher create classroom
  function create_classroom(string memory _name,string memory _classname,string memory _classcode) public payable {
    require(teacher_access[_name]==msg.sender,"ACCESS DENIED");
    classroomlist[_name].push(Classroom({classname:_classname,classcode:_classcode}));
    classcode[_classname]=_classcode;
  }
 
 // Add in classroom 
  function add_in_classroom(string memory class_name,string memory student_name,string memory student_password) public payable {
    // require(classcode[class_name]==class_code,"WRONG INFO");
    require(student_access[student_name]==msg.sender,"ACCESS DENIED");
    classlist[class_name].push(Student({name:student_name,password:student_password}));
  }

  // Add homework in classroom
  function add_homework(string memory teacher_name,string memory class_name,string memory _work,string memory postdate,string memory duedate) public payable {
    require(teacher_access[teacher_name]==msg.sender,"ACCESS DENIED"); 
    home_work[teacher_name][class_name].push(Homework({work:_work,post_date:postdate,due_date:duedate}));
    for(uint i=0;i<classlist[class_name].length;i++){
      check[class_name][ _work][(classlist[class_name][i]).name]=false;
    }
  }

  // View students of any class
   function view_students(string memory class_name) public payable returns(Student[] memory) {
    return classlist[class_name];
  }
}





