p '==================== cleaning up ===================='
OrderItem.delete_all
Order.delete_all
CartItem.delete_all
Admin.delete_all
Customer.delete_all
Product.delete_all
Article.delete_all
p '==================== customer create ===================='
begin
  Customer.create!(name: "田中 一郎", email: "tanaka.ichiro@gmail.com", password: "111111")
  Customer.create!(name: "山田 花子", email: "yamada.hanako@gmail.com", password: "111111")
  Customer.create!(name: "佐藤 健", email: "sato.takeru@gmail.com", password: "111111")
  Customer.create!(name: "斉藤 まさき", email: "saito.masaki@gmail.com", password: "111111")
  Customer.create!(name: "鈴木 太郎", email: "suzuki.taro@gmail.com", password: "111111")
rescue ActiveRecord::RecordInvalid => e
  puts "Failed to create Customer: #{e.record.errors.full_messages}"
end

p '==================== admin create ===================='
begin
  Admin.create!(email: "admin@gmail.com", password: "1234qwer")
  Admin.create!(email: "admin2@gmail.com", password: "1234qwer")
  Admin.create!(email: "admin3@gmail.com", password: "1234qwer")
  Admin.create!(email: "admin4@gmail.com", password: "1234qwer")
  Admin.create!(email: "admin5@gmail.com", password: "1234qwer")
rescue ActiveRecord::RecordInvalid => e
  puts "Failed to create Admin: #{e.record.errors.full_messages}"
end

p '==================== product create ===================='

def create_product(name, description, price, stock, acidity, bitterness, sweetness, aroma, body, image_file)
  product = Product.new(
    name: name,
    description: description,
    price: price,
    stock: stock,
    acidity: acidity,
    bitterness: bitterness,
    sweetness: sweetness,
    aroma: aroma,
    body: body
  )
  product.image.attach(io: File.open(Rails.root.join("app/assets/images/#{image_file}")), filename: image_file)

  begin
    product.save!
  rescue ActiveRecord::RecordInvalid => e
    puts "Failed to save product #{name}: #{e.record.errors.full_messages}"
  end
end

create_product(
  "キリマンジャロ",
  "苦味は控えめで、程よい酸味が特徴です。コーヒー初心者の方にぜひ飲んでいただきたいです。",
  1000, 10, 3, 1, 3, 2, 1,
  "coffee1.jpg"
)

create_product(
  "エチオピア",
  "苦目でコクがあります。",
  1200, 15, 4, 2, 2, 5, 3,
  "coffee2.jpg"
)

create_product(
  "コロンビア",
  "バランスの取れた味わいで、世界的に評価が高いコーヒー。
  フルーティーな味わいで、さっぱり飲みやすいです",
  3000, 5, 2, 2, 3, 4, 3,
  "coffee3.jpg"
)

create_product(
  "ブルーマウンテン",
  "ザ・王道の味、癖がなく飲みやすいです。",
  800, 20, 2, 3, 4, 3, 4,
  "coffee4.jpg"
)

create_product(
  "メキシコ",
  "苦味が特徴で、さっぱりとキレがあります。",
  1500, 10, 3, 2, 4, 4, 2,
  "coffee5.jpg"
)

p '==================== cart items create ===================='
begin
  CartItem.create!(customer_id: Customer.first.id, product_id: Product.first.id, quantity: 2, bean_state: 1)
  CartItem.create!(customer_id: Customer.second.id, product_id: Product.second.id, quantity: 3, bean_state: 0)
  CartItem.create!(customer_id: Customer.third.id, product_id: Product.third.id, quantity: 1, bean_state: 1)
  CartItem.create!(customer_id: Customer.fourth.id, product_id: Product.fourth.id, quantity: 5, bean_state: 0)
  CartItem.create!(customer_id: Customer.fifth.id, product_id: Product.fifth.id, quantity: 4, bean_state: 1)
rescue ActiveRecord::RecordInvalid => e
  puts "Failed to create CartItem: #{e.record.errors.full_messages}"
end

p '==================== orders && order_items create ===================='
begin
  customers = Customer.all
  products = Product.all
  PREFECTURES = %w[北海道 青森県 岩手県 宮城県 秋田県 山形県 福島県 茨城県 栃木県 群馬県 埼玉県 千葉県 東京都 神奈川県 新潟県 富山県 石川県 福井県 山梨県 長野県 岐阜県 静岡県 愛知県 三重県 滋賀県 京都府 大阪府 兵庫県 奈良県 和歌山県 鳥取県 島根県 岡山県 広島県 山口県 徳島県 香川県 愛媛県 高知県 福岡県 佐賀県 長崎県 熊本県 大分県 宮崎県 鹿児島県 沖縄県]

  customers.each do |customer|
    # 各customerの固定情報を設定
    customer_prefecture = PREFECTURES.sample
    customer_postal_code = "#{rand(100..999)}-#{rand(1000..9999)}"
    customer_address = "#{rand(1..10)}-#{rand(1..10)}-#{rand(1..10)}"

    5.times do
      order = Order.new(
        customer_id: customer.id,
        name: customer.name,
        postal_code: customer_postal_code,
        prefecture: customer_prefecture,
        address: customer_address,
        postage: 500,
        total_amount: 0,
        status: 0
      )
      order.save!

      # ランダムに商品を選択してOrderItemを作成
      selected_products = products.sample(2) # 2つのランダムな商品を選択
      selected_products.each do |product|
        quantity = rand(1..5) # 数量は1～5の範囲でランダム
        order.order_items.create!(
          product_id: product.id,
          quantity: quantity,
          price: product.price,
          bean_state: rand(0..1) # bean_stateは0または1のランダム
        )
      end

      # 合計金額を更新
      order.update!(total_amount: order.order_items.sum(&:subtotal) + order.postage)
    end
  end

rescue ActiveRecord::RecordInvalid => e
  puts "Failed to create Order or OrderItem: #{e.record.errors.full_messages}"
end


p '==================== article create ===================='

def create_article(title, description, image_file)
  article = Article.new(
    title: title,
    description: description
  )
  article.image.attach(io: File.open(Rails.root.join("app/assets/images/#{image_file}")), filename: image_file)

  begin
    article.save!
  rescue ActiveRecord::RecordInvalid => e
    puts "Failed to save article #{title}: #{e.record.errors.full_messages}"
  end
end

create_article(
  "コーヒーの選び方",
  "初心者におすすめのコーヒー豆の選び方について。
コーヒー豆の味は産地によって異なります。まずは以下の定番産地を試してみましょう。

エチオピア：華やかな香りとフルーティな酸味が特徴。
ブラジル：ナッツやチョコレートを思わせるまろやかな甘み。
コロンビア：酸味と苦味のバランスが良く、飲みやすい。",
  "article1.jpg"
)

create_article(
  "コーヒーの淹れ方",
  "美味しいコーヒーを淹れるためのコツ。
  コーヒーの味を一定にするには、豆とお湯の分量を正確に計量することが重要です。
一般的な目安は次の通りです。

  コーヒー豆10gに対し、お湯180ml
  ※お好みに応じて分量を調整してください。
  お湯の温度に気をつける
  コーヒーを淹れる際のお湯の温度は**85〜90℃**がベストです。
  沸騰したお湯を少し冷ましてから使うことで、苦味が抑えられ、豆の風味が引き立ちます。",
  "article2.jpg"
)

create_article(
  "コーヒーの保存方法",
  "コーヒー豆を長持ちさせるための保存方法について。
  コーヒーを保存する際に注意すべきポイントは次の4つです。

  ①空気に触れさせない
  酸化を防ぐために密閉容器を使用しましょう。
  ②湿気を避ける
  湿気はカビの原因になります。乾燥した環境で保管することが重要です。
  ③直射日光を避ける
  日光に当たると風味が損なわれやすくなります。暗い場所で保管してください。
  ④高温を避ける
  熱はコーヒーの香りや味わいを劣化させるため、涼しい場所に保管しましょう。",
  "article3.jpg"
)

create_article(
  "コーヒーの種類",
  "コーヒー豆の種類について。
  浅煎り・中煎り・深煎りを試してみよう！！
  コーヒー豆は、焙煎度合いによって風味が大きく変わります。初心者には次の焙煎度を順番に試すのがおすすめです。

  浅煎り：フルーティで酸味が特徴。紅茶のような爽やかさを楽しめます。
  中煎り：バランスが良く、程よい苦味と甘みが楽しめます。初めてなら中煎りから始めるのが無難です。
  深煎り：苦味が強く、チョコレートやナッツのような濃厚な風味。ミルクや砂糖との相性も抜群です。",
  "article4.jpg"
)

create_article(
  "カフェインについて",
  "カフェインの健康への影響について説明します。
  
カフェインの主な作用
覚醒作用：
中枢神経を刺激し、眠気を覚ましたり集中力を高めたりします。

疲労感の軽減：
カフェインは疲労を感じる脳内物質「アデノシン」の働きを一時的に抑える効果があります。その結果、疲労感が軽減され、活力を感じることができます。
代謝の促進：
カフェインは脂肪の分解を助け、エネルギー消費を促進するため、運動パフォーマンスの向上に寄与するとされています。
利尿作用：
腎臓の働きを活発にし、尿の排出を促します。ただし、摂りすぎると体内の水分が不足する可能性があるので注意が必要です。
カフェインの適切な摂取量は、個人の体質や体重、年齢によって異なりますが、一般的な目安は、

成人1日あたり400mg以下
（コーヒー3〜4杯分程度）
妊婦1日あたり200mg以下
（コーヒー1〜2杯分程度）です。",
  "article5.jpg"
)

p '==================== seeding complete ===================='
