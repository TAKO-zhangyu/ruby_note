#https://www.youtube.com/watch?v=-hhjtDmN5xg
#レビューを受けていないノート

class Person
  #好きな食べ物が何かを、このような形式で書く。
  #最後に.freezeとすることで、変数ではなく定数だとすることができる。好きな食べ物と言う情報を変えられないようにするために、これはもう変わることのない情報なのですよという設定をする。
  FAVORITE_FOODS = ["チャーハン", "寿司", "ステーキ"].freeze

#ある人が好きな食べものを選ぶメソッドを書く。
#correctどうのこうのというメソッドを作り上げる。?を付けることで、選んだ食べ物がFAVORITE_FOODSと合致するかどうかを確かめることができる(defined?メソッド)
#selected_foodsの中身は、任意に選択した配列が入る
#FAVORITE_FOODSの中身とselected_foodsの中身が合致するのかどうかは、&で結んだ式によって確かめられる。&を使うと、合致した情報のみを表示してくれる。何も一致しないときは、nilすら返ってこない。
#&の式は、変数correct_favorite_foodsに格納してあげる。if文を書くときに、書き出しが書きやすくなる。複数形foodsにするのは、複数合致する可能性があるから。
  def correct_favorite_food?(selected_foods)
    correct_favorite_foods = FAVORITE_FOODS & selected_foods


    #.empty?を付けることで、要素がなかった場合は
    if correct_favorite_foods.empty?
      "僕の好きな食べ物はそれではありません"

    #長い文章と式の結果を表示するには、下のようなtextメソッドが便利。改行も反映されるし、#{}を入れるだけで変数を入れこむことができる。超感覚的。
    #文字列の中にに変数を入れるとき、変数の最後に.joinを付けると、変数と文字列をくっつけることができる。
    #文字列の中に長い名前の変数が入っていると見づらいので、何か別の変数を作って代入した。
    else
      text_foods = correct_favorite_foods.join("と")

      <<~TEXT 
      僕の好きな食べ物がありましたぁぁぁあー！！
      僕の好きな食べ物は、#{text_foods}です。
      TEXT
      
    end
  end
end

kamizato = Person.new

#かみざとさんの好きなものを当てられるのか。かみざとさんの好きそうなものを予想して、書き込む。
puts kamizato.correct_favorite_food?(["シナモン","パクチー","チャーハン"])