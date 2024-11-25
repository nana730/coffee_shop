module ApplicationHelper
  def status_badge(status)
    # ステータスに応じてクラスを切り替え
    badge_class = case status
                  when "オーナー確認待ち"
                    "bg-info text-white"
                  when "オーナー確認済み"
                    "bg-success text-white"
                  else
                    "bg-secondary text-white" # デフォルトのスタイル
                  end

    # バッジ HTML を返す
    content_tag(:span, status, class: "badge #{badge_class}")
  end
end
