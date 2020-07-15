require 'active_support/core_ext'
# 旅行会社簡易プログラム

# 0.旅行プランのデータを用意
travel_plans = [
  {name: "沖縄", price: 10000},
  {name: "東京", price: 15000},
  {name: "広島", price: 9500},
]

DISCOUNT_RATE = 0.9
DISCOUNT_NUM = 10

# 1.プランを選択：正しい値を入力しない場合、繰り返し処理
text = "旅行プランを選択してください"

travel_plans.each.with_index(1) do |travel_plan, index|
  puts "No.#{index} #{travel_plan[:name]} (¥#{travel_plan[:price]})"

while true
  print "番号を入力:"
  select_number = gets.chomp.to_i

  if select_number < 1 || 3 < select_number
  puts "1から3の値を入力してください。"
  next
 end

  break
end

plan_number = select_number -1

selected_travel_plan = travel_plans[plan_number]

puts "旅行プラン [#{selected_travel_plan[:name]}]を選択しました"

# 2.人数を入力：正しい値を入力しない場合、繰り返し処理

while true
  print "参加人数を入力:"
  number_of_people = gets.chomp.to_i

  if number_of_people < 1
    puts "人数を入力してください"
    next
  end

  break
end

puts "旅行参加人数は#{number_of_people}人です。"

# 3.人数x料金で合計額を算出

# case select_number
# when 1
#   plan_price = 10000
# when 2
#   plan_price = 15000
# when 3
#   plan_price = 9500
# end

total_charge = selected_travel_plan[:price] * number_of_people

# 4.割引処理(人数が10人以上なら割引、それ以外なら通常料金):条件分岐

#if number_of_people >= 10
#  total_charge = total_charge - (total_charge / 10)
#end

total_charge *= DISCOUNT_RATE if number_of_people >= DISCOUNT_NUM 

puts "合計金額は¥#{total_charge.floor.to_s(:delimited)}です"
end