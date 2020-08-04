# Railsアソシエーション(多対多)のノート
# https://qiita.com/take18k_tech/items/afe298117e2e74827576

# メッセージに対して、いいねしているユーザーは複数いる
# ユーザーから見ると、いいねするメッセージは複数ある

# やりたいことは、User_id=1　が　Message_id=3 にいいねをする仕組みを作りたい。

# つまり、カラムでいうとUser_idとMessager_idだけを組み合わせた中間テーブルを作ればいい。

# なぜ中間テーブルが必要なのか
# 1つのカラムには複数の情報を入れることはできないから。

# 1対多のとき（この場合、ユーザーがツイートを投稿するだけのアプリの時）、1人のユーザーが3ツイート投稿したとしたらUser_id=1 が Message_id=1, id=2, id=3を投稿したという内容になる。
# 1人のユーザーから見れば自分の投稿は複数あるが、ツイートから見れば投稿主は一人のみ。なので、それぞれの関係は１つしかなく、言い換えるとMessage_id=1 の中にはUser_id=1の情報しかなく、1つのカラムにそれ以外の情報を入れることはない。

# 一方、多対多のとき（この場合、ユーザーが投稿したツイートにいいね機能が付いているアプリの時）、Message_id=1にいいねをする人はUser_id=1だけではなくて、id=2, id=3もいいねをつける可能性がある。
# そうすると、Message_id=1の中にUser_id=1, id=2, id=3も入る可能性がある。これはできない。理由は、1つのカラムには複数の情報を入れることはできないから。

# これを解決するために、多対多のときは中間テーブルを作り、この場合はUser_idとMessager_idのカラムを中間テーブルに作る。このテーブルの中で、User_id=1 + Message_id=1, User_id=1 + Message_id=2, User_id=2 + Message_id=5のような組み合わせを作る。具体的な処理は以下から。 



# 中間テーブル(Likeモデル)

t.integer :user_id, null: false, index: true
t.integer :message_id, null: false, index: true


# null: false
# これは、存在しない場合は実行しないという意味

# index: true
# 実行が早まるらしい


  timestamps
end
# の下に以下を追加
add_index :likes, [:user_id, :message_id], unique: true
# これは、いいねを重複させないために必須。同じid同士の組み合わせは１つのみ許可しますよ、という意味。
# これをしないと、ひとりのユーザーが同じメッセージに何回もいいねできてしまう。


# app/models/like.rbに移動して、

validates :user_id, presence: true, uniqueness: { scope: :message_id }
validates :message_id, presence: true

# presence: true
# これは、存在しないidは許可しないという意味。

# uniqueness: { scope: :message_id }
# これも、いいねを重複させないために必須。同じid同士の組み合わせは１つのみ許可しますよ、という意味。
# これをしないと、ひとりのユーザーが同じメッセージに何回もいいねできてしまう。

belongs_to :user
belongs_to :message

# これをバリデーションの上に書く。
# これを書いて、UserモデルとMessageモデルをつなぐ。

# user.rbに移動し、
 has_many :likes, dependent: :destroy
# を書く。

# message.rbに移動し、
has_many :likes, dependent: :destroy
# を書く。



# ちなみに「いいね!」しているユーザーを取得するには

# message.rb
has_many :liked_users, through: :likes, source: :user

# user.rb
has_many :liked_messages, through: :likes, source: :message

# これを書くだけでOK

# データベースの設定は以上で完了。
# ここからは、いいね機能を実装する。

# messages_controller.rb
@liked_message_ids = current_user.likes.pluck(:message_id)

# pluck(:カラム名)を使うと、そのカラムに関してのデータをすべて受け取れる
# 上の式で、message_idのデータをすべて並べた配列を作り、liked_message_idsに代入する式が出来る。
# それを利用して、いいねした時は★、していない時は☆と表示させる場合分けをする。

# index.html.erb
# <% if @liked_message_ids.include?(message.id) %>
#       ★
# <% else %>
#       ☆
# <% end %>


# ルーティングはこれ
resource :likes, only: [:create, :destroy]

# コントローラーを作成する
class LikesController < ApplicationController
  def create
    current_user.likes.create!(message_id: params[:message_id])
    redirect_to root_path
  end

  def destroy
    current_user.likes.find_by(message_id: params[:message_id]).destroy!
    redirect_to root_path
  end
end

# コントローラーに合わせてindex.html.erbを書き換えると

# <% if @liked_message_ids.include?(message.id) %>
#         <!-- いいね!済み -->
#         <!-- ***** 以下を修正 ***** -->
#         <%= link_to '★', message_likes_path(message), method: :delete %>
#         <!-- ***** 以上を修正 ***** -->
# <% else %>
#         <!-- いいね!していない -->
#         <!-- ***** 以下を修正 ***** -->
#         <%= link_to '☆', message_likes_path(message), method: :post %>
#         <!-- ***** 以上を修正 ***** -->
# <% end %>
