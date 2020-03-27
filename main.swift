//
//  main.swift
//  MatrixUses
//
//  Created by Mateus Nobre Ferreira on 25/03/20.
//  Copyright © 2020 Mateus Nobre Ferreira. All rights reserved.
//

import Foundation

struct DataFrame {
    
    subscript(column:String)-> Array<Any> {
        get{
            assert(self.data.keys.contains(column), "Nao contem a Coluna")
            return self.data[column]!
        }
        set(newValue){
            assert(self.data.keys.contains(column), "Nao contem a Coluna")
            self.data[column]! = newValue
        }
    }
    
    subscript(column:String, line:Int)->Any{
        get{
            assert(!isOutOfIndex(column, line), "Fora do index")
            return self.data[column]![line]
        }
        set(newValue){
            assert(!isOutOfIndex(column, line), "Fora do index")
            self.data[column]![line] = newValue
        }
    }
    
    subscript(lines:[Int], columns:[String])->Any{
        
        
        get{
            var tempDic: [String: Array<Any>] = [:]
            
            for c in columns{
                tempDic[c] = []
            }
            
            for lineNum in lines {
                for c in columns{
                    tempDic[c]!.append( self.data[c]![lineNum] )
              }
            }
        
             return DataFrame(tempDic)
        }
        set(newValue){
            var tempDic: [String: Array<Any>] = [:]
                
                for c in columns{
                    tempDic[c] = []
                }
                
                for lineNum in lines {
                    for c in columns{
                        self.data[c]![lineNum] = newValue
                  }
                }
        }
    }
    
    private(set) var
        data:[String:Array<Any>],
        size:(lines:Int, columns: Int),
        columns: [String],
        indexed: Bool = true
    
    private init(_ dataInput: [String:Array<Any>], indexed ind:Bool = true) {
        data = dataInput
        columns = Array(dataInput.keys)
        size = (lines: dataInput[columns[0]]!.count, columns: columns.count)
        indexed = ind
    }
    
    static func create(_ dataInput: [String:Array<Any>], indexed ind:Bool = true) -> DataFrame?{
//        guard isAllColumnsValuesSameSize(data: dataInput) else {
//            return nil
//        }
        
        assert(isAllColumnsValuesSameSize(data: dataInput), "Dados de linhas nao estao com mesmo tamanho")
        
        return self.init(dataInput, indexed: ind)
    }
    
    subscript (values:[Bool]) -> DataFrame{
        var tempDic: [String: Array<Any>] = [:]
        
        for c in self.columns{
            tempDic[c] = []
        }
        
        for (i, value) in values.enumerated() {
            if(value){
                for c in self.columns{
                    var temp = tempDic[c]!
                    temp.append(self.data[c]![i])
                    tempDic[c] = temp
                }
            }
            else{ continue }
        }
        
        return DataFrame(tempDic)
    }
    
    public func toString() -> String{
        
        var head = ""
        var lines = ""
        
        if(self.indexed){
            head += "\t"
        }
        for c in self.columns{
            head += "\(c)\t"
        }
        head += "\n"
        
        for i in 0..<self.size.lines{
            var temp = self.indexed ? "\(i)\t" : ""
            for c in self.columns{
                temp += "\(self.data[c]![i])\t"
            }
            lines += "\(temp)\n"
        }
        return head + lines
    }
    
    public func find(_ column:Array<Any>, closure: (_ item:Int) -> Bool)->[Bool]{
        var tempRet:[Bool] = []
        for item in column{
            tempRet.append(closure(item as! Int))
        }
        return tempRet
    }
    
    private static func isAllColumnsValuesSameSize(data: [String: Array<Any>]) -> Bool{
        
        var oldValue:Array<Any>?
        
        for d in data {
            
            if (oldValue != nil) {
                guard oldValue!.count == d.value.count else {return false}
            }
            
            oldValue = d.value
        }
        
        return true
    }
    
    private func isArraySameDataSize(data: [String:Array<Any>], arr: [Int]) -> Bool {
        for d in data {
            guard d.value.count == arr.count else {return false}
        }
        return true
    }
    
    private func isOutOfIndex(_ c:String, _ l: Int)->Bool{
        var ret:Bool=false
        ((self.columns.contains(c)) && (l < self.size.lines)) ? (ret = false) : (ret = true)
        return ret
    }
    
}

/*
    Inicializa um DataFrame de Alunos, com atributos nome, nota e idade
*/

var alunos:DataFrame = DataFrame.create(["Nome":["Mateus","Nobre","Ferreira","Lucas","João"], "Nota": [7,9,5, 8, 6], "Idade":[13,14,13,13,13]], indexed: false)!


/*
    Printa o DataFrame
*/

print(alunos.toString())


/*
    Acessa Alunos com Nota maior do que 7
*/

var aprovados = alunos[alunos.find(alunos["Nota"]){ $0 >= 7 }]
print(aprovados.toString())

/*
    Altera as notas dos Alunos 0, 2 e 4
*/

alunos[[0,2,4], ["Nota"]] = 10
print(alunos.toString())

/*
    Acessa somente os nomes do DataFrame
*/

var nomes = alunos["Nome"]
print(nomes)

print()

/*
    Acessa somente os nomes das 3 primeiras linhas de Alunos
*/

var nomesFirst = alunos[[Int](0...2), ["Nome"]]
var teste = nomesFirst as! DataFrame
print(teste.toString())








//struct MatrixUses{
//
//  var data: [[Int]] = []
//
//  public enum MatrixErrors:Error {
//    case dataError
//    case dimensionsError
//    case dimensionsSquareError
//    case typeError
//  }
//
//  func toString() -> String{
//    var ret = ""
//    for line in data{
//      for i in line{
//        ret.append("\(i)\t")
//      }
//      ret.append("\n")
//    }
//    return ret
//  }
//
//  func input(_ data: [[Int]])  -> Void{
//    do{
//      try inputError(data)
//      self.data = data
//    }catch{
//      print("Linhas com dimensões inválidas")
//    }
//  }
//
////  public static func multiply(_ A: [[Int]], _ B: [[Int]]) -> [[Int]] {
////    var result: [[Int]] = []
////    var posX = 0, posY = 0
////
////    for line in A{
////      var sum = 0
////      for col in 0..<A[0].count{
////        for line in 0..<A.count{
//////          sum += line[]
////        }
////      }
////    }
////  }
//
//  private func dimensionsError(_ data: [[Int]]) -> Bool{
//    let colsFirstLineCount:Int = data[0].count
//    var error = false
//
//    for line in data{
//      let colsCount = line.count
//      if(colsFirstLineCount != colsCount){
//        error = true
//      }
//    }
//    return error
//  }
//
//  private func inputError(_ data: [[Int]])throws -> Void{
//    if(dimensionsError(data)){
//      throw MatrixErrors.dimensionsError
//    }
//  }
//
//
//}
