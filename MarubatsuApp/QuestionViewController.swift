//
//  QuestionViewController.swift
//  MarubatsuApp
//
//  Created by 森園王 on 2021/11/08.
//

import UIKit

class QuestionViewController: UIViewController, UITextFieldDelegate {//UITextFieldDelegateを追加
    @IBOutlet weak var questionField: UITextField!
    @IBOutlet weak var marubatsuControl: UISegmentedControl!
    var questions:[[String: Any]] = [] // <-【追加】作成した問題を保存するために使う配列
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionField.delegate = self //この１文を追加
    }

    //TOPに戻るボタンが押されたときの処理
    @IBAction func tapBackToTopButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil) //追加

    }
    //問題を保存ボタンが押されたときの処理
    @IBAction func tapSaveButton(_ sender: UIButton) {
        //問題内容のFieldが入力されているかどうか
           if questionField.text! != "" {
               var marubatsuAnswer: Bool = true

               //SegmentedControlでXが選ばれている(indexが0)とき
               if marubatsuControl.selectedSegmentIndex == 0 {
                   marubatsuAnswer = false

               } else {
                   //X以外のとき -> ○のとき
                   marubatsuAnswer = true
               }

               /* ここから追記 */
               let userDefaults = UserDefaults.standard
               questions = []

               //questionsキーで保存されてるオブジェクトがあったら
               if userDefaults.object(forKey: "questions")  != nil {
                   //読み込んで
                   questions = userDefaults.object(forKey: "questions") as! [[String: Any]]
               }
               //配列の後ろに追加
               questions.append(
                   [
                       "question": questionField.text!,
                       "answer": marubatsuAnswer
                   ])
               //保存
               userDefaults.set(questions, forKey: "questions")
               showAlert(message: "問題が保存されました")
               questionField.text = ""
               /* ここまで追記 */

           } else {
               showAlert(message: "問題文を入力してください。")
           }
    }
    //問題をすべて削除ボタンを押されたときの処理
    @IBAction func tapAllDeleteButton(_ sender: UIButton) {
        
        let userDefaults = UserDefaults.standard

        //保存されている問題と解答をすべて削除
        userDefaults.removeObject(forKey: "questions")

       /*    問題と解答を削除したので、キーが"questions"のオブジェクトの値がnilになる
        *  -> 読み込まれたときのエラーを回避するために値に空の配列を入れておく
        */
        userDefaults.set([], forKey: "questions")
        showAlert(message: "問題をすべて削除しました。")
    }
    
    func showAlert(message: String) {
           let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
           let close = UIAlertAction(title: "閉じる", style: .cancel, handler: nil)
           alert.addAction(close)
           present(alert, animated: true, completion: nil)
       }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
