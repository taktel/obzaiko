module ItemsHelper
  def items_sorted_by(order, category_id)
    #order並び順、category_idカテゴリーで絞込み
    order ||= session[:sort_order]
    category_id ||= session[:sort_category_id]
    #カテゴリーの絞込み
    if Category.ids.include?(category_id.to_i)
      @items = Item.where(category_id: category_id)
    else
      @items = Item.all
    end
    #itemsに最後に在庫確認したときの数量(:number)と日付(:date)を追加
    #作成中
    #並び順（指定が無ければID順）
    if Item.column_names.include?(order)
      @items = @items.order(order)
    else
      @items = @items.order(:id)
    end
    #セッションにソートの情報を保存
    session[:sort_order] = order
    session[:sort_category_id] = category_id
    session[:per_page] = params[:per_page] || session[:per_page] || Item.default_per_page
    return @items.page(params[:page]).per(session[:per_page])
  end
end
