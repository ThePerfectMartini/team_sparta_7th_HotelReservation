//
//  main.swift
//  team_sparta_7th_hotel_reservation
//
//  Created by t2023-m0078 on 2023/07/20.
//

import Foundation


// -- 변수 정의 --

// 잔고


// 메세지들


// -- 변수 정의 --

class messagesControls {
    let mainMenu =
    """

    호텔 예약 프로그램 메뉴

    1. 랜덤 금액 지급
    2. 남은 객실 정보
    3. 호텔 예약하기
    4. 나의 예약 목록
    5. 예약 목록 정렬
    6. 예약 취소하기
    7. 예약 변경하기
    8. 입출금 내역
    9. 현재 잔고 확인
    0. 프로그램 종료

    """

    func firstScreenPrint(){
        print(mainMenu)
    }
    
    func hotelPricePrint(emptyRoomList:[Int:Int]){
        print("")
        for (key, value) in emptyRoomList.sorted(by: {$0 < $1}){
            print("\(key)번 방 : 1박 \(value)원")
        }
    }

}

class inputControls{
    var inputedText:String = ""
    
    func getInputFromUser(_ text:String = "숫자를 입력하세요 : "){
        let text:String = text
        print(text,terminator: "")
        inputedText = readLine() ?? "옵셔널 nil 발생"
    }
    func getNothingButCheck(){
        print(
        """
        
        아무키나 입력하면 메인메뉴로 돌아갑니다.
        
        """)
        readLine()
    }
}

class hotelReserve {
    var currentMoney: Int = 30000
    
    var moneyLog:[Array<Int>] = []
    
    func moneyLogPrint(){
        if moneyLog.isEmpty != true {
            //[액수,입금,환불,출금]
            for i in moneyLog {
                var logMessage = "\(i[0])원 "
                switch i[1]{
                case 0:
                    logMessage += "랜덤 입금"
                case 1:
                    logMessage += "환불 입금"
                case 2:
                    logMessage += "출금"
                default:
                    logMessage = "알수없는 로그"
                }
                print(logMessage)
            }
        }else{
            print("입출금 내역이 없습니다.")
        }
        self.inputs.getNothingButCheck()
        firstScreenLoop()
        
    }
    
    func moneyLoging(amount:Int, logType:String){
        //[액수,입금,환불,출금]
        var temp:[Int] = [amount]
        switch logType{
        case "입금":
            temp.append(0)
        case "환불":
            temp.append(1)
        case "출금":
            temp.append(2)
        default:
            temp = [-1,-1]
        }
        self.moneyLog.append(temp)
    }
    
    var emptyRoomList:[Int:Int] = [1:10000,2:20000,3:30000,4:40000,5:50000]
    var reservedRoomList:[Int:Array<Int>] = [:]
    
    let messages = messagesControls()
    
    let inputs = inputControls()
    
    
    func firstScreenLoop(_ isInit:Bool = true){
        if isInit == true {
            self.messages.firstScreenPrint()
            self.inputs.getInputFromUser()
        }else{
            self.messages.firstScreenPrint()
            self.inputs.getInputFromUser("올바르지 않은 입력. 다시입력해주세요 : ")
        }
        
        switch self.inputs.inputedText {
        case "1":
            self.randomCashGet()
        case "2":
            self.hotelPriceScreen()
        case "3":
            self.reservationScreen()
        case "4":
            self.reservationInfoScreen()
        case "5":
            self.reservationInfoOrderScreen()
        case "6":
            self.reservationInfoScreen(isD: true)
        case "7":
            self.reservationInfoScreen(isC: true)
        case "8":
            self.moneyLogPrint()
        case "9":
            print("9")
        case "0":
            break
        default:
            firstScreenLoop(false)
        }
    }
    
    func randomCashGet(){
        let temp = Int.random(in: 10...50)*10000
        self.currentMoney += temp
        print("\n \(temp)원 입금")
        print(" 현재 잔고 : \(self.currentMoney)원")
        self.moneyLoging(amount: temp, logType: "입금")
        self.inputs.getNothingButCheck()
        firstScreenLoop()
    }
    
    func hotelPriceScreen(){
        self.messages.hotelPricePrint(emptyRoomList: emptyRoomList)
        self.inputs.getNothingButCheck()
        firstScreenLoop()
    }
    
    func reservationScreen(){
        var selectedData:[Int] = []
        self.messages.hotelPricePrint(emptyRoomList: emptyRoomList)
        // 함수이용해서 입력값으로 텍스트 주면 알아서 터미네이터 없이 입력받는거 만들자 - 구현완료
        print("\n 현재 \(self.currentMoney)원 있습니다.")
        self.inputs.getInputFromUser("원하는 방의 숫자를 입력하세요 : ")
        
        if self.emptyRoomList[Int(self.inputs.inputedText) ?? 0] != nil {
            //if문 이중으로 쓰고싶지 않지만 일단 임시방편으로 ..
            let key = Int(self.inputs.inputedText) ?? 0
            let value = self.emptyRoomList[key] ?? 0
            if self.currentMoney >= value {
                self.emptyRoomList[Int(self.inputs.inputedText) ?? 0] = nil
                selectedData.append(value)
                self.inputs.getInputFromUser("체크인 날짜를 입력해주세요 : ")
                selectedData.append(Int(self.inputs.inputedText) ?? 0)
                self.inputs.getInputFromUser("체크아웃 날짜를 입력해주세요 : ")
                selectedData.append(Int(self.inputs.inputedText) ?? 0)
                self.currentMoney -= value
                
                self.moneyLoging(amount: value, logType: "출금")
                
                self.reservedRoomList[key] = selectedData
                
            }else{
                print("\n 잔고가 부족합니다.")
                self.inputs.getNothingButCheck()
            }
        }else{
            print("\n 해당 방이 없거나 이미 예약되었습니다.")
            self.inputs.getNothingButCheck()
        }
        firstScreenLoop()
    }
    
    func reservationInfoScreen(isD deleteFunc:Bool = false,isC changeFunc:Bool = false){
        if self.reservedRoomList.isEmpty {
            print("\n 예약된 방이 없습니다.")
        }else{
            print("\n 예약 목록")
            for i in self.reservedRoomList {
                print(
                    " \(i.0)번 방, \(i.1[1])부터 \(i.1[2])까지 예약됨"
                )
            }
        }
        if changeFunc == true {
            self.inputs.getInputFromUser("예약 취소하실 방을 입력해주세요 : ")
            let tempRoomNumber = Int(self.inputs.inputedText) ?? 0
            if reservedRoomList[tempRoomNumber] != nil{// 선택된 방 유효한지 판정하기
                let tempList = reservedRoomList[tempRoomNumber] ?? []
                
                self.inputs.getInputFromUser("예약 변경하실 빈 방을 입력해주세요 : ")
                
                if emptyRoomList[Int(self.inputs.inputedText) ?? 0] != nil{
                    let tempPrice = emptyRoomList[Int(self.inputs.inputedText) ?? 0] ?? 0
                    let moneyDiff = tempList[0] - tempPrice // 기존방가격 - 바꿀방가격
                    if self.currentMoney + moneyDiff >= 0 {
                        self.currentMoney += moneyDiff
                        self.reservedRoomList[tempRoomNumber] = nil // 취소때 선택된 딕셔너리 지우고
                        self.reservedRoomList[Int(self.inputs.inputedText) ?? 0] = [tempPrice,tempList[1],tempList[2]]
                        self.emptyRoomList[Int(self.inputs.inputedText) ?? 0] = nil
                        
                        emptyRoomList[tempRoomNumber] = tempList[0] // 딕셔너리 추가
                        if moneyDiff < 0{
                            self.moneyLoging(amount: moneyDiff, logType: "출금") // 차액만큼
                        }else{
                            self.moneyLoging(amount: moneyDiff, logType: "환불")
                        }
                        print("\n 변경되었습니다. \n 차액은 환불되거나 추가로 인출됩니다.")
                    }else{
                        print("잔고가 부족합니다. 변경을 취소합니다.") // 잔고부족오류메세지
                    }
                }else{
                    print("\n 없는 방이거나 이미 예약된 방입니다.") // 두번째 오류메세지 (예약변경방선택)
                }
            }else{
                print("\n 잘못된 번호를 입력하셨습니다.") // 첫번째 오류메세지 (예약취소방선택)
            }
        }
        if deleteFunc == true {
            self.inputs.getInputFromUser("예약 취소하실 방을 입력해주세요 : ")
            if reservedRoomList[Int(self.inputs.inputedText) ?? 0] != nil{// 선택된 방 유효한지 판정하기
                let tempList = reservedRoomList[Int(self.inputs.inputedText) ?? 0] ?? []
                reservedRoomList[Int(self.inputs.inputedText) ?? 0] = nil // 딕셔너리 지우고
                emptyRoomList[Int(self.inputs.inputedText) ?? 0] = tempList[0] // 딕셔너리 추가
                self.currentMoney += tempList[0]
                self.moneyLoging(amount: tempList[0], logType: "환불")
                print("\n 환불되었습니다.")
            }else{
                print("\n 잘못 입력하셨습니다.")
            }
        }
        
        self.inputs.getNothingButCheck()
        firstScreenLoop()
    }
    
    func reservationInfoOrderScreen(){
        if self.reservedRoomList.isEmpty == false {
            print("\n 체크인 날짜 순으로 정렬\n")
            for i in self.reservedRoomList.sorted(by: {$0.1[1] < $1.1[1]}) {
                print(" \(i.0)번 방, \(i.1[1])부터 \(i.1[2])까지 예약됨")
            }
        }else{
            print("\n 예약 목록이 없습니다.")
        }
        self.inputs.getNothingButCheck()
        firstScreenLoop()
    }
    
    func run() {
        self.firstScreenLoop()
    }
    
}

// 함수 실행 부


var program = hotelReserve()


program.run()





print("프로그램 종료")



