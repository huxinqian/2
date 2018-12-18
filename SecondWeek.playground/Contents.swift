import UIKit
import Foundation

//作业一 闭包、扩展、泛型
let dict = [["name": "huhu", "age": 18], ["name": "lisa", "age": 19], ["name": "chenyu", "age": 20]]
let str = dict.map( { $0["name"]! } )  //返回字典数组中每个字典元素的"name"对应的值
print("\(str)")

let arr1 = ["2016110314", "234jwe", "this is a arrary", "123"]
let arr2 = arr1.filter( { Int($0) != nil } )  //将字符串元素强转为Int,若值为nil则表示不能转成Int
print("\(arr2)")

let arr3 = ["aaaaaaa", "this", "hello"]
var str1 = arr3.reduce("", { $0 + "," + $1 }) //将字符串数组整合
str1.remove(at: str1.startIndex)  //因为整合结果的字符串的第一个字符为","，所以需要将这个","移除
print("\(str1)")

var intArr = [20,13,23,4,5,0]
let arr = intArr.reduce((max: intArr[0], min: intArr[0], sum: 0), { (max: max($0.max, $1), min: min($0.min, $1), $0.sum + $1) })
print("\(arr)")

func f1(a: Int) -> Int {
    return a
}

func f2(a: String) -> Int {
    return Int(a)!
}

func f3() -> Int {
    return 2
}

func f4(a: Int) -> Int{
    return a + 1
}

func f5(a: Int){
}

let funArr: [Any] = [f1, f2, f3, f4, f5]
for (index, value) in funArr.enumerated() { //因为循环过程中需要设计到数组的下标，要将数组元素一一列举出来，所以需要调用数组的enumerated()方法。
    if value is (Int) -> Int {
        print(index)
    }
}

//自定义泛型函数，因为需要比较大小，所以该泛型需要遵循Comparable协议
//函数参数为可变参数
func getMaxAndMin<T: Comparable>(a: T...) -> (T, T) {
    var max = a[0]
    var min = a[0]
    for item in a {
        if item > max {
            max = item
        } else if item < min {
            min = item
        }
    }
    return (max, min) // 返回参数中的最大值和最小值
}
print(getMaxAndMin(a: 3,11,4,90,34,67))
print(getMaxAndMin(a: 3.0,2.0,99.0,23.4,12.3,42.56))
print(getMaxAndMin(a: "c1", "jj", "A", "zsf"))



//作业二：类的派生、协议
enum Gender: Int {//性别枚举
    case male
    case female
    
    static func >(p1: Gender, p2: Gender) -> Bool {//重载>
        return p1.rawValue > p2.rawValue
    }
}

//学校协议
enum Department {
    case one, two, three
}
protocol SchoolProtocol {
    var department: Department { get set }
    func lendBook()
}
class Person: CustomStringConvertible  {//定义Person类
    var firstName: String
    var lastName: String
    var age: Int
    var gender: Gender
    var fullName: String {
        return firstName + lastName
    }
    //构造方法
    init(firstName: String, lastName: String, age: Int, gender: Gender) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.gender = gender
    }
    //便利构造函数
    convenience init(firstName: String, age: Int, gender: Gender) {
        self.init(firstName: firstName, lastName: "", age: age, gender: gender)
    }
    
    convenience init(firstName: String) {
        self.init(firstName: firstName, age: 20, gender: Gender.male)
    }
    //重载==
    static func ==(p1: Person, p2: Person) -> Bool {
        return p1.fullName == p2.fullName && p1.age == p2.age && p1.gender == p2.gender
    }
    //重载!=
    static func !=(p1: Person, p2: Person) -> Bool {
        return !(p1 == p2)
    }
    func run(){
        print("Person:\(self.fullName) is running!")
    }
    //使用print直接输出对象内容
    var description: String {
        return "fullName: \(self.fullName), age: \(self.age), gender: \(self.gender)"
    }
}

let p1 = Person(firstName: "hu")
let p2 = Person(firstName: "hu", age: 18, gender: .male)
print(p1)
print(p2.description)
if(p1 == p2){
    print("same person!")
}
if(p1 != p2){
    print("Not same person!")
}

class Teacher : Person{
    var title:String
    //构造方法
    init(title: String, firstName: String, lastName: String, age: Int, gender: Gender) {
        self.title = title
        super.init(firstName: firstName, lastName: lastName, age: age, gender: gender)
    }
    
    init(title: String) {
        self.title = title
        super.init(firstName: "", lastName: "", age: 20, gender: .male)
    }
    
    //重载父类run方法
    override func run(){
        print("Teacher:\(fullName) is running!")
    }
    //遵循学校协议
    func lendBook(){
        print("Teacher:\(fullName) lead a Book!")
    }
    //重写父类的计算属性
    override var description: String {
        return "title: \(self.title), fullName: \(self.fullName), age: \(self.age), gender: \(self.gender)"
    }
}

var t1 = Teacher(title: "hello")
print(t1)

//学生类
class Student: Person {
    var stuNo: Int  //学号
    
    //构造方法
    init(stuNo: Int, firstName: String, lastName: String, age: Int, gender: Gender) {
        self.stuNo = stuNo
        super.init(firstName: firstName, lastName: lastName, age: age, gender: gender)
    }
    
    init(stuNo: Int) {
        self.stuNo = stuNo
        super.init(firstName: "", lastName: "", age: 20, gender: Gender.male)
    }
    
    //重载父类run方法
    override func run(){
        print("Student:\(fullName) is running!")
    }
    //遵循学校协议
    func lendBook(){
        print("Student:\(fullName) lead a Book!")
    }
    //重写父类的计算属性
    override var description: String {
        return "stuNo: \(self.stuNo), fullName: \(self.fullName), age: \(self.age), gender: \(self.gender)"
    }
}

var s1 = Student(stuNo: 2015110101)
print(s1)

var arr0 = [Person]()

for i in 1...4 {//生成4个Person对象
    let person = Person(firstName: "li", lastName: "\(i)", age: 40, gender: .male)
    arr0.append(person)
}

for i in 1...3 {//生成3个Teacher对象
    let teacher = Teacher(title: "hello", firstName: "zhang", lastName: "\(i)", age: 36, gender: .female)
    arr0.append(teacher)
}

for i in 1...3 {//生成3个Student对象
    let student = Student(stuNo: 2015110100 + i, firstName: "chen", lastName: "\(i)", age: 18, gender: .male)
    arr0.append(student)
}

//定义一个字典，用于统计每个类的对象个数
var dict1 = ["Person": 0, "Teacher": 0, "Student": 0]
for item in arr2 {
    if item is Teacher {
        dict1["Teacher"]! += 1
    } else if item is Student {
        dict1["Student"]! += 1
    } else {
        dict1["Person"]! += 1
    }
}

//输出字典值
for (key, value) in dict1 {
    print("\(key) has \(value) items")
}


//原始数组
print("------------------------------")
for item in arr0 {
    print(item)
}

//根据age从大到小排序
print("------------------------------")
arr0.sort { return $0.age > $1.age}
for item in arr0 {
    print(item)
}

//根据全名从前往后排序
print("------------------------------")
arr0.sort { return $0.fullName < $1.fullName}
for item in arr0 {
    print(item)
}

//根据gender和age从大往小排序
print("------------------------------")
arr0.sort { return ($0.gender > $1.gender) && ($0.age > $1.age) }
for item in arr0 {
    print(item)
}

//穷举，调用run方法和lendBook方法
print("------------------------------")
for item in arr0 {
    item.run()
    if let teacher = item as? Teacher {
        teacher.lendBook()
    } else if let student = item as? Student {
        student.lendBook()
    }
}
