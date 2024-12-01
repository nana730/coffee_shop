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
  Customer.create!(name: "田中 一郎", email: "tanaka.ichiro@example.com", password: "111111")
  Customer.create!(name: "山田 花子", email: "yamada.hanako@example.com", password: "111111")
  Customer.create!(name: "佐藤 健", email: "sato.takeru@example.com", password: "111111")
  Customer.create!(name: "斉藤 まさき", email: "saito.masaki@example.com", password: "111111")
  Customer.create!(name: "鈴木 太郎", email: "suzuki.taro@example.com", password: "111111")
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
  "インドネシア",
  "インドネシアのコーヒーは、ボディ感がしっかりしており、口当たりが滑らかで濃厚です。濃い味わいを好む方に人気です。",
  1000, 10, 1, 4, 3, 2, 5,
  "coffee1.jpg"
)

create_product(
  "エチオピア",
  "非常にフルーティーで華やかな香りが特徴的です。特にブルーベリーやラズベリーなどのベリー系のフルーツの香りがします。酸味が非常に明るく、ボディ感は軽めで、スッキリとした飲み口が特徴です。",
  1200, 15, 1, 2, 2, 5, 1,
  "coffee2.jpg"
)

create_product(
  "コロンビア",
  "バランスの取れた味わいで、世界的に評価が高いコーヒー。
  フルーティーな味わいで、さっぱり飲みやすいです",
  1000, 5, 2, 2, 3, 4, 3,
  "coffee3.jpg"
)

create_product(
  "ブラジル",
  "甘みとナッツやチョコレートのような風味が特徴的です。まろやかで滑らかな味わいを楽しめます。中程度のボディ感と適度な酸味が特徴で、特に酸味はやわらかく、爽やかな印象を与えます。コーヒーとして飲みやすい、バランスの良い味わいです。",
  800, 20, 2, 1, 2, 3, 4,
  "coffee4.jpg"
)

create_product(
  "メキシコ",
  "酸味がやや明るいですが、エチオピアほど強くはなく、ナッツやチョコレート、キャラメルなどの風味が感じられることが多いです。ボディ感は中程度で、あまり重くなく、スッキリとした飲み口ですが、濃すぎず、軽すぎず、絶妙なバランスを保っています。",
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
  "12月の営業日",
  "明け方はかなり冷え込んできましたね。みなさん、体調管理にお気をつけください♪
    12月の営業日は、
    12/1(日) 9:00~13:00、
    12/15(日) 9:00~12:00、
    12/22(日) 9:00~12:00 となります。",
  "article1.jpg"
)

create_article(
  "アイスコーヒー",
  "私は浅煎りが得意です！！透き通った香りとフルーティーな酸味が魅力の浅煎り豆を、アイスコーヒーで楽しんでみませんか？？
  
  爽やかな後味と繊細な香りが、心をリフレッシュさせてくれます。丁寧に抽出したコーヒーが溶け出す氷とともに、変化する味わいをぜひお楽しみください。",
  "article2.jpg"
)

create_article(
  "おいしいコーヒーの淹れ方",
  "適切な分量:   
  コーヒーの味は、豆と水の割合に大きく影響されます。目安として、豆10gに対してお湯150mlがバランスの良い濃さと言われています。                                       

  お湯の温度:  
お湯は90～96℃が理想的です。沸騰直後のお湯ではなく、少し冷ましてから注ぐと雑味が抑えられます。                 
   
丁寧な抽出:  
ペーパードリップの場合、まず「蒸らし」がポイントです。挽いた豆に少量のお湯を注ぎ、約30秒蒸らします。その後、ゆっくりと「の」の字を描くようにお湯を注ぎます。ぜひあなたらしい一杯を楽しんでください!",
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
  "新しい焙煎機",
  "新しい相棒が届きました！新しい焙煎機と共に美味しいコーヒーを皆様にお届けします。お楽しみに♪",
  "article5.jpg"
)

p '==================== seeding complete ===================='
